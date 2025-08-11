import 'package:get/get.dart';
import '../../../auth/authentication_repository.dart';
import 'package:flutter/material.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Please fill in all fields");
      return;
    }

    try {
      await AuthenticationRepository.instance.loginWithEmailPassword(email, password);
    } catch (e) {
      Get.snackbar("Login Failed", e.toString());
    }
  }
}
