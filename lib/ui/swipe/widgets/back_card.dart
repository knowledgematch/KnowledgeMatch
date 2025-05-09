import 'package:flutter/material.dart';
import 'package:knowledgematch/ui/core/themes/app_constants.dart';

import '../../../domain/models/userprofile.dart';
import '../../core/themes/app_colors.dart';

class BackCard extends StatelessWidget {
  final Userprofile profile;
  final double width;
  final double height;

  const BackCard({
    super.key,
    required this.profile,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    var profilePicture = profile.getPicture();
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackShadowLight,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 450,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.greyShadowLight,
                borderRadius: AppConstants.borderRadiusLarge,
              ),
              child: ClipRRect(
                borderRadius: AppConstants.borderRadiusLarge,
                child:
                    profilePicture != null
                        ? Image.memory(profilePicture, fit: BoxFit.cover)
                        : Image.asset(
                          'assets/images/profile.png',
                          fit: BoxFit.cover,
                        ),
              ),
            ),
            Text(
              profile.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.black87Light,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              profile.description == "null"
                  ? "No information available."
                  : profile.description,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: AppColors.greyLight),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                "Click anywhere on the page to find out more!",
                style: TextStyle(fontSize: 12, color: AppColors.greyLight),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RotationYTransition extends AnimatedWidget {
  final Widget child;

  const RotationYTransition({
    super.key,
    required Animation<double> turns,
    required this.child,
  }) : super(listenable: turns);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Transform(
      transform: Matrix4.rotationY(animation.value * 3.1416),
      alignment: Alignment.center,
      child:
          animation.value < 0.5
              ? child
              : Transform(
                transform: Matrix4.rotationY(3.1416),
                alignment: Alignment.center,
                child: child,
              ),
    );
  }
}
