import 'dart:async';

import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:optigo/models/place_model.dart';
import 'package:optigo/models/user_model.dart';
import 'package:optigo/providers/auth_provider.dart';
import 'package:optigo/providers/booking_provider.dart';
import 'package:optigo/providers/map_provider.dart';
import 'package:optigo/providers/search_provider.dart';
import 'package:optigo/views/home/widget/build_drawer.dart';
import 'package:optigo/views/home/widget/build_map.dart';
import 'package:optigo/views/home/widget/location_input_box.dart';
import 'package:optigo/views/home/widget/booking_bottomsheet/booking_bottomsheet.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? timeDebounce;
  final SearchController searchController = SearchController();
  final TextEditingController originController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Lắng nghe sự thay đổi của text để gọi API tìm kiếm
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    originController.dispose();
    destinationController.dispose();
    timeDebounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (timeDebounce?.isActive ?? false) timeDebounce!.cancel();
    timeDebounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {}); // Đảm bảo AppBar cập nhật khi text thay đổi
      }
      if (searchController.text.isNotEmpty) {
        if (!mounted) return;
        context.read<SearchProvider>().searchPlace(searchController.text);
      }
    });
  }

  void searchToggle(
    BuildContext context,
    PlaceModel place,
    SearchController controller,
  ) async {
    final searchProvider = context.read<SearchProvider>();
    final mapProvider = context.read<MapProvider>();
    controller.closeView(place.description);
    // Đồng bộ text vào destinationController để LocationInputBox hiển thị đúng
    destinationController.text = place.description;
    searchProvider.addToHistory(place);

    final detail = await searchProvider.getPlaceDetail(place.placeId);
    if (detail != null && mounted) {
      final latLng = LatLng(detail['lat']!, detail['lng']!);
      await mapProvider.moveCameraAndAddMarker(latLng);
      if (mapProvider.currentLatLng != null) {
        mapProvider.getDirection();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.select<AuthProvider, UserModel?>((p) => p.user);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Builder(
            builder: (context) => Container(
              decoration: BoxDecoration(
                color: const Color(0xffFFF1B1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: IconButton(
                icon: const Icon(Icons.menu, color: Colors.black),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xffFFF1B1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: SearchAnchor(
                searchController: searchController,
                builder: (context, controller) {
                  return IconButton(
                    icon: Icon(
                      controller.text.isEmpty ? Icons.search : Icons.clear,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      if (controller.text.isEmpty) {
                        controller.openView();
                      } else {
                        final mapProvider = context.read<MapProvider>();
                        controller.clear();
                        mapProvider.clearDestination();
                        mapProvider.goToCurrentLocation();
                      }
                    },
                  );
                },
                suggestionsBuilder: (context, controller) {
                  final searchProvider = context.read<SearchProvider>();
                  final results = searchProvider.searchResults;

                  if (controller.text.isEmpty) {
                    final history = searchProvider.searchHistory;
                    if (history.isEmpty) {
                      return [const ListTile(title: Text('Nhập để tìm kiếm'))];
                    }
                    return [
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Gần đây',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      ...history.map(
                        (place) => listTileItem(
                          () => searchToggle(context, place, controller),
                          Icons.history,
                          place,
                          Colors.grey,
                        ),
                      ),
                      TextButton(
                        onPressed: () => searchProvider.clearHistory(),
                        child: const Text('Xóa lịch sử'),
                      ),
                    ];
                  }

                  if (results.isEmpty && !searchProvider.isSearching) {
                    return [
                      const ListTile(title: Text('Không tìm thấy kết quả')),
                    ];
                  }
                  return results
                      .map(
                        (place) => listTileItem(
                          () => searchToggle(context, place, controller),
                          Icons.location_on_outlined,
                          place,
                          Colors.red,
                        ),
                      )
                      .toList();
                },
              ),
            ),
          ),
        ],
      ),
      drawer: BuildDrawer(user: user),
      body: Stack(
        children: [
          BuildMap(),
          Positioned(
            top: MediaQuery.of(context).padding.top + 60,
            left: 16,
            right: 16,
            child: (searchController.text.isNotEmpty)
                ? LocationInputBox(
                    destinationController: destinationController,
                    originController: originController,
                    initialOriginText: context.read<MapProvider>().currentAddress,
                  )
                : const SizedBox.shrink(),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: (searchController.text.isNotEmpty)
                ? Visibility(
                    visible: context.watch<BookingProvider>().showBookingBottomSheet,
                    child: const BookingBottomsheet(),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget listTileItem(VoidCallback onTap, IconData icon, PlaceModel place, Color color) {
    return ListTile(
      leading: Icon(icon, color: color,),
      title: Text(place.mainText),
      subtitle: Text(
        place.secondaryText,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: onTap,
    );
  }
}
