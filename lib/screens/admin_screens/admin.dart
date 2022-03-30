import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:milkoride/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:milkoride/services/auth_services.dart';
import 'package:milkoride/widgets/admin_screen_widgets/admin_drawer.dart';
import 'package:milkoride/screens/admin_screens/edit_user_data.dart';
import 'package:milkoride/screens/utilites.dart';

class AdminScreen extends StatefulWidget {
  AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> with InputValidationMixin {
  TextEditingController emailController = TextEditingController();
  AuthService auth = AuthService(FirebaseAuth.instance);
  String email = "";
  String uid = "";
  String role = "";
  String password = "";
  bool ableToEdit = false;
  bool ableToDelete = false;
  final formGlobalKey = GlobalKey<FormState>();

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
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => MyApp()));
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
                // mainAxisAlignment: MainAxisAlignment.center,
                //   crossAxisAlignment: CrossAxisAlignment.center,
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
                        print('message');
                        print(snap.docs.toString().isNotEmpty);
                        if (snap.docs.isNotEmpty) {
                          setState(() {
                            email = userEmail;
                            uid = snap.docs[0]['uid'];
                            role = snap.docs[0]['role'];
                            password = snap.docs[0]['password'];
                            ableToEdit = true;
                            ableToDelete = true;
                          });
                        } else {
                          buildShowDialog(
                              context, 'Alert', "Something Went Wrong");
                          setState(() {
                            ableToEdit = false;
                            ableToDelete = false;
                            emailController.clear();
                            email = "";
                            role = "";
                            password = "";
                            uid = "";
                          });
                        }
                      } else {
                        buildShowDialog(
                            context, 'Alert', "Something Went Wrong");
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
                  ableToEdit
                      ? ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditUser(
                                          uid: uid,
                                        )));
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
                  const SizedBox(height: 10),
                  ableToDelete
                      ? ElevatedButton(
                          onPressed: () async {
                            dynamic res = await auth.deleteUser(uid);
                            print(res);
                            if (res == 'successfully deleted') {
                              buildShowDialog(context, 'Alert', "User Deleted");
                              setState(() {
                                ableToDelete = false;
                                ableToEdit = false;
                                emailController.clear();
                                email = "";
                                role = "";
                                password = "";
                                uid = "";
                              });
                            } else {
                              buildShowDialog(
                                  context, 'Alert', "Something Went Wrong");
                              setState(() {
                                ableToDelete = false;
                                ableToEdit = false;
                                emailController.clear();
                                email = "";
                                role = "";
                                password = "";
                                uid = "";
                              });
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
                  ListTile(
                    title: Text('Email : ' + email),
                  ),
                  ListTile(
                    title: Text('UID : ' + uid),
                  ),
                  ListTile(
                    title: Text('Role : ' + role),
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
