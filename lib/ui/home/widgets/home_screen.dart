import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:knowledgematch/domain/models/user.dart';
import 'package:knowledgematch/ui/core/ui/app_drawer.dart';
import 'package:knowledgematch/ui/home/view_model/home_view_model.dart';
import 'package:provider/provider.dart';

import '../../../domain/models/notification_data.dart';
import '../../../domain/models/userprofile.dart';
import '../../core/themes/app_colors.dart';
import '../../request/view_model/request_view_model.dart';
import '../../request/widgets/notification_card.dart';
import '../../request/widgets/request_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<HomeViewModel>().refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final HomeViewModel viewModel = context.watch<HomeViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      drawer: const AppDrawer(),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome back,",
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.primary.withOpacity(0.8),
                        ),
                      ),
                      Text(
                        "${User.instance.name} 👋",
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
                    backgroundImage:
                        viewModel.state.profilePicture != null
                            ? MemoryImage(User.instance.getDecodedPicture()!)
                            : const AssetImage('assets/images/profile.png')
                                as ImageProvider,
                    // User.instance.picture ?? 'assets/images/profile.png'),
                  ),
                ],
              ),
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
                    builder:
                        (context) => ChangeNotifierProvider<RequestViewModel>(
                          create:
                              (_) => RequestViewModel(
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
}
