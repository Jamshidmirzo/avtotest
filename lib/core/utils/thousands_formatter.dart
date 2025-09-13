import 'package:flutter/services.dart';

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  const ThousandsSeparatorInputFormatter({this.maxCharacterNumber});
  final int? maxCharacterNumber;
  static const separator = ' ';
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (maxCharacterNumber != null && newValue.text.length > maxCharacterNumber!) {
      return oldValue;
    }
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }
    if (oldValue.text == '0' && newValue.text[1] == '0') {
      return const TextEditingValue(text: '0', selection: TextSelection.collapsed(offset: 1));
    } else if (oldValue.text == '0' && newValue.text[1] != '0') {
      return TextEditingValue(
        text: newValue.text[1],
        selection: const TextSelection.collapsed(offset: 1),
      );
    }
    String oldValueText = oldValue.text.replaceAll(separator, '');
    String newValueText = newValue.text.replaceAll(separator, '');
    if (oldValue.text.endsWith(separator) && oldValue.text.length == newValue.text.length + 1) {
      newValueText = newValueText.substring(0, newValueText.length - 1);
    }
    if (oldValueText != newValueText) {
      int selectionIndex = newValue.text.length - newValue.selection.extentOffset;
      final chars = newValueText.split('');
      String newString = '';
      for (int i = chars.length - 1; i >= 0; i--) {
        if ((chars.length - 1 - i) % 3 == 0 && i != chars.length - 1) {
          newString = separator + newString;
        }
        newString = chars[i] + newString;
      }
      return TextEditingValue(
        text: newString.toString(),
        selection: TextSelection.collapsed(
          offset: newString.length - selectionIndex,
        ),
      );
    }
    return newValue;
  }
}
