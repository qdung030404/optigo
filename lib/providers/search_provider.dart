import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:optigo/models/place_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchProvider extends ChangeNotifier {
  final String? apiKey = dotenv.env['GOONG_API_KEY'];

  List<PlaceModel> _searchResults = [];
  List<PlaceModel> _searchHistory = [];
  bool _isSearching = false;
  String? _searchError;

  List<PlaceModel> get searchResults => _searchResults;
  List<PlaceModel> get searchHistory => _searchHistory;
  bool get isSearching => _isSearching;
  String? get searchError => _searchError;

  Timer? timeDelay;

  SearchProvider() {
    loadSearchHistory();
  }

  // ─── Search API ──────────────────────────────────────────────────────────

  Future<void> searchPlace(String input) async {
    if (input.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    _isSearching = true;
    _searchError = null;
    notifyListeners();

    final url =
        'https://rsapi.goong.io/Place/Autocomplete?api_key=$apiKey&input=${Uri.encodeComponent(input)}';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          final List predictions = data['predictions'];
          _searchResults =
              predictions.map((p) => PlaceModel.fromJson(p)).toList();
        } else {
          _searchError = 'Lỗi API: ${data['status']}';
        }
      }
    } catch (e) {
      _searchError = 'Lỗi kết nối: $e';
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }

  /// Lấy thông tin địa danh từ tọa độ (Reverse Geocoding)
  Future<PlaceModel?> getPlaceFromLatLng(double lat, double lng) async {
    final url = 'https://rsapi.goong.io/Geocode?latlng=$lat,$lng&api_key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK' && data['results'] != null && (data['results'] as List).isNotEmpty) {
          final result = data['results'][0];
          return PlaceModel(
            placeId: result['place_id'] ?? '',
            description: result['formatted_address'] ?? '',
            mainText: result['name'] ?? result['formatted_address'] ?? 'Vị trí hiện tại',
            secondaryText: result['formatted_address'] ?? '',
          );
        }
      }
    } catch (e) {
      debugPrint('Error Reverse Geocoding: $e');
    }
    return null;
  }

  /// Lấy tọa độ chi tiết từ Place ID
  Future<Map<String, double>?> getPlaceDetail(String placeId) async {
    final url =
        'https://rsapi.goong.io/Place/Detail?api_key=$apiKey&place_id=$placeId';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          final location = data['result']['geometry']['location'];
          return {
            'lat': (location['lat'] as num).toDouble(),
            'lng': (location['lng'] as num).toDouble(),
          };
        }
      }
    } catch (e) {
      debugPrint('Error getting place detail: $e');
    }
    return null;
  }

  // ─── History Logic ────────────────────────────────────────────────────────

  Future<void> loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> historyStrings = prefs.getStringList('search_history') ?? [];
    _searchHistory = historyStrings
        .map((s) => PlaceModel.fromJson(json.decode(s)))
        .toList();
    notifyListeners();
  }

  Future<void> addToHistory(PlaceModel place) async {
    // Xóa nếu đã tồn tại (dựa trên placeId) để đưa lên đầu
    _searchHistory.removeWhere((p) => p.placeId == place.placeId);
    _searchHistory.insert(0, place);
    
    if (_searchHistory.length > 10) {
      _searchHistory = _searchHistory.sublist(0, 10);
    }

    final prefs = await SharedPreferences.getInstance();
    final List<String> historyStrings = _searchHistory
        .map((p) => json.encode(p.toJson()))
        .toList();
    await prefs.setStringList('search_history', historyStrings);
    notifyListeners();
  }

  void clearResults() {
    _searchResults = [];
    notifyListeners();
  }

  Future<void> clearHistory() async {
    _searchHistory = [];
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('search_history');
    notifyListeners();
  }
}