import 'package:flutter/material.dart';

import '../../../domain/models/userprofile.dart';
import '../../core/themes/app_colors.dart';
import '../../core/themes/app_constants.dart';
import 'flip_card.dart';

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
        color: AppColors.grey2Light,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackShadowLight,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 50),
          Container(
            height: 450,
            width: 380,
            decoration: BoxDecoration(
              color: AppColors.greyShadowLight,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.greyShadowLight,
                width: 2,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: profilePicture != null
                  ? Image.memory(
                      profilePicture,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'assets/images/profile.png',
                      fit: BoxFit.cover,
                    ),
            ),
          ),

          const SizedBox(height: 16),

          // Name
          Text(
            profile.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.black87Light,
            ),
          ),
          const SizedBox(height: 8),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.grey3Light,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              "No qualifications are provided about this expert yet",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.black87Light,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 16),

          Expanded(
            child: Text(
              profile.description == "null"
                  ? "More information about this person will be available soon."
                  : profile.description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.greyLight,
              ),
            ),
          ),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                final flipCardState =
                    context.findAncestorStateOfType<FlipCardState>();
                if (flipCardState != null) {
                  flipCardState.toggleCard();
                }
              },
              icon: const Icon(
                Icons.touch_app,
                color: AppColors.whiteLight,
              ),
              label: const Text("See detailed information"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.whiteLight,
                shape: RoundedRectangleBorder(
                  borderRadius: AppConstants.borderRadiusLarge,
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              "Or simply click anywhere on the page!",
              style: TextStyle(
                fontSize: 12,
                color: AppColors.greyLight,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class RotationYTransition extends AnimatedWidget {
  final Widget child;

  const RotationYTransition(
      {super.key, required Animation<double> turns, required this.child})
      : super(listenable: turns);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Transform(
      transform: Matrix4.rotationY(animation.value * 3.1416),
      alignment: Alignment.center,
      child: animation.value < 0.5
          ? child
          : Transform(
              transform: Matrix4.rotationY(3.1416),
              alignment: Alignment.center,
              child: child,
            ),
    );
  }
}
