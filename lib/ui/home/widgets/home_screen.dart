import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:knowledgematch/domain/models/user.dart';
import 'package:knowledgematch/ui/core/ui/app_drawer.dart';
import 'package:knowledgematch/ui/home/view_model/home_view_model.dart';
import 'package:provider/provider.dart';

import '../../../domain/models/notification_data.dart';
import '../../../domain/models/userprofile.dart';
import '../../core/themes/app_colors.dart';
import '../../core/ui/decorations.dart';
import '../../profile/widget/profile_screen.dart';
import '../../request/view_model/request_view_model.dart';
import '../../request/widgets/request_screen.dart';
import '../../request/widgets/widget/notification_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  bool _showIncompleteProfileBanner = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<HomeViewModel>().refresh();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = User.instance;
      final isProfileIncomplete = user.description == null ||
          user.description!.trim().isEmpty ||
          user.seniority == null ||
          user.picture == null;

      if (isProfileIncomplete) {
        setState(() {
          _showIncompleteProfileBanner = true;
        });
      }
    });
  }

  void _navigateToEditProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfileScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final HomeViewModel viewModel = context.watch<HomeViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      drawer: const AppDrawer(),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: Decorations.container,
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Welcome back ",
                              style: TextStyle(
                                fontSize: 17,
                                color: AppColors.primary.withOpacity(0.8),
                              ),
                            ),
                            TextSpan(
                              text: "👋",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        _formatName(User.instance.name ?? ''),
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: User.instance.getDecodedPicture() != null
                        ? MemoryImage(User.instance.getDecodedPicture()!)
                        : const AssetImage('assets/images/profile.png')
                            as ImageProvider,
                  ),
                ],
              ),
            ),
          ),
          // Show profile completion banner conditionally
          if (_showIncompleteProfileBanner)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.blueLight.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary.withOpacity(0.8)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Your profile’s incomplete—add info to stand out.",
                    ),
                  ),
                  const SizedBox(width: 12),
                  TextButton(
                    onPressed: _navigateToEditProfile,
                    child: const Text("Edit"),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 18),
          _buildSectionTitle("Open Requests", Icons.pending_actions),
          const SizedBox(height: 8),
          _buildHorizontalList(viewModel.state.openRequests),
          const SizedBox(height: 18),
          _buildSectionTitle("Planned meetings", Icons.event_available),
          const SizedBox(height: 8),
          _buildHorizontalList(viewModel.state.plannedRequests),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalList(HashMap<NotificationData, Userprofile> requests) {
    if (requests.isEmpty) {
      return const Center(
        child: Text(
          "No requests available",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    } else {
      final notifications = requests.entries.toList();
      return SizedBox(
        height: 180,
        child: ListView.builder(
          padding: EdgeInsets.all(8),
          scrollDirection: Axis.horizontal,
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final entry = notifications[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ChangeNotifierProvider<RequestViewModel>(
                      create: (_) => RequestViewModel(
                        notificationData: entry.key,
                        userprofile: entry.value,
                      ),
                      child: RequestScreen(),
                    ),
                  ),
                );
              },
              child: SizedBox(
                width: 350,
                height: 160,
                child: NotificationCard(
                  userprofile: entry.value,
                  notification: entry.key,
                ),
              ),
            );
          },
          // _buildCard(requests[index]),
        ),
      );
    }
  }

  String _formatName(String name) {
    const int maxLength = 17;
    if (name.length > maxLength) {
      return '${name.substring(0, maxLength)}...';
    }
    return name;
  }
}
