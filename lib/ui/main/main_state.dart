class MainState {
  final int currentIndex;

  MainState({ required this.currentIndex });

  MainState copyWith({
    required int currentIndex,
  }) {
    return MainState(
        currentIndex: currentIndex
    );
  }
}