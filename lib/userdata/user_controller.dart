import 'package:get/get.dart';
import 'package:liftapp/userdata/usemodel.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  final Rx<UserModel?> _user = Rx<UserModel?>(null);

  UserModel? get user => _user.value;

  void setUser(UserModel userModel) {
    _user.value = userModel;
  }

  void clearUser() {
    _user.value = null;
  }
}
