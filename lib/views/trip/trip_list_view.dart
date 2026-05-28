import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:optigo/config/routes.dart';
import 'package:optigo/providers/trip_provider.dart';
import 'package:optigo/views/trip/widget/trip_list_widget/trip_list_card.dart';
import 'package:provider/provider.dart';

class TripListView extends StatefulWidget {
  const TripListView({super.key});

  @override
  State<TripListView> createState() => _TripListViewState();
}

class _TripListViewState extends State<TripListView> {
  Future<void> _onRefresh() async {
    await context.read<TripProvider>().loadAllTrips();
  }

  @override
  Widget build(BuildContext context) {
    final tripProvider = context.watch<TripProvider>();
    final trips = tripProvider.trips;

    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Chuyến đi sẵn có',
          style: GoogleFonts.lexend(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: const Color(0xff176bac),
        child: trips.isEmpty
            ? _buildEmptyState()
            : ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(16.w),
                itemCount: trips.length,
                itemBuilder: (context, index) {
                  final trip = trips[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        Routes.tripDetail,
                        arguments: trip,
                      );
                    },
                    child: TripListCard(trip: trip)
                  );
                },
              ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.directions_car_filled_outlined,
            size: 80.sp,
            color: Colors.grey[300],
          ),
          SizedBox(height: 16.h),
          Text(
            'Không tìm thấy chuyến đi nào',
            style: GoogleFonts.lexend(fontSize: 16.sp, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
