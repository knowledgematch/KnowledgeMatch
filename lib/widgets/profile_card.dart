import 'package:flutter/material.dart';
import 'package:knowledgematch/models/userprofile.dart';

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
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Image
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: profilePicture != null
                        ? MemoryImage(profilePicture)
                        : const AssetImage('assets/images/profile.png')
                            as ImageProvider,
                  ),
                ),
                SizedBox(height: 20),

                // Name Field
                _profileInfoField(
                  label: 'Name',
                  value: profile.name,
                ),
                SizedBox(height: 10),

                // Location Field
                _profileInfoField(
                  label: 'Location',
                  value: profile.location,
                ),
                SizedBox(height: 10),

                // Expertise Field
                _profileInfoField(
                  label: 'Expert in',
                  value: profile.expertise.join(', '),
                ),
                SizedBox(height: 10),

                // Availability Field
                _profileInfoField(
                  label: 'Availability',
                  value: profile.availability,
                ),
                SizedBox(height: 10),

                // Language Field
                _profileInfoField(
                  label: 'Languages',
                  value: profile.languages.join(', '),
                ),
                SizedBox(height: 10),

                // Reachability Field
                _profileInfoField(
                  label: 'Reachability',
                  value: profile.reachability.toString(),
                ),
                SizedBox(height: 10),

                // Description Field
                _profileInfoField(
                  label: 'Description',
                  value: profile.description,
                ),

                SizedBox(height: 10),

                // Seniority Field
                _profileInfoField(
                  label: 'Seniority',
                  value: profile.seniority.toString(),
                ),

                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _profileInfoField({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF722334),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
