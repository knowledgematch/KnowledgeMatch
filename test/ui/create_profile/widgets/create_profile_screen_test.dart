import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:knowledgematch/ui/create_profile/view_model/create_profile_view_model.dart';
import 'package:knowledgematch/ui/create_profile/widgets/create_profile_screen.dart';
import 'package:provider/provider.dart';

class FakeCreateProfileViewModel extends CreateProfileViewModel {
  bool _success = false;
  bool _isValid = true;

  @override
  get state => super.state.copyWith(success: _success, isValid: _isValid);

  void setState({required bool success, required bool isValid}) {
    _success = success;
    _isValid = isValid;
    notifyListeners();
  }

  @override
  Future<void> createAccount() async {
    notifyListeners();
  }
}

void main() {
  Widget makeTestableWidget(Widget child, FakeCreateProfileViewModel viewModel) {
    return MaterialApp(
      home: ChangeNotifierProvider<CreateProfileViewModel>.value(
        value: viewModel,
        child: child,
      ),
    );
  }

  testWidgets('CreateProfileScreen shows all required input fields', (WidgetTester tester) async {
    final viewModel = FakeCreateProfileViewModel();

    await tester.pumpWidget(makeTestableWidget(const CreateProfileScreen(), viewModel));

    expect(find.byType(TextFormField), findsNWidgets(5));
    expect(find.widgetWithText(ElevatedButton, 'Create Account'), findsOneWidget);
    expect(find.text("Already have an account? Log in"), findsOneWidget);
  });

  testWidgets('Validation error shows when fields are empty', (WidgetTester tester) async {
    final viewModel = FakeCreateProfileViewModel();

    await tester.pumpWidget(makeTestableWidget(const CreateProfileScreen(), viewModel));
    final button = find.widgetWithText(ElevatedButton, 'Create Account');
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pumpAndSettle();


    expect(find.text('Please enter your name'), findsOneWidget);
    expect(find.text('Please enter your last name'), findsOneWidget);
    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter your password'), findsOneWidget);
    expect(find.text('Please confirm your password'), findsOneWidget);
  });

  testWidgets('Password mismatch dialog appears', (WidgetTester tester) async {
    final viewModel = FakeCreateProfileViewModel();

    await tester.pumpWidget(makeTestableWidget(const CreateProfileScreen(), viewModel));

    await tester.enterText(find.byType(TextFormField).at(0), 'John');
    await tester.enterText(find.byType(TextFormField).at(1), 'Doe');
    await tester.enterText(find.byType(TextFormField).at(2), 'john@example.com');
    await tester.enterText(find.byType(TextFormField).at(3), 'password');
    await tester.enterText(find.byType(TextFormField).at(4), 'notmatching');

    final button = find.widgetWithText(ElevatedButton, 'Create Account');
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(find.text("Passwords don't match"), findsOneWidget);
  });

  testWidgets('Invalid domain dialog appears', (WidgetTester tester) async {
    final viewModel = FakeCreateProfileViewModel();
    viewModel.setState(success: false, isValid: false);

    await tester.pumpWidget(makeTestableWidget(const CreateProfileScreen(), viewModel));

    await tester.enterText(find.byType(TextFormField).at(0), 'John');
    await tester.enterText(find.byType(TextFormField).at(1), 'Doe');
    await tester.enterText(find.byType(TextFormField).at(2), 'john@example.com');
    await tester.enterText(find.byType(TextFormField).at(3), 'password');
    await tester.enterText(find.byType(TextFormField).at(4), 'password');

    final button = find.widgetWithText(ElevatedButton, 'Create Account');
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(find.text('Invalid Email Domain'), findsOneWidget);
  });

  testWidgets('Success dialog appears on successful account creation', (WidgetTester tester) async {
    final viewModel = FakeCreateProfileViewModel();
    viewModel.setState(success: true, isValid: true);

    await tester.pumpWidget(makeTestableWidget(const CreateProfileScreen(), viewModel));

    await tester.enterText(find.byType(TextFormField).at(0), 'John');
    await tester.enterText(find.byType(TextFormField).at(1), 'Doe');
    await tester.enterText(find.byType(TextFormField).at(2), 'john@example.com');
    await tester.enterText(find.byType(TextFormField).at(3), 'password');
    await tester.enterText(find.byType(TextFormField).at(4), 'password');

    final button = find.widgetWithText(ElevatedButton, 'Create Account');
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(find.text('Account created successfully!'), findsOneWidget);
  });
}
