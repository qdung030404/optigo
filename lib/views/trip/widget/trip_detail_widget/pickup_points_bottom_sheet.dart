import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:optigo/models/place_model.dart';
import 'package:optigo/providers/search_provider.dart';
import 'package:provider/provider.dart';

class PickupPointsBottomSheet extends StatefulWidget {
  final List<Map<String, dynamic>> points;
  final String? initialSelectedAddress;

  const PickupPointsBottomSheet({
    super.key,
    required this.points,
    this.initialSelectedAddress,
  });

  @override
  State<PickupPointsBottomSheet> createState() =>
      _PickupPointsBottomSheetState();
}

class _PickupPointsBottomSheetState extends State<PickupPointsBottomSheet> {
  int? localSelectedIndex; // Lưu điểm mà người dùng đang chọn nháp
  final Map<int, PlaceModel> _placeCache = {}; // Cache lưu PlaceModel đã lấy

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height * 0.6, // Tăng nhẹ chiều cao
      child: Column(
        children: [
          // 1. Header
          Text(
            "Bạn muốn tài xế đón ở đâu?",
            style: GoogleFonts.lexend(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // 2. Danh sách các điểm
          Expanded(
            child: ListView.builder(
              itemCount: widget.points.length,
              itemBuilder: (context, index) {
                final point = widget.points[index]['point'];

                // Nếu chưa có trong cache, gọi API lấy thông tin chi tiết
                if (!_placeCache.containsKey(index)) {
                  context
                      .read<SearchProvider>()
                      .getPlaceFromLatLng(point.latitude, point.longitude)
                      .then((place) {
                        if (mounted && place != null) {
                          setState(() {
                            _placeCache[index] = place;
                            // Tự động highlight nếu trùng với cái đã chọn
                            final fullName =
                                "${place.mainText}, ${place.secondaryText}";
                            if (widget.initialSelectedAddress == fullName) {
                              localSelectedIndex = index;
                            }
                          });
                        }
                      });
                }

                bool isSelected = localSelectedIndex == index;
                final place = _placeCache[index];

                return Container(
                  margin: EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xff176bac).withOpacity(0.05)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xff176bac)
                          : Colors.transparent,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    child: ListTile(
                      selected: isSelected,
                      leading: Icon(
                        Icons.location_pin,
                        color: isSelected
                            ? const Color(0xff176bac)
                            : Colors.redAccent,
                      ),
                      title: Text(
                        place?.mainText ?? "Đang tải tên...",
                        style: GoogleFonts.lexend(
                          fontSize: 15,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.w500,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            place?.secondaryText ?? "Đang tải địa chỉ...",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.lexend(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            "Cách bạn ${widget.points[index]['distance'].toStringAsFixed(0)}m",
                            style: GoogleFonts.lexend(
                              fontSize: 11,
                              color: const Color(0xff176bac),
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        setState(() {
                          localSelectedIndex = index;
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),
          // 3. Nút xác nhận cuối cùng
          ElevatedButton(
            onPressed:
                localSelectedIndex == null ||
                    !_placeCache.containsKey(localSelectedIndex)
                ? null
                : () {
                    final selectedPlace = _placeCache[localSelectedIndex!]!;
                    Navigator.pop(context, {
                      'point': widget.points[localSelectedIndex!]['point'],
                      'name':
                          "${selectedPlace.mainText}, ${selectedPlace.secondaryText}",
                    });
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xfffedd59),
              foregroundColor: const Color(0xff176bac),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Text(
              "Xác nhận điểm đón",
              style: GoogleFonts.lexend(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
