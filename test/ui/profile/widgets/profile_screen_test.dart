import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:knowledgematch/domain/models/user.dart';
import 'package:knowledgematch/ui/profile/profile_state.dart';
import 'package:knowledgematch/ui/profile/view_model/profile_view_model.dart';
import 'package:knowledgematch/domain/models/reachability.dart';
import 'package:knowledgematch/ui/profile/widget/profile_screen.dart';
import 'package:provider/provider.dart';

class MockProfileViewModel extends ChangeNotifier implements ProfileViewModel {
  @override
  final nameController = TextEditingController(text: 'John');

  @override
  final surnameController = TextEditingController(text: 'Doe');

  @override
  final state = ProfileState(
    uId: '123',
    reachability: Reachability.online,
    semester: 2,
    description: 'I love Flutter!',
    pictureData: null,
    unsaved: true,
  );


  @override
  void updateDescription(String description) {}

  @override
  void updateReachability(Reachability reachability) {}

  @override
  void updateSemester(int semester) {}

  @override
  void dispose() {
    nameController.dispose();
    surnameController.dispose();
    super.dispose();
  }

  @override
  Future<Uint8List> compressImageToTargetSize(Uint8List fileBytes, int targetSizeInBytes) {
    throw UnimplementedError();
  }

  @override
  TextEditingController get emailController => throw UnimplementedError();

  @override
  Future<void> logout(BuildContext context) {
    throw UnimplementedError();
  }

  @override
  User get user => throw UnimplementedError();

  @override
  Future<void> loadUserData() async {

  }

  @override
  Future<void> pickImage() {
    throw UnimplementedError();
  }

  @override
  Future<void> saveProfile(BuildContext context) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteAccount() {
    throw UnimplementedError();
  }
}

void main() {
  testWidgets('ProfileScreen shows user data and edit button',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ChangeNotifierProvider<ProfileViewModel>(
              create: (_) => MockProfileViewModel(),
              child: const ProfileScreen(),
            ),
          ),
        );

        expect(find.text('John Doe'), findsOneWidget);
        expect(find.text('FHNW'), findsOneWidget);
        expect(find.text('Switzerland'), findsOneWidget);
        expect(find.text('Meeting Preference'), findsOneWidget);
        expect(find.text('Semester 2'), findsOneWidget);
        expect(find.text('I love Flutter!'), findsOneWidget);
        expect(find.text('You have unsaved changes'), findsOneWidget);
        expect(find.byIcon(Icons.edit), findsOneWidget);
      });
}
