
import 'package:flutter/material.dart';
import 'package:milkoride/screens/utilites.dart';
import 'package:get/get.dart';
import 'package:milkoride/services/controllers.dart';
import '../../services/auth_services.dart';

class EditUser extends StatelessWidget with InputValidationMixin {
  final dynamic data = Get.arguments;
  EditUser({Key? key}) : super(key: key);
  final TextEditingController roleController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
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
                      if (role == 'customer' || role == 'supplier' || role =='rider') {
                        return null;
                      } else {
                        return 'enter a valid role';
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
                        return 'enter a valid email';
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
                        return 'enter a valid name';
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: addressController,
                    decoration: const InputDecoration(
                      labelText: "Shipping Address",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                    ),
                    validator: (address) {
                      if (address!.isNotEmpty && address.contains(RegExp(r'[a-zA-Z0-9#, ]'))) {
                        return null;
                      } else {
                        return 'Enter a valid address';
                      }
                    },
                  ),
                  Obx(
                    () => editController.isUpdating.value
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : ElevatedButton(
                            onPressed: () async {
                              String email = emailController.text.trim();
                              String newRole = roleController.text.trim();
                              String name = nameController.text.trim();
                              String address = addressController.text.trim();
                              if (formGlobalKey.currentState!.validate()) {
                                editController.isUpdating.value = true;
                                String res = await AuthService.updateUser(
                                    name, newRole, email, data[0].toString(),address);
                                if (res == "successfully updated") {
                                  emailController.clear();
                                  roleController.clear();
                                  nameController.clear();
                                  addressController.clear();
                                  editController.isUpdating.value = false;
                                } else {
                                  emailController.clear();
                                  roleController.clear();
                                  nameController.clear();
                                  addressController.clear();
                                  editController.isUpdating.value = false;
                                }
                              }
                              else{
                                Get.defaultDialog(
                                  title: 'Alert',
                                  content: const Text('Enter a Valid details'),
                                );
                              }
                            },
                            child: const Text('Update'),
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
