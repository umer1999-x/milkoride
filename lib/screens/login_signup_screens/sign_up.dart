import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:milkoride/main.dart';
import 'package:milkoride/screens/login_signup_screens/login_screen.dart';
import 'package:milkoride/services/auth_services.dart';
import 'package:milkoride/screens/utilites.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:milkoride/screens/utilites.dart';

class SignupS extends StatefulWidget {
  const SignupS({Key? key}) : super(key: key);

  @override
  _SignupSState createState() => _SignupSState();
}

class _SignupSState extends State<SignupS> with InputValidationMixin {
  AuthService auth = AuthService(FirebaseAuth.instance);
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  final formGlobalKey = GlobalKey<FormState>();
  bool isLoading = false;

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
                isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                        onPressed: () async {
                          if (formGlobalKey.currentState!.validate()) {
                            // formGlobalKey.currentState!.save();
                            final String email = emailController.text.trim();
                            final String password =
                                passwordController.text.trim();
                            final String name = nameController.text.trim();
                            setState(() {
                              isLoading = true;
                            });
                            //User? user = FirebaseAuth.instance.currentUser;
                            var res =
                                await auth.signUp(name, email, password, "user");
                            if (res.toString() == 'Signed Up') {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyApp()));
                              buildShowDialog(
                                  context, "Alert", "SignUp Completed");
                            } else {
                              buildShowDialog(context, "Alert",
                                  "User Already exists or Something went wrong");
                              emailController.clear();
                              passwordController.clear();
                            }

                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.black,
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
