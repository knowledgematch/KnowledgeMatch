import 'package:flutter/material.dart';
import 'package:knowledgematch/ui/profile/view_model/profile_view_model.dart';
import 'package:provider/provider.dart';

import '../../change_pw/view_model/change_pw_view_model.dart';
import '../../change_pw/widgets/change_pw_screen.dart';
import '../../core/themes/app_colors.dart';
import '../../splash/widgets/splash_screen.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<ProfileViewModel>();
    final nameController = viewModel.nameController;
    final surnameController = viewModel.surnameController;
    final emailController = viewModel.emailController;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: true,
        actions: [
          IconButton(
              icon: const Icon(Icons.save),
              onPressed: () => {
                    viewModel.saveProfile(context),
                    Navigator.pop(context),
                  }),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              maxLength: 20,
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: surnameController,
              maxLength: 20,
              decoration: const InputDecoration(labelText: 'Last Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              enabled: false,
              decoration: InputDecoration(
                labelText: 'Email',
                suffixIcon: const Icon(Icons.lock, size: 20),
                filled: true,
                fillColor: AppColors.grey,
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.grey2),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider(
                            create: (_) => ChangePwViewModel(),
                            child: ChangePasswordScreen())),
                  );
                },
                child: const Text('Change Password'),
              ),
            ),
        const SizedBox(height: 35),
        SafeArea(
          child: TextButton(
            onPressed: viewModel.state.isDeleting
                ? null
                  : () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("Delete Account"),
                          content: const Text(
                              "Are you sure you want to delete your account? This action cannot be undone."),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: viewModel.state.isDeleting
                                  ? null
                                  : () async {
                                      Navigator.pop(context);
                                      await viewModel.deleteAccount();
                                      if (context.mounted) {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pushAndRemoveUntil(
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  const SplashScreen()),
                                          (route) => false,
                                        );
                                      }
                                    },
                              style: TextButton.styleFrom(
                                  foregroundColor: Colors.red),
                              child: viewModel.state.isDeleting
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2),
                                    )
                                  : const Text("Delete"),
                            ),
                          ],
                        ),
                      );
                    },
              child: const Text("Delete Account"),
            ),
           ),
          ],
        ),
      ),
    );
  }
}
