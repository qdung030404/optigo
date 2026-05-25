import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:optigo/providers/booking_provider.dart';
import 'package:provider/provider.dart';

class BuildNoteField extends StatefulWidget {
  const BuildNoteField({super.key});

  @override
  State<BuildNoteField> createState() => _BuildNoteFieldState();
}

class _BuildNoteFieldState extends State<BuildNoteField> {
  final TextEditingController _noteController = TextEditingController();


  @override
  void initState() {
    _noteController.text = context.read<BookingProvider>().note;
    _noteController.addListener(_onNoteChanged);
    super.initState();
  }

  void _onNoteChanged() {
    context.read<BookingProvider>().setNote(_noteController.text);
  }

  @override
  void dispose() {
    _noteController.removeListener(_onNoteChanged);
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Ghi chú cho tài xế",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
          ),
          TextField(
            controller: _noteController,
            maxLines: 4,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: "",
            ),
          ),
        ],
      ),
    );
  }
}
