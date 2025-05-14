import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:knowledgematch/domain/models/user.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:knowledgematch/ui/profile/view_model/profile_view_model.dart';
import 'package:knowledgematch/domain/models/reachability.dart';

void main() {
  late ProfileViewModel viewModel;
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(ImageSource.gallery);
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    viewModel = ProfileViewModel();
  });

  test('updateSemester updates the semester and unsaved state', () {
    viewModel.updateSemester(5);
    expect(viewModel.state.semester, 5);
    expect(viewModel.state.unsaved, true);
  });

  test('updateReachability updates the reachability and unsaved state', () {
    viewModel.updateReachability(Reachability.onlineOrInPerson);
    expect(viewModel.state.reachability, Reachability.onlineOrInPerson);
    expect(viewModel.state.unsaved, true);
  });

  test('updateDescription updates the description and unsaved state', () {
    viewModel.updateDescription("New bio");
    expect(viewModel.state.description, "New bio");
    expect(viewModel.state.unsaved, true);
  });

  test('loadUserData loads data from shared preferences', () async {
    final prefs = await SharedPreferences.getInstance();
    final data = {
      'U_ID': '123',
    };
    await prefs.setString('userData', jsonEncode(data));
    var user = User.instance;
    user.name ='Test';
    user.surname = 'User';
    user.reachability = 0;
    user.email = 'test@example.com';
    user.description = 'Tester';
    await viewModel.loadUserData();
    expect(viewModel.state.uId, '123');
    expect(viewModel.state.description, 'Tester');
  });
}
