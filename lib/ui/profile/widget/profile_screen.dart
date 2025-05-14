import 'package:flutter/material.dart';
import 'package:knowledgematch/domain/models/reachability.dart';
import 'package:knowledgematch/ui/core/ui/app_drawer.dart';
import 'package:knowledgematch/ui/profile/view_model/profile_view_model.dart';
import 'package:provider/provider.dart';

import '../../core/themes/app_colors.dart';
import '../../core/ui/info_card.dart';
import '../../keyword_selection/view_model/keyword_selection_view_model.dart';
import '../../keyword_selection/widgets/keyword_selection_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<ProfileViewModel>().loadUserData();
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
            icon: const Icon(Icons.save),
            onPressed: () => viewModel.saveProfile(context),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const EditProfileScreen(),
            ),
          )
        },
        child: const Icon(Icons.edit),
      ),
      body: viewModel.state.uId.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: viewModel.pickImage,
                    child: CircleAvatar(
                      radius: 90,
                      backgroundImage: viewModel.state.pictureData != null
                          ? MemoryImage(viewModel.state.pictureData!)
                          : const AssetImage('assets/images/profile.png')
                              as ImageProvider,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${viewModel.nameController.text} ${viewModel.surnameController.text}',
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
                    value: viewModel.state.reachability.description,
                    icon: Icons.people,
                    iconColor: AppColors.primary,
                    onTap: () =>
                        _showMeetingPreferenceSheet(context, viewModel),
                  ),
                  const SizedBox(height: 16),
                  InfoCard(
                    title: 'Semester',
                    value: viewModel.state.semester == -1
                        ? 'Professor'
                        : 'Semester ${viewModel.state.semester}',
                    icon: Icons.school,
                    iconColor: AppColors.primary,
                    onTap: () =>
                        _showSemesterSelectionSheet(context, viewModel),
                  ),
                  const SizedBox(height: 16),
                  InfoCard(
                    title: 'Keywords',
                    value: 'Click to view/edit',
                    icon: Icons.label,
                    iconColor: AppColors.primary,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChangeNotifierProvider(
                                  create: (BuildContext context) =>
                                      KeywordSelectionViewModel(),
                                  child: KeywordSelectionScreen())));
                    },
                  ),
                  const SizedBox(height: 16),
                  InfoCard(
                    title: 'About me',
                    value: viewModel.state.description.isEmpty
                        ? 'No description added yet.'
                        : viewModel.state.description,
                    icon: Icons.description,
                    iconColor: AppColors.primary,
                    onTap: () => _showEditDescriptionSheet(context, viewModel),
                  ),
                  const SizedBox(height: 16),
                  if (viewModel.state.unsaved)
                    Text(
                      'You have unsaved changes',
                      style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
                    ),
                ],
              ),
            ),
    );
  }

  void _showEditDescriptionSheet(
      BuildContext context, ProfileViewModel viewModel) {

    final TextEditingController controller = TextEditingController(
      text: viewModel.state.description,
    );
    const int maxChars = 200;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                top: 24,
                left: 16,
                right: 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: controller,
                    maxLines: 6,
                    maxLength: maxChars,
                    decoration: const InputDecoration(
                      labelText: 'About me',
                      border: OutlineInputBorder(),
                      counterText: '',
                    ),
                    onChanged: (value) {
                      if (value.length <= maxChars) {
                        setModalState(() {});
                      } else {
                        controller.text = value.substring(0, maxChars);
                        controller.selection = TextSelection.fromPosition(
                          TextPosition(offset: controller.text.length),
                        );
                        setModalState(() {});
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${maxChars - controller.text.length} characters remaining',
                      style: TextStyle(
                        fontSize: 12,
                        color: controller.text.length >= maxChars
                            ? Colors.red
                            : Colors.grey[600],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      viewModel.updateDescription(controller.text);
                      Navigator.pop(context);
                    },
                    child: const Text('Back to Profile'),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showMeetingPreferenceSheet(
      BuildContext context, ProfileViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: Reachability.values.map((reachability) {
              return RadioListTile<Reachability>(
                title: Text(reachability.description),
                value: reachability,
                groupValue: viewModel.state.reachability,
                onChanged: (Reachability? newValue) {
                  if (newValue != null) {
                    viewModel.updateReachability(newValue);
                    Navigator.pop(context);
                  }
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _showSemesterSelectionSheet(
      BuildContext context, ProfileViewModel viewModel) {
    final List<int> semesters = List.generate(10, (index) => index + 1);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                children: [
                  RadioListTile<int>(
                    title: const Text('Professor'),
                    value: -1,
                    groupValue: viewModel.state.semester,
                    onChanged: (value) {
                      viewModel.updateSemester(value!);
                      Navigator.pop(context);
                    },
                  ),
                  ...semesters.map((semester) {
                    return RadioListTile<int>(
                      title: Text('Semester $semester'),
                      value: semester,
                      groupValue: viewModel.state.semester,
                      onChanged: (value) {
                        viewModel.updateSemester(value!);
                        Navigator.pop(context);
                      },
                    );
                  }),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
