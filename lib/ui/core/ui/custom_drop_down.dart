import 'package:flutter/material.dart';

import '../themes/app_colors.dart';
import '../themes/app_constants.dart';

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
    this.borderColor = AppColors.blue,
    this.dropdownColor = AppColors.whiteLight,
    this.textColor = AppColors.primary,
    this.menuTextColor = AppColors.primary,
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
        focusColor: AppColors.blackLight,
        floatingLabelStyle: TextStyle(color: AppColors.blue),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.blue),
          borderRadius: AppConstants.borderRadius,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.blue),
          borderRadius: AppConstants.borderRadius,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.blue),
          borderRadius: AppConstants.borderRadius,
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
