import 'package:flutter/material.dart';
import 'package:knowledgematch/domain/models/reachability.dart';
import 'package:knowledgematch/domain/models/userprofile.dart';

import '../../core/themes/app_colors.dart';
import '../../core/ui/info_card.dart';

class ProfileCard extends StatelessWidget {
  final Userprofile profile;
  final double width;
  final double height;

  const ProfileCard({
    super.key,
    required this.profile,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    var profilePicture = profile.getPicture();
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.grey2Light,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.greyShadow3Light,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                CircleAvatar(
                  radius: 90,
                  backgroundImage: profilePicture != null
                      ? MemoryImage(profilePicture)
                      : const AssetImage('assets/images/profile.png')
                  as ImageProvider,
                ),

              const SizedBox(height: 16),
              Text(
                profile.name,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                'FHNW',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.grey[700]),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_on,
                      size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    'Switzerland',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.grey[700]),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              InfoCard(
                title: 'Meeting Preference',
                value: profile.reachability!.description,
                icon: Icons.people,
                iconColor: AppColors.primary,
              ),
              const SizedBox(height: 16),
              InfoCard(
                title: 'Semester',
                value: profile.seniority == -1
                    ? 'Professor'
                    : 'Semester ${profile.seniority}',
                icon: Icons.school,
                iconColor: AppColors.primary,
              ),
              const SizedBox(height: 16),
              InfoCard(
                title: 'Expert in',
                value: profile.expertise.join(', '),
                icon: Icons.label,
                iconColor: AppColors.primary,
              ),
              const SizedBox(height: 16),
              InfoCard(
                title: 'Email',
                value: profile.email,
                icon: Icons.email,
                iconColor: AppColors.primary,
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'About ${profile.name}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Text(
                    profile.description.isEmpty
                        ? 'No bio added yet.'
                        : profile.description,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
