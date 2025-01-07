import 'package:flutter/cupertino.dart';
import 'package:knowledgematch/widgets/profile_card.dart';

import '../model/userprofile.dart';
import 'back_card.dart';

class FlipCard extends StatefulWidget {
  final Userprofile profile;

  const FlipCard({super.key, required this.profile});

  @override
  FlipCardState createState() => FlipCardState();
}

class FlipCardState extends State<FlipCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isBackVisible = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  /// Disposes of the resources used by the controller when the widget is removed from the widget tree.
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Called when the widget configuration changes and the widget's state needs to be updated.
  @override
  void didUpdateWidget(covariant FlipCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isBackVisible) {
      _controller.reverse();
      _isBackVisible = false;
    }
  }

  /// Toggles the flip animation of the card.
  void toggleCard() {
    if (_controller.isAnimating) return;
    if (_isBackVisible) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    _isBackVisible = !_isBackVisible;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggleCard,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cardWidth = constraints.maxWidth;
          final cardHeight = constraints.maxHeight;

          return AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              final isBack = _animation.value <= 0.5;
              final rotationAngle = _animation.value * 3.1416;
              return Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(rotationAngle),
                alignment: Alignment.center,
                child: isBack
                    ? BackCard(
                  key: const ValueKey(true),
                  profile: widget.profile,
                  width: cardWidth,
                  height: cardHeight,
                )
                    : Transform(
                  transform: Matrix4.rotationY(3.1416),
                  alignment: Alignment.center,
                  child: ProfileCard(
                    key: const ValueKey(false),
                    profile: widget.profile,
                    width: cardWidth,
                    height: cardHeight,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}