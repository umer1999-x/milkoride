import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:milkoride/services/auth_services.dart';
import 'package:milkoride/screens/utilites.dart';
import 'package:get/get.dart';
import 'package:milkoride/services/controllers.dart';

class SignUpScreen extends StatelessWidget with InputValidationMixin {
  final AuthService auth = AuthService(FirebaseAuth.instance);
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final formGlobalKey = GlobalKey<FormState>();

  SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('SignUp'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
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
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                  ),
                  validator: (name) {
                    if (isNameValid(name)) {
                      return null;
                    } else {
                      return 'Enter a valid name';
                    }
                  },
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
                  () => signController.isLoading.value
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
                              // formGlobalKey.currentState!.save();
                              final String email = emailController.text.trim();
                              final String password =
                                  passwordController.text.trim();
                              final String name = nameController.text.trim();

                              signController.isLoading.value = true;

                              var res = await auth.signUp(
                                  name, email, password, "user");
                              if (res.toString() == 'Signed Up') {
                                Get.offAllNamed('/login');

                                Get.defaultDialog(
                                  title: 'Alert',
                                  content: const Text('SignUp Completed'),
                                );
                              } else {
                                Get.defaultDialog(
                                  title: 'Alert',
                                  content: const Text(
                                      'User Already exists or Something went wrong'),
                                );
                                emailController.clear();
                                passwordController.clear();
                              }

                              signController.isLoading.value = false;
                            }
                          },
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
