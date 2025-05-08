import 'package:flutter/material.dart';

class TwoFAState {
  final GlobalKey<FormState> formKey;
  final TextEditingController codeController;
  final String email;

  TwoFAState({
    GlobalKey<FormState>? formKey,
    TextEditingController? codeController,
    this.email = '',
  })  : formKey = formKey ?? GlobalKey<FormState>(),
        codeController = codeController ?? TextEditingController();

  TwoFAState copyWith({
    GlobalKey<FormState>? formKey,
    TextEditingController? codeController,
    String? email,
  }) {
    return TwoFAState(
      formKey: formKey ?? this.formKey,
      codeController: codeController ?? this.codeController,
      email: email ?? this.email,
    );
  }
}
