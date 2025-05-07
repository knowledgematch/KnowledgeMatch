import 'package:flutter/material.dart';
import 'package:knowledgematch/domain/models/reachability.dart';
import 'package:knowledgematch/ui/keyword_selection/view_model/keyword_selection_view_model.dart';
import 'package:knowledgematch/ui/profile/view_model/profile_view_model.dart';
import 'package:provider/provider.dart';

import '../../change_pw/view_model/change_pw_view_model.dart';
import '../../change_pw/widgets/change_pw_screen.dart';
import '../../core/ui/custom_drop_down.dart';
import '../../keyword_selection/widgets/keyword_selection_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        final viewModel = context.read<ProfileViewModel>();
        viewModel.loadUserData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProfileViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => {viewModel.logout(context)},
          ),
        ],
      ),

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10, right: 20),
        child: ClipOval(
          child: Builder(
            builder: (context) {
              return FloatingActionButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    viewModel.saveProfile(context);
                  }
                },
                child: Icon(
                  Icons.save,
                ),
              );
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: viewModel.pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: viewModel.state.pictureData != null
                        ? MemoryImage(viewModel.state.pictureData!)
                        : const AssetImage('assets/images/profile.png')
                            as ImageProvider,
                  ),
                ),
                const SizedBox(height: 16),
                _buildTextField(viewModel.nameController, 'Name'),
                const SizedBox(height: 16),
                _buildTextField(viewModel.surnameController, 'Surname'),
                const SizedBox(height: 16),
                CustomDropdown<Reachability>(
                  items: Reachability.values.map((Reachability reachability) {
                    return reachability;
                  }).toList(),
                  selectedItem: viewModel.state.reachability,
                  labelText: 'Reachability',
                  onChanged: (Reachability? newValue) {
                    viewModel.changeReachability(newValue!);
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(viewModel.emailController, 'Email'),
                const SizedBox(height: 16),
                CustomDropdown<int>(
                  items: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, -1],
                  selectedItem: viewModel.state.semester,
                  labelText: 'Semester',
                  onChanged: (value) => viewModel.changeSemester(value!),
                  dropdownMenuItemBuilder: (int v) => DropdownMenuItem(
                    value: v,
                    child: Text(v == -1 ? 'Professor' : 'Semester $v'),
                  ),
                ),
                const SizedBox(height: 16),
                _buildTextField(viewModel.descriptionController, 'Description'),
                const SizedBox(height: 16),
                ElevatedButton(
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
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChangeNotifierProvider(
                                create: (BuildContext context) =>
                                    KeywordSelectionViewModel(),
                                child: KeywordSelectionScreen())));
                  },
                  child: const Text('Edit Keywords'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
