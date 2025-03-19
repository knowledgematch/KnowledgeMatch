import 'package:flutter/material.dart';
import 'package:knowledgematch/ui/swipe/view_model/swipe_view_model.dart';
import 'package:provider/provider.dart';
import 'package:swipable_stack/swipable_stack.dart';

import 'flip_card.dart';

class CardStack extends StatelessWidget{
  const CardStack({super.key});



  @override
  Widget build(BuildContext context) {
    SwipeViewModel viewModel = Provider.of<SwipeViewModel>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(viewModel.state.title ?? "Matches (0)"),
        centerTitle: true,
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SwipableStack(
          controller: viewModel.controller,
          itemCount: viewModel.profiles.length,
          horizontalSwipeThreshold: 0.8,
          onSwipeCompleted: (index, direction) {
            viewModel.handleSwipe(direction, context);
          },
          builder: (context, properties) {
            viewModel.checkSwipeDirection(properties.swipeProgress);
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  if (viewModel.state.shouldShowGlow)
                    BoxShadow(
                      color: properties.direction == SwipeDirection.right
                          ? Colors.green.withOpacity(0.9)
                          : properties.direction == SwipeDirection.left
                          ? Colors.red.withOpacity(0.9)
                          : Colors.transparent,
                      blurRadius: 40,
                      spreadRadius: 5,
                    ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: FlipCard(
                  profile: viewModel.profiles[properties.index % viewModel.profiles.length],
                ),
              ),
            );
          },
          overlayBuilder: (context, properties) {
            if (properties.direction == SwipeDirection.right && viewModel.state.shouldShowGlow) {
              return Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'ACCEPT',
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            } else if (properties.direction == SwipeDirection.left && viewModel.state.shouldShowGlow) {
              return Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                   'DECLINE',
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
          swipeAssistDuration: const Duration(milliseconds: 200),
          stackClipBehaviour: Clip.hardEdge,
          allowVerticalSwipe: false,
        ),
      ),
    );
  }

}