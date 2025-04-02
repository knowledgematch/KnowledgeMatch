import 'package:flutter/material.dart';
import 'package:knowledgematch/domain/models/reachability.dart';
import 'package:knowledgematch/ui/keyword_selection/view_model/keyword_selection_view_model.dart';
import 'package:knowledgematch/ui/profile/view_model/profile_view_model.dart';
import 'package:provider/provider.dart';
import 'package:knowledgematch/widgets/app_drawer.dart';

import '../../change_pw/view_model/change_pw_view_model.dart';
import '../../change_pw/widgets/change_pw_screen.dart';
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
      if(mounted){
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
            onPressed: () => {
              viewModel.logout(context)
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
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
                DropdownButtonFormField<Reachability>(
                  value: viewModel.state.reachability,
                  onChanged: (Reachability? newValue) {
                      viewModel.changeReachability(newValue!);
                  },
                  items: Reachability.values.map((Reachability reachability) {
                    return DropdownMenuItem<Reachability>(
                      value: reachability,
                      child: Text(reachability.description),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Reachability',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                _buildTextField(viewModel.emailController, 'Email'),
                const SizedBox(height: 16),
                DropdownButtonFormField<int>(
                  value: viewModel.state.semester,
                  decoration: const InputDecoration(
                    labelText: 'Semester',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    for (var i = 0; i <= 12; i++)
                      DropdownMenuItem(value: i, child: Text('Semester $i')),
                    const DropdownMenuItem(value: -1, child: Text('Professor')),
                  ],
                  onChanged: (value) =>
                     viewModel.changeSemester(value!),
                ),
                const SizedBox(height: 16),
                _buildTextField(viewModel.descriptionController, 'Description'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      viewModel.saveProfile(context);
                    }
                  },
                  child: const Text('Save Changes'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChangePasswordScreen(
                                viewModel: ChangePwViewModel(),
                              )),
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
