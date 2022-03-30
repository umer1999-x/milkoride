import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:milkoride/screens/utilites.dart';

class EditUser extends StatefulWidget {
  final String? uid;

  EditUser({this.uid});
  @override
  _EditUserState createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> with InputValidationMixin {
  TextEditingController roleController = TextEditingController();
  //TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final formGlobalKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Update'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: formGlobalKey,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Edit User',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: roleController,
                    decoration: const InputDecoration(
                        hintText: "Role", border: OutlineInputBorder()),
                    validator: (role) {
                      if (role == 'customer' || role == 'supplier') {
                        return null;
                      } else {
                        return "enter a valid role";
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                        hintText: "Email", border: OutlineInputBorder()),
                    validator: (email) {
                      if (isEmailValid(email)) {
                        return null;
                      } else {
                        return "enter a valid email";
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                        hintText: "Name", border: OutlineInputBorder()),
                    validator: (name) {
                      if (isNameValid(name)) {
                        return null;
                      } else {
                        return "enter a valid name";
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      String email = emailController.text.trim();
                      String newRole = roleController.text.trim();
                      //String newPassword = passwordController.text.trim();
                      String name = nameController.text.trim();
                      if (formGlobalKey.currentState!.validate()) {
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(widget.uid)
                            .update({
                          'name': name,
                          'role': newRole,
                          'email': email,
                          //'password': newPassword,
                        });
                        buildShowDialog(context, "Alert", 'Updated');
                        setState(() {
                          emailController.clear();
                          roleController.clear();
                          nameController.clear();
                        });
                      } else {
                        buildShowDialog(context, 'Alert', 'Updating error');
                      }
                    },
                    child: const Text('Update'),
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
