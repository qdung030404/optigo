import 'package:flutter/material.dart';
import 'package:optigo/models/place_model.dart';

class SearchLocationWidget extends StatefulWidget {
  final String hintText;
  final Function(PlaceModel)? onSelected;
  final TextEditingController? controller;
  final String? initialText;
  final VoidCallback? onTap;

  const SearchLocationWidget({
    super.key,
    required this.hintText,
    this.onSelected,
    this.controller,
    this.initialText,
    this.onTap,
  });

  @override
  State<SearchLocationWidget> createState() => _SearchLocationWidgetState();
}

class _SearchLocationWidgetState extends State<SearchLocationWidget> {
  TextEditingController? _internalController;
  TextEditingController get _controller =>
      widget.controller ?? _internalController!;

  @override
  void initState() {
    super.initState();
    // if (widget.controller == null) {
    //   _internalController = TextEditingController(
    //     text: widget.initialText ?? '',
    //   );
    // } else if (widget.initialText != null) {
    //   widget.controller!.text = widget.initialText!;
    // }
  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque, // Luôn nhận tap dù không có con được hit
      onTap: widget.onTap,
      child: TextField(
        readOnly: true,
        enabled: false, // Vô hiệu hóa hoàn toàn interaction của TextField
        controller: _controller,
        decoration: InputDecoration(
          hintText: widget.hintText,
          border: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        ),
      ),
    );
  }
}
