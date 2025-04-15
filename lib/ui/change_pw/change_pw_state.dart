import 'package:flutter/material.dart';

class ChangePWState {
  final GlobalKey<FormState> formKey;
  final TextEditingController oldPasswordController;
  final TextEditingController newPasswordController;
  final TextEditingController confirmNewPasswordController;
  final String email;

  ChangePWState({
    GlobalKey<FormState>? formKey,
    TextEditingController? oldPasswordController,
    TextEditingController? newPasswordController,
    TextEditingController? confirmNewPasswordController,
    this.email = '',
  })  : formKey = formKey ?? GlobalKey<FormState>(),
        oldPasswordController =
            oldPasswordController ?? TextEditingController(),
        newPasswordController =
            newPasswordController ?? TextEditingController(),
        confirmNewPasswordController =
            confirmNewPasswordController ?? TextEditingController();

  ChangePWState copyWith({
    String? email,
    GlobalKey<FormState>? formKey,
    TextEditingController? oldPasswordController,
    TextEditingController? newPasswordController,
    TextEditingController? confirmNewPasswordController,
  }) {
    return ChangePWState(
      email: email ?? this.email,
      formKey: formKey ?? this.formKey,
      oldPasswordController:
          oldPasswordController ?? this.oldPasswordController,
      newPasswordController:
          newPasswordController ?? this.newPasswordController,
      confirmNewPasswordController:
          confirmNewPasswordController ?? this.confirmNewPasswordController,
    );
  }
}
