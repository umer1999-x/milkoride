import 'package:milkoride/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:milkoride/screens/utilites.dart';
class CreateUser extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<CreateUser> with InputValidationMixin{
  AuthService auth = AuthService(FirebaseAuth.instance);
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController roleController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  final formGlobalKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Create User"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: formGlobalKey,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Create User',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight:FontWeight.bold,
                    ),
                  ),
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: "Name",
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
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: "Email",
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
                  const SizedBox(height: 10),
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
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: roleController,
                    decoration: const InputDecoration(
                      labelText: "Role",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                    ),
                    validator: (role) {
                      if (role=='customer'|| role=='supplier') {
                        return null;
                      } else {
                        return 'Enter a valid role';
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      if (formGlobalKey.currentState!.validate()) {
                        String name = nameController.text.trim();
                        String email = emailController.text.trim();
                        String password = passwordController.text.trim();
                        String role = roleController.text.trim();
                        var result = await auth.signUp(name, email, password, role);
                        if (result.toString() == 'Signed Up') {
                          buildShowDialog(context, 'Alert', "User Created");
                          nameController.clear();
                          emailController.clear();
                          passwordController.clear();
                          roleController.clear();
                        }
                        else{
                          buildShowDialog(context, 'Alert', "Something went wrong");
                        }
                      }
                    },
                    child: Container(
                      height: 50,
                      width: 100,
                      color: Colors.blue,
                      child: const Center(
                        child: Text(
                          "Create User",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
