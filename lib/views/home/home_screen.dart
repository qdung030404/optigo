import 'dart:async';

import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:optigo/models/booking_model.dart';
import 'package:optigo/models/place_model.dart';
import 'package:optigo/models/user_model.dart';
import 'package:optigo/providers/auth_provider.dart';
import 'package:optigo/providers/booking_provider.dart';
import 'package:optigo/providers/map_provider.dart';
import 'package:optigo/providers/search_provider.dart';
import 'package:optigo/providers/trip_provider.dart';
import 'package:optigo/services/notification_service.dart';
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

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final TextEditingController originController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();

  late AnimationController _searchBarAnimationController;
  late Animation<double> _searchBarFadeAnimation;

  @override
  void initState() {
    super.initState();
    _searchBarAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _searchBarFadeAnimation = CurvedAnimation(
      parent: _searchBarAnimationController,
      curve: Curves.easeOut,
    );
    _searchBarAnimationController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookingProvider>().onBookingStatusChanged = (booking) {
        if (mounted) {
          _showNotification(booking);
        }
      };
    });
  }

  @override
  void dispose() {
    originController.dispose();
    destinationController.dispose();
    _searchBarAnimationController.dispose();
    super.dispose();
  }

  void _showNotification(BookingModel booking) {
    String title = '';
    String body = '';
    switch (booking.status) {
      case BookingStatus.confirmed:
        title = 'Chuyến đi đã xác nhận';
        body = 'Tài xế đã chấp nhận yêu cầu ghép chuyến của bạn.';
        break;
      case BookingStatus.cancelled:
        if (booking.isExpired) {
          title = 'Yêu cầu hết hạn';
          body = 'Yêu cầu ghép chuyến đã hết hạn do tài xế không phản hồi.';
        } else {
          title = 'Yêu cầu bị từ chối';
          body = 'Tài xế đã từ chối yêu cầu ghép chuyến của bạn.';
        }
        break;
      default:
        return;
    }
    if (title.isNotEmpty) {
      NotificationService().showNotification(
        title: title,
        body: body,
      );
    }
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
      if (isOrigin) {
        originController.text = result.description;
      } else {
        destinationController.text = result.description;
        context.read<TripProvider>().searchCtrl.text = result.description;
      }
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
        if (mapProvider.currentLatLng != null &&
            mapProvider.destinationLatLng != null) {
          mapProvider.getDirection();
        }
      }
      context.read<TripProvider>().searchCtrl.text = result.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.select<AuthProvider, UserModel?>((p) => p.user);
    final mapProvider = context.watch<MapProvider>();
    final hasDestination = destinationController.text.isNotEmpty;

    if (mapProvider.currentAddress != null && originController.text.isEmpty) {
      originController.text = mapProvider.currentAddress!;
    }

    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      drawer: BuildDrawer(user: user),
      body: Stack(
        children: [
          // ── Full screen map ──────────────────────────────────────────────
          BuildMap(),

          // ── Floating top bar ─────────────────────────────────────────────
          Positioned(
            top: topPadding + 12,
            left: 16,
            right: 16,
            child: FadeTransition(
              opacity: _searchBarFadeAnimation,
              child: !hasDestination
                  ? _buildFloatingSearchBar(context, user)
                  : LocationInputBox(
                      destinationController: destinationController,
                      originController: originController,
                      initialOriginText: mapProvider.currentAddress,
                      onOriginTap: () => _handleSearch(isOrigin: true),
                      onDestinationTap: () => _handleSearch(isOrigin: false),
                    ),
            ),
          ),

          // ── Clear destination button (shown when destination is set) ─────
          if (hasDestination)
            Positioned(
              top: topPadding + 12,
              right: 16,
              child: _buildClearButton(context),
            ),

          // ── Booking bottom sheet ─────────────────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: hasDestination
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

  Widget _buildFloatingSearchBar(BuildContext context, UserModel? user) {
    return Row(
      children: [
        // Avatar / Menu button
        Builder(
          builder: (ctx) => GestureDetector(
            onTap: () => Scaffold.of(ctx).openDrawer(),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.person, color: Color(0xff176bac)),
            ),
          ),
        ),
        const SizedBox(width: 12),

        // Search pill
        Expanded(
          child: GestureDetector(
            onTap: () => _handleSearch(isOrigin: false),
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Color(0xff176bac), size: 20),
                  const SizedBox(width: 10),
                  Text(
                    'Bạn muốn đi đâu?',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildClearButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        destinationController.clear();
        context.read<MapProvider>().clearDestination();
        context.read<MapProvider>().goToCurrentLocation();
        setState(() {});
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const Icon(Icons.close, color: Colors.black54, size: 20),
      ),
    );
  }

  Widget listTileItem(
      VoidCallback onTap, IconData icon, PlaceModel place, Color color) {
    return ListTile(
      leading: Icon(icon, color: color),
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
