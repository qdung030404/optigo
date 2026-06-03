import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if( newValue.selection.baseOffset ==0){
      return newValue;
    }
    String cleanedText = newValue.text.replaceAll('.','');
    int value = int.parse(cleanedText);
    final formatter = NumberFormat('#,###', 'vi_VN');
    String formattedText = formatter.format(value);
    return newValue.copyWith(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
class Formatter{
  static String phoneFormatter(String value){
    String cleanedText = value.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();
    if (cleanedText.startsWith('84')) {
      cleanedText = '0${cleanedText.substring(2)}';

    }
    for (int i = 0; i < cleanedText.length; i++) {
      buffer.write(cleanedText[i]);
      final nonZeroIndex = i + 1;

      // Chèn khoảng trắng sau ký tự thứ 4 và thứ 7
      if (nonZeroIndex == 4 && nonZeroIndex != cleanedText.length) {
        buffer.write(' '); // Thêm khoảng trắng dạng: 0901 _
      } else if (nonZeroIndex == 7 && nonZeroIndex != cleanedText.length) {
        buffer.write(' '); // Thêm khoảng trắng dạng: 0901 234 _
      }
    }
    return buffer.toString();
  }
}