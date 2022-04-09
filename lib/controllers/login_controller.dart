import 'package:get/get.dart';

class LoginController extends GetxController {
  static LoginController instance = Get.find();

  RxString role = 'user'.obs;
  RxBool isLoading = false.obs;

  String get roleAssign => role.value;
}
