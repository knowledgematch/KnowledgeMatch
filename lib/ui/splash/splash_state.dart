class SplashState {
  final bool? isLoggedIn;

  SplashState({required this.isLoggedIn});

  SplashState copyWith({
    required bool isLoggedIn,
  }) {
    return SplashState(isLoggedIn: isLoggedIn);
  }
}
