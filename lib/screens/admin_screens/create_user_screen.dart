import 'package:milkoride/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:milkoride/screens/utilites.dart';
import 'package:get/get.dart';
import 'package:milkoride/services/controllers.dart';

class CreateUser extends StatelessWidget with InputValidationMixin {
  final AuthService auth = AuthService(FirebaseAuth.instance);
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
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
                  const Text(
                    'Create User',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
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
                  const SizedBox(height: 20),
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
                      if (role == 'customer' || role == 'supplier' || role =='rider') {
                        return null;
                      } else {
                        return 'Enter a valid role';
                      }
                    },
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    controller: addressController,
                    decoration: const InputDecoration(
                      labelText: "Shipping Address",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                    ),
                    validator: (address) {
                      if (address!.isNotEmpty && address.contains(RegExp(r'[a-zA-Z0-9, ]'))) {
                        return null;
                      } else {
                        return 'Enter a valid address';
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  Obx(
                    () => createUserController.isCreating.value
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : ElevatedButton(
                            onPressed: () async {
                              if (formGlobalKey.currentState!.validate()) {
                                createUserController.isCreating.value = true;
                                final String name = nameController.text.trim();
                                final String email =
                                    emailController.text.trim();
                                final String password =
                                    passwordController.text.trim();
                                final String role = roleController.text.trim();
                                final String address =addressController.text.trim();
                                final String result = await auth.signUp(
                                    name, email, password, role,address);
                                if (result.toString() == 'Signed Up') {
                                  Get.defaultDialog(
                                    title: 'Alert',
                                    content: const Text('User Created'),
                                  );
                                  createUserController.isCreating.value =false;
                                  nameController.clear();
                                  emailController.clear();
                                  passwordController.clear();
                                  roleController.clear();
                                } else {
                                  createUserController.isCreating.value = false;
                                  Get.defaultDialog(
                                    title: 'Alert',
                                    content: const Text('Something went wrong'),
                                  );
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
