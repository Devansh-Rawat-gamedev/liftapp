import 'package:cloud_firestore/cloud_firestore.dart';
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
//TODO:fix don't save email in firestore use uid
  Future<User?> loginWithEmailPassword(String email, String password) async {
    try {
      // First, find the user document by email
      final query = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        throw "User not found";
      }

      // Role is verified, now sign in
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return result.user;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "Login failed";
    }
  }

  Future<void> logout() async => await _auth.signOut();
}
