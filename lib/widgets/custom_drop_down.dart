import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatelessWidget {
  final List<T> items;
  final T? selectedItem;
  final ValueChanged<T?>? onChanged;
  final String hintText;
  final String? labelText;
  final Color borderColor;
  final Color dropdownColor;
  final Color textColor;
  final Color menuTextColor;
  final String? Function(T?)? validator;

  const CustomDropdown({
    super.key,
    required this.items,
    this.selectedItem,
    this.onChanged,
    this.hintText = "Select an option",
    this.labelText,
    this.borderColor = Colors.black,
    this.dropdownColor = Colors.white,
    this.textColor = Colors.black,
    this.menuTextColor = Colors.black,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: textColor, fontSize: 16),
        hintText: hintText,
        hintStyle: TextStyle(color: textColor.withOpacity(0.7)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: borderColor, width: 1),
        ),
      ),
      dropdownColor: dropdownColor,
      style: TextStyle(color: textColor, fontSize: 16),
      value: selectedItem,
      items: items.map((item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(
            item.toString(),
            style: TextStyle(color: menuTextColor),
          ),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }
}
