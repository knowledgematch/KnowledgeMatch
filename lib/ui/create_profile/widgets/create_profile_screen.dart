import 'package:flutter/material.dart';
import 'package:knowledgematch/domain/models/reachability.dart';
import 'package:knowledgematch/ui/create_profile/view_model/create_profile_view_model.dart';
import 'package:knowledgematch/ui/splash/widgets/splash_screen.dart';
import 'package:provider/provider.dart';

import '../../core/themes/app_colors.dart';
import '../../core/ui/custom_drop_down.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  CreateProfileScreenState createState() => CreateProfileScreenState();
}

class CreateProfileScreenState extends State<CreateProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CreateProfileViewModel>().initReachability();
    });
  }

  /// Function to go back to the login screen
  void _goToLoginScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SplashScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CreateProfileViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Create Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: viewModel.formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: viewModel.pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.grey2Light,
                    backgroundImage: viewModel.state.selectedImage != null
                        ? FileImage(viewModel.state.selectedImage!)
                        : AssetImage('assets/images/profile.png')
                            as ImageProvider,
                    child: viewModel.state.selectedImage == null
                        ? Icon(Icons.camera_alt,
                            size: 50, color: AppColors.greyLight)
                        : null,
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: viewModel.nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: viewModel.surnameController,
                  decoration: InputDecoration(labelText: 'Surname'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your surname';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: viewModel.emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: viewModel.passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                CustomDropdown<Reachability>(
                  items: Reachability.values.map((Reachability reachability) {
                    return reachability;
                  }).toList(),
                  selectedItem: ReachabilityValue.fromValue(
                      int.parse(viewModel.state.reachability)),
                  labelText: 'Reachability',
                  onChanged: (Reachability? newValue) {
                    viewModel.updateReachability(newValue!.value.toString());
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (viewModel.formKey.currentState!.validate()) {
                      await viewModel.createAccount();

                      if (!context.mounted) return;

                      if (!viewModel.state.isValid) {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text('Invalid Email Domain'),
                            content: Text(
                                'The email domain does not match any valid organisation domains.'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          ),
                        );
                        return;
                      } else if (viewModel.state.success) {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text('Success'),
                            content: Text('Account created successfully!'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                  Navigator.pop(context);
                                },
                                child: Text('OK'),
                              ),
                            ],
                          ),
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text('Error'),
                            content: Text('An error occurred'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
                    }
                  },
                  child: Text('Create Account',
                      style: TextStyle(color: AppColors.whiteLight)),
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: _goToLoginScreen,
                  child: Text('Already have an account? Log in',
                      style: TextStyle(color: AppColors.blackLight)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
