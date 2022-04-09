import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AdminController extends GetxController{
  static AdminController instance = Get.find();
  RxBool ableToEdit = false.obs;
  RxBool ableToDelete = false.obs;
  RxString name = "".obs;
  RxString email = "".obs;
  RxString uid = "".obs;
  RxString role = "".obs;
  RxString password = "".obs;


}