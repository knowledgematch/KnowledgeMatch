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
            backgroundColor: AppColors.primary,
            appBar: AppBar(title: const Text("No Matches")),
            body: const Center(
              child: Text(
                "No more profiles to show!",
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }
        final snackBar = SnackBar(
          content: const Text('Request sent'),
          duration: Duration(milliseconds: 500),
        );

        return ValueListenableBuilder<bool>(
          valueListenable: viewModel.hasFinishedNotifier,
          builder: (context, hasFinished, _) {
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
                      child: hasFinished
                          ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              viewModel.skippedProfiles.isEmpty
                                  ? "No more profiles to show!"
                                  : "You've reached the end.\nWould you like to try again?",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            if (viewModel.skippedProfiles.isNotEmpty) ...[
                              const SizedBox(height: 34),
                              TextButton(
                                onPressed: () {
                                  viewModel.resetStack();
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Try again",
                                      style: TextStyle(color: AppColors.white, fontSize: 18),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(
                                      size: 24,
                                      Icons.refresh,
                                      color: AppColors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      )
                          : Column(
                        children: [
                          Expanded(
                            child: SwipableStack(
                              controller: viewModel.controller,
                              itemCount: viewModel.profiles.length,
                              horizontalSwipeThreshold: 0.8,
                              onSwipeCompleted: (index, direction) {
                                viewModel.handleSwipe(direction,
                                    onRightSwipe: () {
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                }
                              },
                              builder: (context, properties) {
                                viewModel.checkSwipeDirection(
                                  properties.swipeProgress,
                                );
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    AppConstants.borderRadiusLarge,
                                    boxShadow: [
                                      if (viewModel.state.shouldShowGlow)
                                        BoxShadow(
                                          color: properties.direction ==
                                              SwipeDirection.right
                                              ? Colors.green
                                              .withOpacity(0.9)
                                              : properties.direction ==
                                              SwipeDirection.left
                                              ? Colors.red
                                              .withOpacity(0.9)
                                              : Colors.transparent,
                                          blurRadius: 40,
                                          spreadRadius: 5,
                                        ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius:
                                    AppConstants.borderRadiusLarge,
                                    child: FlipCard(
                                      profile: viewModel.profiles[
                                      properties.index %
                                          viewModel.profiles.length],
                                    ),
                                  ),
                                );
                              },
                              overlayBuilder: (context, properties) {
                                if (properties.direction ==
                                    SwipeDirection.right &&
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
      },
    );
  }
}
