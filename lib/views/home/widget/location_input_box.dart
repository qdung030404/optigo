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
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width - 32,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              const Icon(Icons.circle, color: Colors.yellowAccent, size: 30),
              Image.asset('assets/images/vertical_dotted_line.png'),
              const Icon(Icons.location_pin, color: Colors.redAccent, size: 30),
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              children: [
                // ── Điểm đi ──────────────────────────────────────────────
                SearchLocationWidget(
                  hintText: 'Vị trí của bạn',
                  controller: widget.originController,
                  initialText: widget.initialOriginText,
                  onTap: widget.onOriginTap,
                ),
                const Divider(height: 1, color: Colors.grey),
                // ── Điểm đến ─────────────────────────────────────────────
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
