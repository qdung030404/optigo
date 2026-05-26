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
import 'package:optigo/views/home/widget/search_page.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController originController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    originController.dispose();
    destinationController.dispose();
    super.dispose();
  }
  Future<void> _handleSearch({required bool isOrigin}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchPage(
          hintText: isOrigin ? 'Nhập điểm đi' : 'Nhập điểm đến',
        ),
      ),
    );
    if (result != null && result is PlaceModel && mounted) {
      // 1. Cập nhật nội dung ô nhập liệu tương ứng
      if (isOrigin) {
        originController.text = result.description;
      } else {
        destinationController.text = result.description;
      }
      // 2. Lấy tọa độ chi tiết và cập nhật bản đồ
      final searchProvider = context.read<SearchProvider>();
      final mapProvider = context.read<MapProvider>();
      final detail = await searchProvider.getPlaceDetail(result.placeId);
      if (detail != null && mounted) {
        final latLng = LatLng(detail['lat']!, detail['lng']!);

        if (isOrigin) {
          mapProvider.setCurrentLocation(latLng);
        } else {
          await mapProvider.moveCameraAndAddMarker(latLng);
        }
        // 3. Tự động vẽ đường đi nếu đã có đủ 2 điểm
        if (mapProvider.currentLatLng != null && mapProvider.destinationLatLng != null) {
          mapProvider.getDirection();
        }
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    final user = context.select<AuthProvider, UserModel?>((p) => p.user);
    final mapProvider = context.watch<MapProvider>();

    // Tự động điền vị trí hiện tại vào ô điểm đi nếu đang trống
    if (mapProvider.currentAddress != null && originController.text.isEmpty) {
      originController.text = mapProvider.currentAddress!;
    }

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
              child: IconButton(
                icon: Icon(
                  destinationController.text.isEmpty ? Icons.search : Icons.close,
                  color: Colors.black,
                ),
                onPressed: () {
                  if (destinationController.text.isEmpty) {
                    _handleSearch(isOrigin: false);
                  } else {
                    // Xóa trạng thái và quay về chế độ bản đồ thuần túy
                    destinationController.clear();
                    context.read<MapProvider>().clearDestination();
                    context.read<MapProvider>().goToCurrentLocation();
                  }
                },
              )
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
            child: (destinationController.text.isNotEmpty)
                ? LocationInputBox(
                    destinationController: destinationController,
                    originController: originController,
                    initialOriginText: mapProvider.currentAddress,
                    onOriginTap: () {
                      _handleSearch(isOrigin: true);
                    },
                    onDestinationTap: () {
                      _handleSearch(isOrigin: false);
                    },
                  )
                : const SizedBox.shrink(),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: (destinationController.text.isNotEmpty)
                ? Visibility(
                    visible: context.watch<BookingProvider>().showBookingBottomSheet &&
                        MediaQuery.of(context).viewInsets.bottom == 0,
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
