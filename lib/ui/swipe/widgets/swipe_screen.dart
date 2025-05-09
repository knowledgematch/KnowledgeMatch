import 'package:flutter/material.dart';
import 'package:knowledgematch/domain/models/userprofile.dart';
import 'package:knowledgematch/ui/core/themes/app_constants.dart';
import 'package:knowledgematch/ui/swipe/view_model/swipe_view_model.dart';
import 'package:provider/provider.dart';
import 'package:swipable_stack/swipable_stack.dart';

import '../../core/themes/app_colors.dart';
import 'flip_card.dart';

class SwipeScreen extends StatefulWidget {
  const SwipeScreen({super.key});

  @override
  ProfileSwipeScreenState createState() => ProfileSwipeScreenState();
}

class ProfileSwipeScreenState extends State<SwipeScreen> {

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SwipeViewModel>();
    return FutureBuilder<List<Userprofile>>(
      future: viewModel.profilesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text("Error")),
            body: Center(child: Text("Error: ${snapshot.error}")),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text("No Matches")),
            body: const Center(
              child: Text(
                "No more profiles to show!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          );
        }

        return Column(children: [
          Expanded(
            child: Scaffold(
              backgroundColor: AppColors.primary,
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                title: Text(viewModel.state.title ?? "Matches (0)"),
                centerTitle: true,
              ),
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: SwipableStack(
                          controller: viewModel.controller,
                          itemCount: viewModel.profiles.length,
                          horizontalSwipeThreshold: 0.8,
                          onSwipeCompleted: (index, direction) {
                            viewModel.handleSwipe(direction, context);
                          },
                          builder: (context, properties) {
                            viewModel.checkSwipeDirection(
                              properties.swipeProgress,
                            );
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: AppConstants.borderRadiusLarge,
                                boxShadow: [
                                  if (viewModel.state.shouldShowGlow)
                                    BoxShadow(
                                      color: properties.direction ==
                                              SwipeDirection.right
                                          ? Colors.green.withOpacity(0.9)
                                          : properties.direction ==
                                                  SwipeDirection.left
                                              ? Colors.red.withOpacity(0.9)
                                              : Colors.transparent,
                                      blurRadius: 40,
                                      spreadRadius: 5,
                                    ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: AppConstants.borderRadiusLarge,
                                child: FlipCard(
                                  profile: viewModel.profiles[properties.index %
                                      viewModel.profiles.length],
                                ),
                              ),
                            );
                          },
                          overlayBuilder: (context, properties) {
                            if (properties.direction == SwipeDirection.right &&
                                viewModel.state.shouldShowGlow) {
                              return Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: Text(
                                    'SEND',
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontSize: 50,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            } else if (properties.direction ==
                                    SwipeDirection.left &&
                                viewModel.state.shouldShowGlow) {
                              return Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: Text(
                                    'SKIP',
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
                          swipeAssistDuration: const Duration(
                            milliseconds: 200,
                          ),
                          stackClipBehaviour: Clip.hardEdge,
                          allowVerticalSwipe: false,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ]);
      },
    );
  }
}
