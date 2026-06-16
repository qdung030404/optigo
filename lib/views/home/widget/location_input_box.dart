import 'package:flutter/material.dart';
import 'package:optigo/views/home/widget/search_location_widget.dart';
import 'package:optigo/models/place_model.dart';

class LocationInputBox extends StatefulWidget {
  final String? initialDestinationText;
  final String? initialOriginText;
  final Function(PlaceModel)? onDestinationSelected;
  final TextEditingController? destinationController;
  final TextEditingController? originController;
  final VoidCallback? onOriginTap;
  final VoidCallback? onDestinationTap;

  const LocationInputBox({
    super.key,
    this.initialDestinationText,
    this.initialOriginText,
    this.onDestinationSelected,
    this.destinationController,
    this.originController,
    this.onOriginTap,
    this.onDestinationTap,
  });

  @override
  State<LocationInputBox> createState() => _LocationInputBoxState();
}

class _LocationInputBoxState extends State<LocationInputBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      width: MediaQuery.of(context).size.width - 32,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.14),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Color(0xff176bac),
                  shape: BoxShape.circle,
                ),
              ),
              Image.asset(
                'assets/images/vertical_dotted_line.png',
                height: 28,
              ),
              const Icon(Icons.location_pin, color: Colors.redAccent, size: 22),
            ],
          ),
          const SizedBox(width: 12),

          // ── Input fields ─────────────────────────────────────────────────
          Expanded(
            child: Column(
              children: [
                // Origin
                SearchLocationWidget(
                  hintText: 'Vị trí của bạn',
                  controller: widget.originController,
                  initialText: widget.initialOriginText,
                  onTap: widget.onOriginTap,
                ),
                Divider(height: 1, color: Colors.grey[200]),
                // Destination
                SearchLocationWidget(
                  hintText: 'Nhập điểm đến',
                  controller: widget.destinationController,
                  initialText: widget.initialDestinationText,
                  onTap: widget.onDestinationTap,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
