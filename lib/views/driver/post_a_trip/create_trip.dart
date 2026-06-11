import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:optigo/models/trip_model.dart';
import 'package:optigo/providers/trip_provider.dart';
import 'package:optigo/views/driver/post_a_trip/widget/notify_dialog.dart';
import 'package:optigo/views/driver/post_a_trip/widget/number_of_seats.dart';
import 'package:optigo/views/driver/post_a_trip/widget/trip_form.dart';
import 'package:provider/provider.dart';

class CreateTrip extends StatefulWidget {
  const CreateTrip({super.key});

  @override
  State<CreateTrip> createState() => _CreateTripState();
}

class _CreateTripState extends State<CreateTrip> {
  String? originNameDescription;
  String? destinationNameDescription;
  LatLng? originLatLng;
  LatLng? destinationLatLng;



  DateTime? departureTime;
  int? seats;
  int? price;

  String? get uid => FirebaseAuth.instance.currentUser?.uid;
  void _showNotifyDialog(
      {required String title,required String buttonText,required IconData icon,required VoidCallback onTap}){
    showDialog(context: context, builder: (_) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: NotifyDialog(title: title, icon: icon, onTap: onTap, buttonText: buttonText,),
    ) );
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
          'Chi tiết chuyến đi',
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
              originName: originNameDescription,
              destinationName: destinationNameDescription,
              onPickupSelected: (desc, lat, long) {
                setState(() {
                  originNameDescription = desc;
                  originLatLng = LatLng(lat, long);
                });
              },
              onDestinationSelected: (desc, lat, long) {
                setState(() {
                  destinationNameDescription = desc;
                  destinationLatLng = LatLng(lat, long);
                });
              },
              onDateTimeChanged: (DateTime dateTime) {
                setState(() {
                  departureTime = dateTime;
                });
              },
              onSeatsSelected: (CarType? value) {
                setState(() {
                  seats = value?.numberOfSeats;
                });
              },
              onPriceChanged: (int? value) {
                setState(() {
                  price = value;
                });
              },
            ),
            SizedBox(height: 32.h),
            // Book Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: tripProvider.isLoading
                    ? null
                    : () async {
                        if (originLatLng == null ||
                            destinationLatLng == null ||
                            departureTime == null ||
                            price == null ||
                            seats == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Vui lòng điền đầy đủ thông tin')),
                          );
                          return;
                        }

                        // Lấy polyline
                        final polyline = await tripProvider.fetchRoutePolyline(
                            originLatLng!, destinationLatLng!);

                        if (polyline == null) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(tripProvider.errorMessage ??
                                    'Lỗi lấy thông tin đường đi'),
                              ),
                            );
                          }
                          return;
                        }

                        final tripData = TripModel(
                          id: null,
                          driverId: uid ?? '',
                          originName: originNameDescription!,
                          destinationName: destinationNameDescription!,
                          originLat: originLatLng!.latitude,
                          originLng: originLatLng!.longitude,
                          destinationLat: destinationLatLng!.latitude,
                          destinationLng: destinationLatLng!.longitude,
                          routePolyline: polyline,
                          price: price!,
                          totalSeats: seats!,
                          availableSeats: seats!,
                          departureTime: departureTime!,
                          status: TripStatus.open,
                        );

                        final success =
                            await tripProvider.createTrip(tripData);

                        if (success) {
                          if (context.mounted) {
                            _showNotifyDialog(title: 'Tạo chuyến đi thành công', buttonText: 'Quay lại trang chủ', icon: Icons.check_circle, onTap: () => Navigator.pop(context));
                          }
                        } else {
                          if (context.mounted) {
                            _showNotifyDialog(title: 'Tạo chuyến đi thất bại', buttonText: 'Thử lại', icon: Icons.error, onTap: () => Navigator.pop(context));
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
                        'Đặt chuyến',
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
