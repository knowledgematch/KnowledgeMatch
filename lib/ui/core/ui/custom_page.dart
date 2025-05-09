import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:knowledgematch/ui/core/themes/app_colors.dart';

class CustomPage extends StatelessWidget {
  final Widget child;
  const CustomPage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:  BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.white,
              AppColors.gr1,
              AppColors.gr2,
              AppColors.gr3,
              AppColors.gr4,

            ],
            stops: [0.0, 0.1, 0.6, 0.75, 1.0],
          )
      ),
      child: child,
    );
  }
}
