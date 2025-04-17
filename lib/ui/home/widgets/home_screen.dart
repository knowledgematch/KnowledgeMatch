import 'package:flutter/material.dart';
import 'package:knowledgematch/ui/core/ui/app_drawer.dart';
import 'package:knowledgematch/ui/home/view_model/home_view_model.dart';
import 'package:provider/provider.dart';

import '../../../domain/models/notification_data.dart';
import '../../core/themes/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
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
                        "$viewModel.userName 👋",
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
                    backgroundImage: AssetImage(viewModel.state.profilePicture),
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
          _buildSectionTitle("Planned Requests", Icons.event_available),
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

  Widget _buildHorizontalList(List<NotificationData> requests) {
    if (requests.isEmpty) {
      return const Center(
        child: Text(
          "No requests available",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }
    return SizedBox(
      height: 180,
      child: ListView.builder(
        padding: EdgeInsets.all(8),
        scrollDirection: Axis.horizontal,
        itemCount: requests.length,
        itemBuilder: (context, index) => _buildCard(requests[index]),
      ),
    );
  }

  Widget _buildCard(NotificationData request) {
    bool isPlanned = true;
    return Container(
      margin: const EdgeInsets.only(right: 16),
      width: 300,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors:
              isPlanned
                  ? [AppColors.primary, AppColors.primary.withOpacity(0.8)]
                  : [AppColors.blueLight, AppColors.blueLight.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.calendar_today, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                request.payload.toString(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.access_time, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                request.requestID.toString(),
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                "Location: Online : In Person",
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
