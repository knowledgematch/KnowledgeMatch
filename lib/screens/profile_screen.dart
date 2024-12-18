import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:knowledgematch/services/api_db_connection.dart';
import '../model/user.dart';
import '../model/reachability.dart';
import 'keyword_selection_screen.dart';
import 'login_screen.dart';
import 'change_pw_screen.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  final user = User.instance;
  Uint8List? _pictureData;
  String _uId = '';
  Reachability _reachability = Reachability.inPerson;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  int _semester = 1;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final fileBytes = await pickedFile.readAsBytes();
      const targetSizeInKB = 100;
      final compressedBytes =
          await compressImageToTargetSize(fileBytes, targetSizeInKB * 1024);
      setState(() {
        _pictureData = compressedBytes;
      });
    }
  }

  Future<Uint8List> compressImageToTargetSize(
      Uint8List fileBytes, int targetSizeInBytes) async {
    int quality = 100;
    Uint8List compressedBytes = fileBytes;
    while (compressedBytes.length > targetSizeInBytes && quality > 10) {
      compressedBytes = await FlutterImageCompress.compressWithList(
        fileBytes,
        quality: quality,
        minWidth: 300,
        minHeight: 300,
      );
      quality -= 10;
    }
    return compressedBytes;
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('userData');

    if (userDataString != null) {
      final userData = jsonDecode(userDataString);
      _uId = userData['U_ID'].toString();

      setState(() {
        _nameController.text = user.name!;
        _surnameController.text = user.surname!;
        _reachability = ReachabilityValue.fromValue(user.reachability ?? 0);
        _emailController.text = user.email!;
        _semester = user.seniority!;
        _descriptionController.text = user.description ?? '';
        _pictureData = user.getDecodedPicture();
      });
    }
  }

  Future<void> _saveProfile() async {
    try {
      final response = ApiDbConnection().saveProfile(
          _uId,
          _nameController.text,
          _surnameController.text,
          _reachability.value.toString(),
          _emailController.text,
          _semester.toString(),
          _descriptionController.text,
          _pictureData);
      if (response == 204) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile saved successfully!')),
        );

        user.name = _nameController.text;
        user.surname = _surnameController.text;
        user.reachability = _reachability.value;
        user.email = _emailController.text;
        user.seniority = _semester;
        user.description = _descriptionController.text;
        user.setPicture(_pictureData);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userData', jsonEncode({
          'U_ID': _uId,
          'Name': user.name,
          'Surname': user.surname,
          'Reachability': user.reachability,
          'Email': user.email,
          'Description': user.description,
        }));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save profile')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error:')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _pictureData != null
                        ? MemoryImage(_pictureData!)
                        : const AssetImage('assets/images/profile.png') as ImageProvider,
                  ),
                ),
                const SizedBox(height: 16),

                _buildTextField(_nameController, 'Name'),
                const SizedBox(height: 16),

                _buildTextField(_surnameController, 'Surname'),
                const SizedBox(height: 16),

                DropdownButtonFormField<Reachability>(
                  value: _reachability,
                  onChanged: (Reachability? newValue) {
                    setState(() {
                      _reachability = newValue!;
                    });
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

                _buildTextField(_emailController, 'Email'),
                const SizedBox(height: 16),

                DropdownButtonFormField<int>(
                  value: _semester,
                  decoration: const InputDecoration(
                    labelText: 'Semester',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    for (var i = 0; i <= 12; i++)
                      DropdownMenuItem(value: i, child: Text('Semester $i')),
                    const DropdownMenuItem(value: -1, child: Text('Professor')),
                  ],
                  onChanged: (value) => setState(() => _semester = value!),
                ),
                const SizedBox(height: 16),

                _buildDescriptionField(),
                const SizedBox(height: 16),

                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _saveProfile();
                    }
                  },
                  child: const Text('Save Changes'),
                ),
                const SizedBox(height: 16),

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
                    );
                  },
                  child: const Text('Change Password'),
                ),

                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const KeywordSelectionScreen()),
                    );
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

  Widget _buildDescriptionField() {
    return SizedBox(
      height: 100,
      child: TextFormField(
        controller: _descriptionController,
        maxLines: null,
        decoration: const InputDecoration(
          labelText: 'Description',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Future<void> _logout() async {
    ApiDbConnection().deleteFcmToken(User.instance.id ?? 0);
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    User.instance.reset();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
}
