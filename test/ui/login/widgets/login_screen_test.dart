import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:knowledgematch/data/services/api_db_connection.dart';
import 'package:knowledgematch/ui/login/login_state.dart';
import 'package:knowledgematch/ui/login/widgets/login_screen.dart';
import 'package:knowledgematch/ui/login/view_model/login_view_model.dart';
import 'package:knowledgematch/ui/two_fa/widgets/two_fa_screen.dart';
import 'package:provider/provider.dart';

class FakeLoginViewModel extends ChangeNotifier implements LoginViewModel {
  @override
  final TextEditingController emailController = TextEditingController();
  @override
  final TextEditingController passwordController = TextEditingController();

  LoginState _state = const LoginState();

  @override
  LoginState get state => _state;

  @override
  Future<void> login() async {
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 100));
  }

  void overrideState(LoginState newState) {
    _state = newState;
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  ApiDbConnection get api => throw UnimplementedError();
}

void main() {
  testWidgets('LoginScreen shows CircularProgressIndicator when loading', (WidgetTester tester) async {
    final fakeViewModel = FakeLoginViewModel();
    fakeViewModel.overrideState(fakeViewModel.state.copyWith(isLoading: true));

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<LoginViewModel>.value(
          value: fakeViewModel,
          child: const LoginScreen(),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('LoginScreen shows SnackBar on login failure', (WidgetTester tester) async {
    final fakeViewModel = FakeLoginViewModel();

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<LoginViewModel>.value(
          value: fakeViewModel,
          child: const LoginScreen(),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField).at(0), 'test@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'wrongpassword');

    fakeViewModel.overrideState(const LoginState(
      isLoading: false,
      loginSuccess: false,
      errorMessage: 'Invalid credentials',
    ));
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Invalid credentials'), findsOneWidget);
  });

  testWidgets('Navigates to TwoFAScreen on successful login', (WidgetTester tester) async {
    final fakeViewModel = FakeLoginViewModel();

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<LoginViewModel>.value(
          value: fakeViewModel,
          child: const LoginScreen(),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField).at(0), 'test@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'correctpassword');

    fakeViewModel.overrideState(const LoginState(
      isLoading: false,
      loginSuccess: true,
    ));

    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    expect(find.byType(TwoFAScreen), findsOneWidget);
  });

}
