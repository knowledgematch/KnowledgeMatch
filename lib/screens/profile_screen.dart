import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:knowledgematch/services/api_db_connection.dart';
import 'package:knowledgematch/models/user.dart';
import 'package:knowledgematch/models/reachability.dart';
import '../widgets/custom_drop_down.dart';
import 'keyword_selection_screen.dart';
import 'login_screen.dart';
import 'change_pw_screen.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:knowledgematch/widgets/app_drawer.dart';

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

  //TODO move to service/utility class
  /// Opens the gallery to pick an image, compresses it, and updates the selected image data.
  ///
  /// This method allows the user to pick an image from the gallery, reads the image as bytes,
  /// compresses it to a target size (in kilobytes), and updates the state with the compressed
  /// image data.
  ///
  /// Parameters:
  /// - This method does not take any parameters. It uses the image picker to allow the user
  ///   to select and compress an image.
  ///
  /// Returns:
  /// - This method does not return anything.
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

  //TODO move to service/utility class
  /// Compresses an image to a target size in bytes.
  ///
  /// This method takes an image's byte data and compresses it iteratively to reduce its size
  /// until it meets the target size, adjusting the quality in each iteration. The compression
  /// stops once the target size is achieved or the quality reaches a minimum threshold.
  ///
  /// Parameters:
  /// - [fileBytes]: The byte data of the image to compress.
  /// - [targetSizeInBytes]: The target size in bytes for the compressed image.
  ///
  /// Returns:
  /// - A [Future] that completes with the compressed image byte data ([Uint8List]).
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

  //TODO move to service/utility class
  /// Loads the user data from shared preferences and updates the UI.
  ///
  /// This method retrieves the stored user data from shared preferences, decodes it, and updates
  /// the relevant fields in the UI, such as user name, email, semester, description, and picture.
  ///
  /// Parameters:
  /// - This method does not take any parameters. It uses the stored user data in shared preferences.
  ///
  /// Returns:
  /// - This method does not return anything.
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

  //TODO move to service/utility class
  /// Saves the user's profile data to the database and shared preferences.
  ///
  /// This method sends the updated user profile data to the server via the API. If the save operation is successful,
  /// it updates the local user object and shared preferences with the new profile data. If the operation fails,
  /// it displays an error message to the user.
  ///
  /// Parameters:
  /// - This method does not take any parameters. It uses the current values from the controllers and state variables.
  ///
  /// Returns:
  /// - This method does not return anything.
  Future<void> _saveProfile() async {
    try {
      final response = await ApiDbConnection().saveProfile(
          _uId,
          _nameController.text,
          _surnameController.text,
          _reachability.value.toString(),
          _emailController.text,
          _semester.toString(),
          _descriptionController.text,
          _pictureData);
      if (response == 204) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile saved successfully!')),
          );
        }

        user.name = _nameController.text;
        user.surname = _surnameController.text;
        user.reachability = _reachability.value;
        user.email = _emailController.text;
        user.seniority = _semester;
        user.description = _descriptionController.text;
        user.setPicture(_pictureData);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
            'userData',
            jsonEncode({
              'U_ID': _uId,
              'Name': user.name,
              'Surname': user.surname,
              'Reachability': user.reachability,
              'Email': user.email,
              'Description': user.description,
            }));
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save profile')),
          );
        }
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error:')),
        );
      }
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
      drawer: const AppDrawer(),
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
                    backgroundColor: Colors.grey[200],
                    backgroundImage: _pictureData != null
                        ? MemoryImage(_pictureData!)
                        : const AssetImage('assets/images/profile.png')
                            as ImageProvider,
                  ),
                ),
                const SizedBox(height: 16),
                _buildTextField(_nameController, 'Name'),
                const SizedBox(height: 16),
                _buildTextField(_surnameController, 'Surname'),
                const SizedBox(height: 16),
                CustomDropdown<Reachability>(
                  items: Reachability.values,
                  selectedItem: _reachability,
                  onChanged: (value) {
                    setState(() {
                      if (value != null) _reachability = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(_emailController, 'Email'),
                const SizedBox(height: 16),
                CustomDropdown<String>(
                    items: List<String>.generate(13, (i) => 'Semester $i')
                      ..add("Professor"),
                    labelText: "Semester",
                    selectedItem:
                        (List<String>.generate(13, (i) => 'Semester $i')
                          ..add("Professor"))[_semester],
                    onChanged: (value) => setState(
                          () => _semester =
                              (List<String>.generate(13, (i) => 'Semester $i')
                                    ..add("Professor"))
                                  .indexOf(value!),
                        )),
                const SizedBox(height: 16),
                _buildTextField(_descriptionController, 'Description'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _saveProfile();
                    }
                  },
                  child: const Text('Save Changes',
                      style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ChangePasswordScreen()),
                    );
                  },
                  child: const Text('Change Password',
                      style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const KeywordSelectionScreen()),
                    );
                  },
                  child: const Text('Edit Keywords',
                      style: TextStyle(color: Colors.white)),
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

  /// Logs out the user by clearing the session data and navigating to the login screen.
  ///
  /// This method deletes the user's FCM token from the server, clears all data stored in shared preferences,
  /// resets the user instance, and navigates the user to the login screen.
  ///
  /// Parameters:
  /// - This method does not take any parameters.
  ///
  /// Returns:
  /// - This method does not return anything.
  Future<void> _logout() async {
    ApiDbConnection().deleteFcmToken(User.instance.id ?? 0);
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    User.instance.reset();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }
}
