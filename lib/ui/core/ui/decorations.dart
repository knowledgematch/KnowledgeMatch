// lib/ui/core/themes/app_decorations.dart
import 'package:flutter/material.dart';
import 'package:knowledgematch/ui/core/themes/app_colors.dart';
import 'package:knowledgematch/ui/core/themes/app_constants.dart';

class Decorations {
  static final BoxDecoration container = BoxDecoration(
    color: AppColors.white,
    borderRadius: AppConstants.borderRadiusLarge,
    boxShadow: [
      BoxShadow(
        color: AppColors.blue.withOpacity(0.3),
        spreadRadius: 1,
        blurRadius: 10,
        offset: const Offset(4, 4),
      ),
    ],
  );
}
