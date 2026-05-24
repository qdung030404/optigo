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