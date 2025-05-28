import 'package:flutter_test/flutter_test.dart';
import 'package:knowledgematch/data/services/api_db_connection.dart';
import 'package:knowledgematch/ui/create_profile/view_model/create_profile_view_model.dart';
import 'package:mocktail/mocktail.dart';

class MockApiDbConnection extends Mock implements ApiDbConnection {}

void main() {
  late CreateProfileViewModel viewModel;
  late MockApiDbConnection mockApi;

  setUp(() {
    mockApi = MockApiDbConnection();
    viewModel = CreateProfileViewModel(api: mockApi);
  });

  test('Initial state is correct', () {
    expect(viewModel.state.success, isFalse);
    expect(viewModel.state.isValid, isFalse);
    expect(viewModel.state.selectedImage, isNull);
  });

  test('createAccount sets success true when valid email and response is 200', () async {
    viewModel.nameController.text = 'John';
    viewModel.surnameController.text = 'Doe';
    viewModel.emailController.text = 'john@example.com';
    viewModel.passwordController.text = 'password';

    when(() => mockApi.isEmailDomainValid(any())).thenAnswer((_) async => true);
    when(() => mockApi.createAccount(
        any(), any(), any(), any(), any(), any()
    )).thenAnswer((_) async => 200);


    await viewModel.createAccount();

    expect(viewModel.state.isValid, isTrue);
    expect(viewModel.state.success, isTrue);
  });

  test('createAccount sets isValid false when email is invalid', () async {
    viewModel.emailController.text = 'invalid@example.com';

    when(() => mockApi.isEmailDomainValid(any())).thenAnswer((_) async => false);


    await viewModel.createAccount();

    expect(viewModel.state.isValid, isFalse);
    expect(viewModel.state.success, isFalse);
  });

  test('createAccount sets success false when response is not 200', () async {
    viewModel.nameController.text = 'Jane';
    viewModel.surnameController.text = 'Smith';
    viewModel.emailController.text = 'jane@example.com';
    viewModel.passwordController.text = 'password';

    when(() => mockApi.isEmailDomainValid(any())).thenAnswer((_) async => true);
    when(() => mockApi.createAccount(
        any(), any(), any(), any(), any(), any()
    )).thenAnswer((_) async => 500);


    await viewModel.createAccount();

    expect(viewModel.state.success, isFalse);
  });
}
