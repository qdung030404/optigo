import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:optigo/config/routes.dart';
import 'package:optigo/models/booking_model.dart';
import 'package:optigo/models/trip_model.dart';
import 'package:optigo/providers/booking_provider.dart';
import 'package:optigo/utils/address_utils.dart';
import 'package:optigo/views/booking/widget/cancel_booking_dialog.dart';
import 'package:optigo/views/booking/widget/card_body.dart';
import 'package:optigo/views/booking/widget/card_footer.dart';
import 'package:optigo/views/booking/widget/card_header.dart';
import 'package:optigo/views/booking/widget/driver_infomation.dart';
import 'package:provider/provider.dart';

class BookingDetailScreen extends StatefulWidget {
  const BookingDetailScreen({super.key});

  @override
  State<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  late TripModel trip; // hứa sẽ gán giá trị sau
  late BookingModel booking;
  var f = NumberFormat('#,###', 'vi_VN');
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args is Map<String, dynamic>) {
      trip = args['trip'] as TripModel;
      booking = args['booking'] as BookingModel;
    } else {
      debugPrint(
        'LỖI: Dữ liệu truyền sang BookingDetailScreen không đúng định dạng Map',
      );
    }
  }

  void _showCancelDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        final bookingProvider = context.read<BookingProvider>();
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: CancelBookingDialog(
            onPressed: bookingProvider.isLoading
                ? null
                : () async {
                    await bookingProvider.cancelBooking(booking);
                    if (!context.mounted) return;
                    Navigator.popUntil(
                      context,
                      ModalRoute.withName(Routes.bookingManager),
                    );
                    bookingProvider.loadBookings();
                  },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final key = dotenv.env['GOONG_API_KEY'] ?? '';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết đặt chỗ'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
        ),
        elevation: 8,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CardHeader(
              code: booking.id.toString(),
              status: booking.status,
              isReadOnly: false,
            ),
            SizedBox(height: 16.h),
            _buildContainer(
              Column(
                children: [
                  CardBody(
                    from: AddressUtils.getLast(trip.originName),
                    to: AddressUtils.getLast(trip.destinationName),
                    pickup: booking.pickupLocation!,
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(
                      vertical: 16.h,
                      horizontal: 20.w,
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 10.h,
                      horizontal: 20.w,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: Colors.grey[300],
                    ),
                    child: CardFooter(
                      date: DateFormat('dd/MM/yyyy').format(trip.departureTime),
                      time: DateFormat('HH:mm').format(trip.departureTime),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            _buildContainer(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
                    child: Text(
                      'Thông tin tài xế',
                      style: GoogleFonts.lexend(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DriverInfomation(
                    driverName: trip.driverName!,
                    driverLicensePlate: trip.driverLicensePlate!,
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                _buildCard('SL hành khách', '${booking.numberOfPassengers}'),
                _buildCard(
                  'Tổng giá vé',
                  '${f.format(booking.totalFare)} VND',
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.all(16.sp),
              height: MediaQuery.of(context).size.height * 0.4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.network(
                  'https://rsapi.goong.io/staticmap/route?origin=${trip.originLat},${trip.originLng}&destination=${trip.destinationLat},${trip.destinationLng}&vehicle=car&api_key=$key',
                  fit: BoxFit.cover,
                  // Thêm loadingBuilder để hiện loading khi đang tải ảnh
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  // Thêm errorBuilder nếu sai Key hoặc lỗi mạng
                  errorBuilder: (context, error, stackTrace) =>
                      const Center(child: Icon(Icons.map_outlined)),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16.sp),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => context.read<BookingProvider>().contactDriver(trip.driverPhone!) ,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xfffedd59),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    side: BorderSide.none,
                  ),
                ),
                icon: Icon(
                  Icons.phone_outlined,
                  size: 24.sp,
                  color: const Color(0xff176bac),
                ),
                label: Text(
                  'Liên hệ tài xế',
                  style: GoogleFonts.lexend(
                    fontSize: 16.sp,
                    color: const Color(0xff176bac),
                  ),
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _showCancelDialog(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    side: BorderSide(color: Colors.red),
                  ),
                ),
                icon: Icon(
                  Icons.cancel_outlined,
                  size: 24.sp,
                  color: Colors.red,
                ),
                label: Text(
                  'Hủy chuyến',
                  style: GoogleFonts.lexend(fontSize: 16.sp, color: Colors.red),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, String value) {
    return Expanded(
      child: _buildContainer(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
              child: Text(
                title,
                style: GoogleFonts.lexend(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16.w),
              child: Text(
                value,
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContainer(Widget child) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.w),
      padding: EdgeInsets.all(8.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04))],
      ),
      child: child,
    );
  }
}
