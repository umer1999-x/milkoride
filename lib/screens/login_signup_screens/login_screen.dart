import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:milkoride/screens/admin_screens/admin.dart';
import 'package:milkoride/screens/supplier_screen.dart';
import 'package:milkoride/screens/customer_screens/customer_home_screen.dart';
import 'package:milkoride/services/auth_services.dart';
import 'package:milkoride/screens/utilites.dart';
import 'package:milkoride/screens/login_signup_screens/sign_up.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';
import 'package:milkoride/services/controllers.dart';

class LoginScreen extends StatelessWidget with InputValidationMixin {
  LoginScreen({Key? key}) : super(key: key);

  final AuthService auth = AuthService(FirebaseAuth.instance);
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formGlobalKey = GlobalKey<FormState>();

  void checkRole() async {
    User? user = FirebaseAuth.instance.currentUser;
    final DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    loginController.role.value = snap['role'];
    if (loginController.roleAssign == 'user') {
      navigateNext(const CustomerScreen());
    } else if (loginController.roleAssign == 'admin') {
      navigateNext(AdminScreen());
    } else if (loginController.roleAssign == 'supplier') {
      navigateNext(const SupplierScreen());
    }
  }

  void navigateNext(Widget route) {
    Timer(const Duration(milliseconds: 500), () {
      Get.offAll(() => route);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('LogIn'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: formGlobalKey,
            child: ListView(
              scrollDirection: Axis.vertical,
              children: [
                SizedBox(
                  height: 180,
                  child: Center(
                    child: Lottie.asset(
                      'images/user-profile.json',
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                  ),
                  validator: (email) {
                    if (isEmailValid(email)) {
                      return null;
                    } else {
                      return 'Enter a valid email address';
                    }
                  },
                ),
                const SizedBox(
                  height: 15.0,
                ),
                TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                  ),
                  maxLength: 10,
                  obscureText: true,
                  validator: (password) {
                    if (isPasswordValid(password)) {
                      return null;
                    } else {
                      return 'Enter a valid password';
                    }
                  },
                ),
                Obx(
                  () => loginController.isLoading.value
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                          onPressed: () async {
                            if (formGlobalKey.currentState!.validate()) {
                              final String email = emailController.text.trim();
                              final String password =
                                  passwordController.text.trim();
                              loginController.isLoading.value = true;
                              var res = await auth.login(email, password);
                              if (kDebugMode) {
                                print(res);
                              }
                              if (res.toString() == 'Logged In') {
                                checkRole();
                                Get.defaultDialog(
                                  title: 'Alert',
                                  content: const Text('SigIn Completed'),

                                );
                              } else {
                                Get.defaultDialog(
                                  title: 'Alert',
                                  content: const Text('SigIn went wrong'),
                                );
                                emailController.clear();
                                passwordController.clear();
                              }
                              loginController.isLoading.value = false;
                            }
                          },
                          child: const Text(
                            'LogIn',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                ),

                const SizedBox(
                  height: 30.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Don\'t Have an Account? '),
                    InkWell(
                      onTap: () {
                        Get.to(() => SignUpScreen());
                      },
                      child: const Text(
                        ' SignUp',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    )
                  ],
                ),
                //loginButton
              ],
            ),
          ),
        ),
      ),
    );
  }
}
