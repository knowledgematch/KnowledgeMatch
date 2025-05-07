class LoginState {
  final bool isLoading;
  final String? errorMessage;
  final bool loginSuccess;

  const LoginState({
    this.isLoading = false,
    this.errorMessage,
    this.loginSuccess = false,
  });

  LoginState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? loginSuccess,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      loginSuccess: loginSuccess ?? this.loginSuccess,
    );
  }
}
