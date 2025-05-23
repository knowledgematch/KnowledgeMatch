import 'package:flutter_test/flutter_test.dart';
import 'package:knowledgematch/ui/login/view_model/login_view_model.dart';
import 'package:knowledgematch/data/services/api_db_connection.dart';
import 'package:mocktail/mocktail.dart';

class MockApiDbConnection extends Mock implements ApiDbConnection {}

void main() {
  late LoginViewModel viewModel;
  late MockApiDbConnection mockApi;

  setUp(() {
    mockApi = MockApiDbConnection();
    viewModel = LoginViewModel(api: mockApi);
  });

  test('login() sets loginSuccess to true on valid response', () async {
    viewModel.emailController.text = 'test@example.com';
    viewModel.passwordController.text = 'correctpassword';

    when(() => mockApi.login(any(), any()))
        .thenAnswer((_) async => '123456;some_token');

    await viewModel.login();

    expect(viewModel.state.loginSuccess, true);
    expect(viewModel.state.errorMessage, null);
    expect(viewModel.state.isLoading, false);
  });

  test('login() sets errorMessage on invalid response', () async {
    viewModel.emailController.text = 'test@example.com';
    viewModel.passwordController.text = 'wrongpassword';

    when(() => mockApi.login(any(), any()))
        .thenAnswer((_) async => 'Invalid credentials');


    await viewModel.login();

    expect(viewModel.state.loginSuccess, false);
    expect(viewModel.state.errorMessage, 'Invalid credentials');
    expect(viewModel.state.isLoading, false);
  });

  test('login() does not call API when fields are empty', () async {
    viewModel.emailController.text = '';
    viewModel.passwordController.text = '';

    await viewModel.login();

    verifyNever(() => mockApi.login(any(), any()));
    expect(viewModel.state.isLoading, false);
  });
}
