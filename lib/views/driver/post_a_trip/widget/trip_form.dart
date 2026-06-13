import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:optigo/views/driver/post_a_trip/widget/departure_time_card.dart';
import 'package:optigo/views/driver/post_a_trip/widget/number_of_seats.dart';
import 'package:optigo/views/driver/post_a_trip/widget/price_card.dart';
import 'package:optigo/views/driver/post_a_trip/widget/route_details_card.dart';

class TripForm extends StatelessWidget {
  final bool isEdit;
  final String? originName;
  final String? destinationName;
  final DateTime? initialDepartureTime;
  final CarType? initialCarType;
  final int? initialPrice;

  final Function(String, double, double)? onPickupSelected;
  final Function(String, double, double)? onDestinationSelected;
  final Function(DateTime) onDateTimeChanged;
  final Function(CarType?) onSeatsSelected;
  final Function(int?) onPriceChanged;

  const TripForm({
    super.key,
    this.isEdit = false,
    this.originName,
    this.destinationName,
    this.initialDepartureTime,
    this.initialCarType,
    this.initialPrice,
    this.onPickupSelected,
    this.onDestinationSelected,
    required this.onDateTimeChanged,
    required this.onSeatsSelected,
    required this.onPriceChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!isEdit) ...[
          RouteDetailsCard(
            originName: originName,
            destinationName: destinationName,
            onPickupSelected: onPickupSelected ?? (_, __, ___) {},
            onDestinationSelected: onDestinationSelected ?? (_, __, ___) {},
          ),
          SizedBox(height: 16.h),
        ],
        DepartureTimeCard(
          initialDateTime: initialDepartureTime,
          onDateTimeChanged: onDateTimeChanged,
        ),
        SizedBox(height: 16.h),
        if (!isEdit) ...[
          NumberOfSeats(
            initialValue: initialCarType,
            onSelected: onSeatsSelected,
          ),
          SizedBox(height: 16.h),
        ],
        PriceCard(initialPrice: initialPrice, onPriceChanged: onPriceChanged),
      ],
    );
  }
}
