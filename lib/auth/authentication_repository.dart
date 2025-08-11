import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import '../features/SignIn/screens/login.dart';
import '../features/dashboard/screens/dashboard.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();
  final _auth = FirebaseAuth.instance;

  @override
  void onReady() {
    super.onReady();
    _auth.userChanges().listen(_setInitialScreen);
  }

  void _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => const LoginPage());
    } else {
      Get.offAll(() =>  DashboardScreen());
    }
    FlutterNativeSplash.remove();
  }

  Future<User?> loginWithEmailPassword(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "Login failed";
    }
  }

  Future<void> logout() async => await _auth.signOut();
}
