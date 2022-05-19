import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:milkoride/screens/utilites.dart';
import 'package:get/get.dart';
import 'package:milkoride/services/controllers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:milkoride/services/storages_methods.dart';

class EditProduct extends StatefulWidget {
  EditProduct(this.productId, this.productName, this.productPrice,
      this.productUnit, this.productPicUrl,
      {Key? key})
      : super(key: key);
  final String productId;
  final String productName;
  final int productPrice;
  final String productUnit;
  final String productPicUrl;

  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> with InputValidationMixin {
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
                  Uint8List? file = await pickImage(ImageSource.camera);
                  //editProductController.file?.value = file;
                  setState(() {
                    if (kDebugMode) {
                      print('In setstate');
                    }
                    _file = file;

                    if (kDebugMode) {
                      print('+++++' + _file.toString());
                    }
                  });
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List? file = await pickImage(ImageSource.gallery);
                  // editProductController.file?.value = file;
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

  @override
  Widget build(BuildContext context) {
    final formGlobalKey = GlobalKey<FormState>();
    final TextEditingController nameController =
        TextEditingController(text: widget.productName.toString());
    final TextEditingController priceController =
        TextEditingController(text: widget.productPrice.toString());
    final TextEditingController unitController =
        TextEditingController(text: widget.productUnit.toString());
    String imageUrl = widget.productPicUrl.toString();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Edit Product'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: formGlobalKey,
            child: ListView(
              scrollDirection: Axis.vertical,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Product Name',
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                  ),
                  validator: (name) {
                    if (isNameValid(name)) {
                      return null;
                    } else {
                      return 'Enter a valid product name';
                    }
                  },
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Porduct Price',
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                  ),
                  validator: (product) {
                    if (isPriceValid(product)) {
                      return null;
                    } else {
                      return 'Enter a valid product price';
                    }
                  },
                ),
                const SizedBox(
                  height: 15.0,
                ),
                TextFormField(
                  controller: unitController,
                  decoration: const InputDecoration(
                    labelText: 'Product Unit',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                  ),
                  validator: (unit) {
                    if (unit == 'kg' || unit == 'liter') {
                      return null;
                    } else {
                      return 'Enter a valid product unit';
                    }
                  },
                ),
                const SizedBox(
                  height: 8.0,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  child: Text('Change Image'.tr),
                  onPressed: () => _selectImage(context),
                ),
                // Obx(
                //   () => Container(
                //     width: MediaQuery.of(context).size.width,
                //     height: MediaQuery.of(context).size.height / 2,
                //     decoration: BoxDecoration(
                //         image: DecorationImage(
                //             fit: BoxFit.fill, image: NetworkImage(imageUrl)
                //             //editProductController.file.value.isEmpty
                //             //     ? NetworkImage(imageUrl)
                //             //     : MemoryImage(editProductController.file.value),
                //             )),
                //   ),
                // ),
                // Container(
                //   width: MediaQuery.of(context).size.width,
                //   height: MediaQuery.of(context).size.height / 2,
                //   decoration: BoxDecoration(
                //     image: editProductController.file?.value == null
                //         ? DecorationImage(
                //             fit: BoxFit.fill,
                //             image: NetworkImage(imageUrl),
                //           )
                //         : DecorationImage(
                //             fit: BoxFit.fill,
                //             image: MemoryImage(editProductController
                //                 .file?.value as Uint8List),
                //           ),
                //   ),
                // ),

                Obx(
                  () => editProductController.isEdit.value
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
                              final String productname =
                                  nameController.text.trim();
                              final int productprice =
                                  int.parse(priceController.text.trim());
                              final String productunit =
                                  unitController.text.trim();
                              if (kDebugMode) {
                                print("in updateFunc" + _file.toString());
                              }
                              if (_file!.isNotEmpty) {
                                if (kDebugMode) {
                                  print('hereeee');
                                }
                                imageUrl = await StorageMethods()
                                    .uploadImageToStorage('products', _file!);
                              }

                              editProductController.isEdit.value = true;
                              await FirebaseFirestore.instance
                                  .collection('products')
                                  .doc(widget.productId.toString())
                                  .update({
                                'productName': productname,
                                'productPrice': productprice,
                                'productUnit': productunit,
                                'productPicUrl': imageUrl,
                              });
                              editProductController.isEdit.value = false;
                              Navigator.pop(context);
                            }
                          },
                          child: const Text(
                            'Update Porduct',
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
