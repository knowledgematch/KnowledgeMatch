import 'package:flutter/material.dart';

class ForgotPwState {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;

  ForgotPwState({
    GlobalKey<FormState>? formKey,
    TextEditingController? emailController,
  })  : formKey = formKey ?? GlobalKey<FormState>(),
        emailController = emailController ?? TextEditingController();

  ForgotPwState copyWith({
    GlobalKey<FormState>? formKey,
    TextEditingController? emailController,
  }) {
    return ForgotPwState(
      formKey: formKey ?? this.formKey,
      emailController: emailController ?? this.emailController,
    );
  }
}
