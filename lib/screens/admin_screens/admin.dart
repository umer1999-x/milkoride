import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:milkoride/services/auth_services.dart';
import 'package:milkoride/services/controllers.dart';
import 'package:milkoride/widgets/admin_screen_widgets/admin_drawer.dart';
import 'package:milkoride/screens/admin_screens/edit_user_data.dart';
import 'package:milkoride/screens/utilites.dart';



class AdminScreen extends StatelessWidget with InputValidationMixin {
  final TextEditingController emailController = TextEditingController();
  final AuthService auth = AuthService(FirebaseAuth.instance);
  final formGlobalKey = GlobalKey<FormState>();
  AdminScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: AdminDrawer(),
        appBar: AppBar(
          title: const Text('Admin Screen'),
          actions: [
            TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.white,
                ),
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Get.offAndToNamed('/login');
                },
                child: const Text(
                  'Sign Out',
                )),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            scrollDirection: Axis.vertical,
            child: Form(
              key: formGlobalKey,
              child: Column(
                children: [
                  const Text(
                    'Admin Screen',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
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
                  const SizedBox(
                    height: 10.0,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (formGlobalKey.currentState!.validate()) {
                        String userEmail = emailController.text.trim();
                        final QuerySnapshot snap = await FirebaseFirestore
                            .instance
                            .collection('users')
                            .where('email', isEqualTo: userEmail)
                            .get();
                        if (snap.docs.isNotEmpty) {
                          adminController.name.value = snap.docs[0]['name'];
                          adminController.email.value = userEmail;
                          adminController.uid.value = snap.docs[0]['uid'];
                          adminController.role.value = snap.docs[0]['role'];
                          adminController.password.value =
                              snap.docs[0]['password'];
                          adminController.address.value=snap.docs[0]['address'];
                          adminController.ableToEdit.value = true;
                          adminController.ableToDelete.value = true;
                        } else {
                          Get.defaultDialog(
                            title: 'Alert',
                            content: const Text('Something Went Wrong'),
                          );
                          adminController.ableToEdit.value = false;
                          adminController.ableToDelete.value = false;
                          emailController.clear();
                          adminController.email.value = "";
                          adminController.role.value = "";
                          adminController.password.value = "";
                          adminController.uid.value = "";
                          adminController.name.value = "";
                          adminController.address.value = "";
                        }
                      } else {
                        Get.defaultDialog(
                          title: 'Alert',
                          content: const Text('Something Went Wrong'),
                        );
                      }
                    },
                    child: Container(
                      height: 50,
                      width: 100,
                      color: Colors.blue,
                      child: const Center(
                        child: Text(
                          "Get User Data",
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Obx(
                    () => adminController.ableToEdit.value
                        ? ElevatedButton(
                            onPressed: () {
                              Get.to(() => EditUser(), arguments: [
                                adminController.uid.value,
                                adminController.email.value,
                                adminController.role.value,
                                adminController.name.value,
                                  adminController.address.value,
                              ]);
                            },
                            child: Container(
                              height: 50,
                              width: 100,
                              color: Colors.blue,
                              child: const Center(
                                child: Text(
                                  "Edit User",
                                ),
                              ),
                            ),
                          )
                        : Container(),
                  ),
                  const SizedBox(height: 10),
                  Obx(
                    () => adminController.ableToDelete.value
                        ? ElevatedButton(
                            onPressed: () async {
                              dynamic res = await auth.deleteUser(adminController.uid.value);
                              if (kDebugMode) {
                                print(res);
                              }
                              if (res == 'successfully deleted') {
                                Get.defaultDialog(
                                  title: 'Alert',
                                  content: const Text('User Deleted'),
                                );
                                adminController.ableToEdit.value = false;
                                adminController.ableToDelete.value = false;
                                emailController.clear();
                                adminController.email.value = "";
                                adminController.role.value = "";
                                adminController.password.value = "";
                                adminController.uid.value = "";
                                adminController.name.value = "";
                                adminController.address.value = "";
                              } else {
                                Get.defaultDialog(
                                  title: 'Alert',
                                  content: const Text('Something Went Wrong'),
                                );
                                adminController.ableToEdit.value = false;
                                adminController.ableToDelete.value = false;
                                emailController.clear();
                                adminController.email.value = "";
                                adminController.role.value = "";
                                adminController.password.value = "";
                                adminController.uid.value = "";
                                adminController.name.value = "";
                                adminController.address.value = "";
                              }
                            },
                            child: Container(
                              height: 50,
                              width: 100,
                              color: Colors.blue,
                              child: const Center(
                                child: Text(
                                  "Delete User",
                                ),
                              ),
                            ),
                          )
                        : Container(),
                  ),
                  // const SizedBox(
                  //   height: 20,
                  // ),
                  const ListTile(
                    title: Text(
                      'User Data',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Obx(
                    () => Card(
                      elevation: 5.0,
                      child: ListTile(
                        title: Column(
                          children: [
                            Text('Name : ' + adminController.name.value),
                            Text('Email : ' + adminController.email.value),
                            Text('UID : ' + adminController.uid.value),
                            Text('Role : ' + adminController.role.value),
                            Text('Role : ' + adminController.address.value),
                          ],
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
