import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:liftapp/data/userdata/user_controller.dart';
import 'package:liftapp/utils/college_seeder.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'auth/authentication_repository.dart';
import 'features/SignIn/controller/LoginController.dart';
import 'firebase_options.dart';



Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  Get.put(LoginController());
  Get.put(UserController());
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((_) => Get.put(AuthenticationRepository()));
  await CollegeSeeder.seedColleges();

  runApp(const App());
}