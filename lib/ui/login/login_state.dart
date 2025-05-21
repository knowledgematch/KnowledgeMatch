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
      errorMessage: errorMessage ?? this.errorMessage,
      loginSuccess: loginSuccess ?? this.loginSuccess,
    );
  }
  LoginState clearError(){
    return LoginState(
      isLoading: isLoading,
      errorMessage: null,
      loginSuccess: loginSuccess,
    );
  }
}
