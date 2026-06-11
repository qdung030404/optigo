import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:optigo/models/trip_model.dart';
import 'package:optigo/providers/trip_provider.dart';
import 'package:optigo/views/driver/post_a_trip/widget/number_of_seats.dart';
import 'package:optigo/views/driver/post_a_trip/widget/trip_form.dart';
import 'package:optigo/views/driver/post_a_trip/widget/notify_dialog.dart';
import 'package:provider/provider.dart';

class EditTrip extends StatefulWidget {
  final TripModel trip;

  const EditTrip({super.key, required this.trip});

  @override
  State<EditTrip> createState() => _EditTripState();
}

class _EditTripState extends State<EditTrip> {
  late DateTime departureTime;
  late int seats;
  late int price;

  @override
  void initState() {
    super.initState();
    departureTime = widget.trip.departureTime;
    seats = widget.trip.totalSeats;
    price = widget.trip.price;
  }

  void _showNotifyDialog({
    required String title,
    required String buttonText,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: NotifyDialog(
          title: title,
          icon: icon,
          onTap: onTap,
          buttonText: buttonText,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tripProvider = Provider.of<TripProvider>(context);
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
          'Chỉnh sửa chuyến đi',
          style: GoogleFonts.lexend(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            TripForm(
              isEdit: true,
              initialDepartureTime: departureTime,
              initialCarType: CarType.fromSeats(seats),
              initialPrice: price,
              onDateTimeChanged: (dateTime) {
                setState(() {
                  departureTime = dateTime;
                });
              },
              onSeatsSelected: (value) {
                setState(() {
                  seats = value?.numberOfSeats ?? seats;
                });
              },
              onPriceChanged: (value) {
                setState(() {
                  price = value ?? price;
                });
              },
            ),
            SizedBox(height: 32.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: tripProvider.isLoading
                    ? null
                    : () async {
                        final updatedTrip = TripModel(
                          id: widget.trip.id,
                          driverId: widget.trip.driverId,
                          originName: widget.trip.originName,
                          destinationName: widget.trip.destinationName,
                          originLat: widget.trip.originLat,
                          originLng: widget.trip.originLng,
                          destinationLat: widget.trip.destinationLat,
                          destinationLng: widget.trip.destinationLng,
                          routePolyline: widget.trip.routePolyline,
                          price: price,
                          totalSeats: seats,
                          availableSeats: widget.trip.availableSeats, // Sẽ được tính lại trong provider
                          departureTime: departureTime,
                          status: widget.trip.status,
                        );

                        final success = await tripProvider.updateTrip(updatedTrip);

                        if (success) {
                          if (context.mounted) {
                            _showNotifyDialog(
                              title: 'Cập nhật thành công',
                              buttonText: 'Quay lại',
                              icon: Icons.check_circle,
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                                context.read<TripProvider>().loadTripsByDriverId(widget.trip.driverId);
                              },
                            );
                          }
                        } else {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(tripProvider.errorMessage ?? 'Cập nhật thất bại')),
                            );
                          }
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xfffedd59),
                  foregroundColor: const Color(0xff176bac),
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 0,
                ),
                child: tripProvider.isLoading
                    ? const CircularProgressIndicator(color: Color(0xff176bac))
                    : Text(
                        'Lưu thay đổi',
                        style: GoogleFonts.lexend(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
