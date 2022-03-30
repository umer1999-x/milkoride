import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:milkoride/screens/admin_screens/admin.dart';
import 'package:milkoride/screens/supplier_screen.dart';
import 'package:milkoride/screens/customer_screens/customer_home_screen.dart';
import 'package:milkoride/services/auth_services.dart';
import 'package:milkoride/screens/utilites.dart';
import 'package:milkoride/screens/login_signup_screens/sign_up.dart';
import 'package:lottie/lottie.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with InputValidationMixin {
  @override
  void initState() {
    super.initState();
  }

  AuthService auth = AuthService(FirebaseAuth.instance);
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formGlobalKey = GlobalKey<FormState>();
  String role = 'user';
  bool isLoading = false;

  void checkRole() async {
    User? user = FirebaseAuth.instance.currentUser;
    final DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    setState(() {
      role = snap['role'];
    });

    if (role == 'user') {
      navigateNext(const CustomerScreen());
    } else if (role == 'admin') {
      navigateNext(AdminScreen());
    } else if (role == 'supplier') {
      navigateNext(SupplierScreen());
    }
  }

  void navigateNext(Widget route) {
    Timer(const Duration(milliseconds: 500), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => route));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
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
                          setState(() {
                            isLoading = true;
                          });
                          var res = await auth.login(email, password);
                          print(res);
                          if (res.toString() == 'Logged In') {
                            checkRole();
                            buildShowDialog(
                                context, "Alert", "SigIn Completed");
                          } else {
                            buildShowDialog(context, "Alert",
                                "User don't exists or Use Right Credential");
                            emailController.clear();
                            passwordController.clear();
                          }
                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                      child: const Text(
                        'LogIn',
                        style: TextStyle(
                          color: Colors.black,
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
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => SignupS()));
                    },
                    child: const Text(
                      ' SignUp',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                  )
                ],
              )
              //loginButton
            ],
          ),
        ),
      ),
    );
  }
}
