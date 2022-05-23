import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:milkoride/controllers/add_product_controller.dart';
import 'package:milkoride/screens/utilites.dart';
import 'package:milkoride/services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:milkoride/services/controllers.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({
    Key? key,
  }) : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final picker = ImagePicker();
  String dropDownValue = 'Milk';
  var items = ['Milk', 'Other Product'];

  String dropDownValueUnit = 'kg';
  var itemsUnit = ['kg', 'liter'];

  Uint8List? _file;

  _selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                }),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add Product'.tr),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  "Add Product".tr,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.0))),
                    labelText: 'title'.tr,
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _priceController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.0))),
                    labelText: 'price'.tr,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Category'.tr,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      DropdownButtonHideUnderline(
                        child: DropdownButton(
                          borderRadius: BorderRadius.circular(16),
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: items.map((String items) {
                            return DropdownMenuItem(
                                value: items, child: Text(items));
                          }).toList(),
                          value: dropDownValue,
                          onChanged: (String? value) {
                            setState(() {
                              dropDownValue = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Price Unit'.tr,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      DropdownButtonHideUnderline(
                        child: DropdownButton(
                          borderRadius: BorderRadius.circular(16),
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: itemsUnit.map((String items) {
                            return DropdownMenuItem(
                                value: items, child: Text(items));
                          }).toList(),
                          value: dropDownValueUnit,
                          onChanged: (String? value) {
                            setState(() {
                              dropDownValueUnit = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                _file == null
                    ? ElevatedButton(
                        child: Text('Select product images'.tr),
                        onPressed: () {
                          _selectImage(context);
                        },
                      )
                    : Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: MemoryImage(_file!),
                          ),
                        ),
                      ),
                Obx(
                  () =>AbsorbPointer(
                    absorbing: _file == null ? true : false,
                        child:   addProductController.isProductUpload.value ? const Center(child: CircularProgressIndicator(),): ElevatedButton(
                            child: const Text('Upload'),
                            onPressed: () async {
                              addProductController.isProductUpload.value = true ;
                              try {
                                String res =
                                    await AuthService(FirebaseAuth.instance)
                                        .uploadProduct(
                                  _file!,
                                  (FirebaseAuth.instance.currentUser?.uid)
                                      as String,
                                  _titleController.text,
                                  dropDownValueUnit,
                                  dropDownValue,
                                  int.parse(_priceController.text),
                                );
                                addProductController.isProductUpload.value= false;
                                _file = null;
                                res == 'success'
                                    ? Get.snackbar('Alert', 'Product Added')
                                    : Get.snackbar('Alert', 'dont Product Added');
                              } catch (e) {
                                addProductController.isProductUpload.value= false;
                                _file = null;
                                if (kDebugMode) {
                                  print(e.toString());
                                }
                              }
                            },
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
