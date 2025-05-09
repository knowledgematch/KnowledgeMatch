import 'package:flutter/material.dart';
import 'package:knowledgematch/ui/core/ui/decorations.dart';
import 'package:knowledgematch/ui/request/view_model/request_view_model.dart';

class UserProfileCard extends StatelessWidget {
  const UserProfileCard({super.key, required this.viewModel});

  final RequestViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    var userprofile = viewModel.userprofile;
    var profilePicture = userprofile.getPicture();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: Decorations.container,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: profilePicture != null
                  ? MemoryImage(profilePicture)
                  : const AssetImage('assets/images/profile.png')
                      as ImageProvider,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userprofile.name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    userprofile.description,
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Location: ${userprofile.reachability}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
