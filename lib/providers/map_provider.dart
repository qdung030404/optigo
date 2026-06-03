import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:optigo/providers/search_provider.dart';
import 'package:permission_handler/permission_handler.dart';

enum MapType { initial, locating, locationError }

class MapProvider extends ChangeNotifier {
  static String get goongStyleUrl {
    final key = dotenv.env['GOONG_MAPTILES_KEY'] ?? '';
    return 'https://tiles.goong.io/assets/goong_map_highlight.json?api_key=$key';
  }

  MapType _mapType = MapType.initial;
  MapType get mapType => _mapType;

  // Tách riêng trạng thái Style đã load xong
  bool _isStyleLoaded = false;
  bool get styleLoaded => _isStyleLoaded;

  MapLibreMapController? _controller;
  String? _locationError;
  Symbol? _destinationPoint;
  LatLng? currentLatLng;
  LatLng? destinationLatLng;
  String? _currentAddress;
  String? get currentAddress => _currentAddress;
  double? routeDistanceKm;
  double? get routeDistance => routeDistanceKm;
  String? routeDurationText;
  String? get routeDuration => routeDurationText;
  List<LatLng> _userRoutePoints = [];

  List<LatLng> get userRoutePoints => _userRoutePoints;

  /// Cập nhật vị trí hiện tại và thông báo cho listeners
  void setCurrentLocation(LatLng latLng) {
    currentLatLng = latLng;
    notifyListeners();
  }


  bool get locating => mapType == MapType.locating;
  String? get locationError => _locationError;
  MapLibreMapController? get controller => _controller;

  SearchProvider? _searchProvider;

  void update(SearchProvider searchProvider) {
    _searchProvider = searchProvider;
  }

  // Trạng thái vẽ đường
  bool _isLineAdded = false;
  static const String _lineSourceId = "line_source";
  static const String _lineLayerId = "line_layer";

  // ─── Map lifecycle ────────────────────────────────────────────────────────

  void onMapCreated(MapLibreMapController controller) {
    _controller = controller;
    _isLineAdded = false;
    notifyListeners();
  }

  Future<void> onStyleLoaded() async {
    _isStyleLoaded = true;

    try {
      final ByteData bytes = await rootBundle.load("assets/images/locationEnd.png");
      final Uint8List list = bytes.buffer.asUint8List();
      await _controller?.addImage("location-end-icon", list);
    } catch (e) {
      debugPrint("Lỗi nạp icon marker: $e");
    }

    notifyListeners();
    await goToCurrentLocation();
  }

  // ─── Location & Markers ───────────────────────────────────────────────────

  Future<void> goToCurrentLocation() async {
    _mapType = MapType.locating;
    _locationError = null;
    notifyListeners();

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _locationError = 'GPS đang tắt. Vui lòng bật GPS và thử lại.';
        return;
      }

      // Kiểm tra quyền truy cập vị trí (Dùng permission_handler cho đồng bộ)
      var status = await Permission.location.status;
      if (!status.isGranted) {
        status = await Permission.location.request();
        if (!status.isGranted) {
          _locationError = 'Quyền truy cập vị trí bị từ chối.';
          return;
        }
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      final latLng = LatLng(position.latitude, position.longitude);

      currentLatLng = latLng;


      await _controller?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: latLng, zoom: 15),
        ),
      );

      // Lấy địa chỉ từ SearchProvider đã được inject
      if (_searchProvider != null) {
        final currentPlace = await _searchProvider!.getPlaceFromLatLng(
          position.latitude,
          position.longitude,
        );
        if (currentPlace != null) {
          _currentAddress = currentPlace.description;
          debugPrint("Địa chỉ hiện tại: $_currentAddress");
        }
      }
    } catch (e) {
      _mapType = MapType.locationError;
      _locationError = 'Không thể lấy vị trí: $e';
    } finally {
      _mapType = MapType.initial;
      notifyListeners();
    }
  }

  /// Di chuyển camera và cắm marker tại tọa độ bất kỳ
  Future<void> moveCameraAndAddMarker(LatLng latLng, {double zoom = 15}) async {
    if (_controller == null) return;

    if (_destinationPoint != null) {
      await _controller!.removeSymbol(_destinationPoint!);
    }

    _destinationPoint = await _controller!.addSymbol(
      SymbolOptions(
        geometry: latLng,
        iconImage: 'location-end-icon', // Sử dụng icon đã nạp
        iconSize: 0.3 // Điều chỉnh size cho phù hợp với ảnh PNG
      ),
    );
    destinationLatLng = latLng;


    await _controller!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: latLng,
          zoom: zoom,
        ),
      ),
    );
    notifyListeners();
  }

  /// Xóa điểm đến và đường đi
  void clearDestination() {
    if (_destinationPoint != null) {
      _controller?.removeSymbol(_destinationPoint!);
      _destinationPoint = null;
    }
    destinationLatLng = null;
    _userRoutePoints = [];
    if (_isLineAdded) {
      _controller?.setGeoJsonSource(_lineSourceId, {
        "type": "FeatureCollection",
        "features": [],
      });
    }
    notifyListeners();
  }
  Future<void> getDirection() async {
    try {
      if (currentLatLng != null && destinationLatLng != null) {
        final apiKey = dotenv.env['GOONG_API_KEY'];
        final url = 'https://rsapi.goong.io/Direction?origin=${currentLatLng!.latitude},${currentLatLng!.longitude}&destination=${destinationLatLng!.latitude},${destinationLatLng!.longitude}&vehicle=car&api_key=$apiKey';

        var response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);

          // Kiểm tra list routes có dữ liệu hay không trước khi truy cập
          if (data['routes'] != null && (data['routes'] as List).isNotEmpty) {
            final routeData = data['routes'][0];
            final leg = routeData['legs'][0];
            var route = routeData['overview_polyline']['points'];
            routeDistanceKm = (leg['distance']['value'] as num) / 1000.0;
            routeDurationText = leg['duration']['text'];
            List<PointLatLng> result = PolylinePoints.decodePolyline(route);
            _userRoutePoints = result.map((point) => LatLng(point.latitude, point.longitude)).toList();
            List<List<double>> coordinates = result.map((point) => [point.longitude, point.latitude]).toList();
            _drawLine(coordinates);
          }

        }
      }
    } catch (e) {
      debugPrint('Error getting direction: $e');
    }
  }

  Future<void> _drawLine(List<List<double>> coordinates) async {
    if (_controller == null || coordinates.isEmpty) return;

    final geoJsonData = {
      "type": "FeatureCollection",
      "features": [
        {
          "type": "Feature",
          "properties": {},
          "geometry": {
            "type": "LineString",
            "coordinates": coordinates,
          },
        },
      ],
    };

    if (_isLineAdded) {
      await _controller?.setGeoJsonSource(_lineSourceId, geoJsonData);
    } else {
      await _controller?.addSource(
        _lineSourceId,
        GeojsonSourceProperties(data: geoJsonData),
      );

      await _controller?.addLineLayer(
        _lineSourceId,
        _lineLayerId,
        const LineLayerProperties(
          lineColor: "#4A90E2",
          lineWidth: 6,
          lineCap: "round",
          lineJoin: "round",
        ),
      );
      _isLineAdded = true;
    }

    // Zoom để thấy toàn bộ tuyến đường
    _zoomToFit(coordinates);
  }

  void _zoomToFit(List<List<double>> coordinates) {
    if (coordinates.isEmpty) return;

    double minLat = coordinates[0][1];
    double maxLat = coordinates[0][1];
    double minLng = coordinates[0][0];
    double maxLng = coordinates[0][0];

    for (var coord in coordinates) {
      if (coord[1] < minLat) minLat = coord[1];
      if (coord[1] > maxLat) maxLat = coord[1];
      if (coord[0] < minLng) minLng = coord[0];
      if (coord[0] > maxLng) maxLng = coord[0];
    }

    _controller?.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(minLat, minLng),
          northeast: LatLng(maxLat, maxLng),
        ),
        left: 64,
        top: 200, // Tránh bị AppBar che
        right: 64,
        bottom: 250, // Tránh bị các nút bấm che
      ),
    );
  }

  void clearLocationError() {
    _locationError = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}