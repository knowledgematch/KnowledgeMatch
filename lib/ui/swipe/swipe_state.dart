class SwipeState {
  bool shouldShowGlow = false;
  String? title;

  SwipeState({
    required this.shouldShowGlow,
    this.title,
  });

  SwipeState copyWith({
    bool? shouldShowGlow,
    String? title,
  }) {
    return SwipeState(
        shouldShowGlow: shouldShowGlow ?? this.shouldShowGlow,
        title: title ?? this.title);
  }
}
