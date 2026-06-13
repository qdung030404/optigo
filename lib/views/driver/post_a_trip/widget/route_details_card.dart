import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:optigo/providers/search_provider.dart';
import 'package:provider/provider.dart';

class RouteDetailsCard extends StatelessWidget {
  final String? originName;
  final String? destinationName;
  final void Function(String description, double lat, double lng)
  onPickupSelected;
  final void Function(String description, double lat, double lng)
  onDestinationSelected;

  const RouteDetailsCard({
    super.key,
    this.originName,
    this.destinationName,
    required this.onPickupSelected,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.route, color: const Color(0xff176bac), size: 24.sp),
              SizedBox(width: 12.w),
              Text(
                'Chi tiết lộ trình',
                style: GoogleFonts.lexend(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          _buildLocationInput(
            context: context,
            label: 'Điểm bắt đầu',
            placeholder: (originName == null || originName!.isEmpty)
                ? 'Chọn điểm bắt đầu'
                : originName!,
            onSelected: onPickupSelected,
          ),
          SizedBox(height: 16.h),
          _buildLocationInput(
            context: context,
            label: 'Điểm kết thúc',
            placeholder: (destinationName == null || destinationName!.isEmpty)
                ? 'Chọn điểm kết thúc'
                : destinationName!,
            onSelected: onDestinationSelected,
          ),
        ],
      ),
    );
  }

  Widget _buildLocationInput({
    required BuildContext context,
    required String label,
    required String placeholder,
    required void Function(String description, double lat, double lng)
    onSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.lexend(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 8.h),
        SearchAnchor(
          builder: (BuildContext context, SearchController controller) {
            return SearchBar(
              controller: controller,
              padding: MaterialStatePropertyAll<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 16.w),
              ),
              onTap: () {
                controller.openView();
              },
              onChanged: (_) {
                controller.openView();
              },
              leading: const Icon(Icons.search, color: Color(0xff176bac)),
              hintText: placeholder,
              hintStyle: WidgetStatePropertyAll<TextStyle>(
                GoogleFonts.lexend(fontSize: 14.sp, color: Colors.grey),
              ),
              elevation: const WidgetStatePropertyAll<double>(0),
              backgroundColor: WidgetStatePropertyAll<Color>(Colors.grey[100]!),
              shape: WidgetStatePropertyAll<OutlinedBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            );
          },
          suggestionsBuilder:
              (BuildContext context, SearchController controller) async {
                if (controller.text.isEmpty) {
                  return [
                    ListTile(
                      title: Text(
                        "Bắt đầu nhập để tìm kiếm...",
                        style: GoogleFonts.lexend(fontSize: 14.sp),
                      ),
                    ),
                  ];
                }

                final searchProvider = context.read<SearchProvider>();
                await searchProvider.searchPlace(controller.text);

                return searchProvider.searchResults.map((place) {
                  return ListTile(
                    title: Text(
                      place.mainText,
                      style: GoogleFonts.lexend(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      place.secondaryText,
                      style: GoogleFonts.lexend(fontSize: 12.sp),
                    ),
                    onTap: () async {
                      controller.closeView(place.description);

                      // Lấy chi tiết tọa độ từ Place ID
                      final detail = await searchProvider.getPlaceDetail(
                        place.placeId,
                      );
                      if (detail != null) {
                        onSelected(
                          place.description,
                          detail['lat']!,
                          detail['lng']!,
                        );
                      }
                    },
                  );
                }).toList();
              },
        ),
      ],
    );
  }
}
