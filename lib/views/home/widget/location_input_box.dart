import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:optigo/providers/map_provider.dart';
import 'package:optigo/providers/search_provider.dart';
import 'package:optigo/views/home/widget/search_location_widget.dart';
import 'package:optigo/models/place_model.dart';
import 'package:provider/provider.dart';

class LocationInputBox extends StatefulWidget {
  final String? initialDestinationText;
  final String? initialOriginText;
  final Function(PlaceModel)? onDestinationSelected;
  /// Controller cho ô điểm đến (TextEditingController)
  final TextEditingController? destinationController;
  /// Controller cho ô điểm đi (TextEditingController)
  final TextEditingController? originController;

  const LocationInputBox({
    super.key,
    this.initialDestinationText,
    this.initialOriginText,
    this.onDestinationSelected,
    this.destinationController,
    this.originController,
  });

  @override
  State<LocationInputBox> createState() => _LocationInputBoxState();
}

class _LocationInputBoxState extends State<LocationInputBox> {
  // SearchProvider riêng để lấy placeDetail — không share với SearchProvider global
  late final SearchProvider _detailProvider;

  @override
  void initState() {
    super.initState();
    _detailProvider = SearchProvider();
  }

  @override
  void dispose() {
    _detailProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width - 32,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              const Icon(Icons.circle, color: Colors.yellowAccent, size: 30),
              Image.asset('assets/images/vertical_dotted_line.png'),
              const Icon(Icons.location_pin, color: Colors.redAccent, size: 30),
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              children: [
                // ── Điểm đi ──────────────────────────────────────────────
                SearchLocationWidget(
                  hintText: 'Vị trí của bạn',
                  controller: widget.originController,
                  initialText: widget.initialOriginText,
                  onSelected: (place) async {
                    final mapProvider = context.read<MapProvider>();
                    final detail =
                        await _detailProvider.getPlaceDetail(place.placeId);
                    if (detail != null && mounted) {
                      mapProvider.setCurrentLocation(
                        LatLng(detail['lat']!, detail['lng']!),
                      );
                      // Chỉ vẽ đường nếu cả 2 điểm đã được chọn
                      if (mapProvider.destinationLatLng != null) {
                        mapProvider.getDirection();
                      }
                    }
                  },
                ),
                const Divider(height: 1, color: Colors.grey),
                // ── Điểm đến ─────────────────────────────────────────────
                SearchLocationWidget(
                  hintText: 'Nhập điểm đến',
                  controller: widget.destinationController,
                  initialText: widget.initialDestinationText,
                  onSelected: (place) async {
                    widget.onDestinationSelected?.call(place);
                    final mapProvider = context.read<MapProvider>();
                    final detail =
                        await _detailProvider.getPlaceDetail(place.placeId);
                    if (detail != null && mounted) {
                      await mapProvider.moveCameraAndAddMarker(
                        LatLng(detail['lat']!, detail['lng']!),
                      );
                      // Chỉ vẽ đường nếu cả 2 điểm đã được chọn
                      if (mapProvider.currentLatLng != null) {
                        mapProvider.getDirection();
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
