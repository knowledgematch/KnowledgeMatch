class ContactState {
  final bool isSending;

  ContactState({
    this.isSending = false,
  });

  ContactState copyWith({
    bool? isSending,
  }) {
    return ContactState(
      isSending: isSending ?? this.isSending,
    );
  }
}
