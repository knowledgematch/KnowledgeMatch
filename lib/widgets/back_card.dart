import 'package:flutter/material.dart';
import 'package:knowledgematch/domain/models/userprofile.dart';

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
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 50),
          CircleAvatar(
            radius: 60,
            backgroundColor: const Color(0xFF722334).withOpacity(0.2),
            child: CircleAvatar(
              radius: 50,
              backgroundImage: profilePicture != null
                  ? MemoryImage(profilePicture)
                  : const AssetImage('assets/images/profile.png')
                      as ImageProvider,
            ),
          ),

          const SizedBox(height: 16),

          // Name
          Text(
            profile.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF722334).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "No qualifications are provided about this expert yet",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF722334),
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
                color: Colors.grey,
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
              icon: const Icon(Icons.touch_app),
              label: const Text(
                "See detailed information",
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF722334),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
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
                color: Colors.grey,
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
