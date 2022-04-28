import 'package:flutter/material.dart';
import 'package:milkoride/screens/utilites.dart';
import 'package:get/get.dart';
import 'package:milkoride/services/controllers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProduct extends StatefulWidget {
  EditProduct(
      this.productId, this.productName, this.productPrice, this.productUnit,
      {Key? key})
      : super(key: key);
  final String productId;
  final String productName;
  final int productPrice;
  final String productUnit;

  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> with InputValidationMixin {
  @override
  Widget build(BuildContext context) {
    final formGlobalKey = GlobalKey<FormState>();
    final TextEditingController nameController =
        TextEditingController(text: widget.productName.toString());
    final TextEditingController priceController =
        TextEditingController(text: widget.productPrice.toString());
    final TextEditingController unitController =
        TextEditingController(text: widget.productUnit.toString());
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
                  decoration: InputDecoration(
                    labelText: 'Product Unit',
                    border: const OutlineInputBorder(
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
                  height: 15.0,
                ),
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
                              final int productprice = int.parse(priceController.text.trim());
                              final String productunit =
                                  unitController.text.trim();

                              editProductController.isEdit.value = true;
                              await FirebaseFirestore.instance
                                  .collection('products')
                                  .doc(widget.productId.toString())
                                  .update({
                                'productName': productname,
                                'productPrice': productprice,
                                'productUnit': productunit
                              });
                              editProductController.isEdit.value = false;
                              Navigator.pop(context);
                            }
                          },
                          child: Text(
                            'Update Porduct',
                            style: TextStyle(
                              color: Colors.black,
                            ),
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
