import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:milkoride/models/cart_model.dart';
import 'package:milkoride/services/controllers.dart';
import 'package:get/get.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cart Screen'),
          centerTitle: true,
        ),
        body: ListView(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.all(6),
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8.0),
              child: Obx(
                () => ListView.builder(
                  //scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    CartModel product = cartController.cartList[index];
                    // cartController.totalCartPrice.value =
                    //     cartController.totalCartPrice.value +
                    //         (product.quantity.value as int) *
                    //             int.parse(product.productPrice);
                    // print('total price');
                    // print(cartController.totalCartPrice.value);
                    //cartController.totalPrice(index);
                    return Card(
                      margin: EdgeInsets.all(6),
                      shadowColor: Colors.lightBlue,
                      elevation: 5.0,
                      color: Colors.blue,
                      child: CartTile(
                        productImageUrl: product.productImage,
                        //cartController.cartList[index].productImage,
                        productName: product.productName,
                        //cartController.cartList[index].productName,
                        index: index,
                        productItemCount: product.quantity,
                        //cartController.cartList[index].quantity.value,
                        productPrice: product.productPrice,
                        productUnit: product.productUnit,
                      ),
                    );
                  },
                  itemCount: cartController.cartList.length,
                ),
              ),
            ),
            Obx(
              () => TextButton(
                onPressed:null,
                style: TextButton.styleFrom(
                  elevation: 5,
                  primary: Colors.purple,
                  backgroundColor: Colors.blue,
                  textStyle: TextStyle(
                    fontSize: 24,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                child: Text('Total: ' + cartController.totalCartPrice.string),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CartTile extends StatelessWidget {
  CartTile({
    Key? key,
    required this.productImageUrl,
    required this.productName,
    required this.productPrice,
    required this.productItemCount,
    required this.productUnit,
    required this.index,
  }) : super(key: key);
  var productImageUrl;
  var productName;
  var productPrice;
  var productUnit;
  RxInt productItemCount;
  var index;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.transparent,
            child: Image.network(
              productImageUrl,
            ),
          ),
          Expanded(
            child: ListTile(
              title: Text(productName),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Rs ' + productPrice.toString()),
                  Text('Per ' + productUnit)
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 6,
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                // borderRadius: BorderRadius.circular(22),
                shape: BoxShape.circle,
                color: Colors.red,
              ),
              child: IconButton(
                iconSize: 30,
                onPressed: () {
                  cartController.quantityIncrement(index);
                  print('pressed total price');
                  var res = cartController.cartPrice();
                  print('res ' + res.toString());
                  //cartController.cartList[index].quantity++;
                  print('incremented');
                },
                icon: const Icon(
                  Icons.add,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          SizedBox(
            child: Obx(
              () => Text(
                //cartController.cartList[index].quantity.toString(),
                //cartController.to.ca
                //cartController.cartList[index].quantity.toString(),
                productItemCount.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                // borderRadius: BorderRadius.circular(22),
                shape: BoxShape.circle,
                color: Colors.red,
              ),
              child: IconButton(
                iconSize: 30,
                onPressed: () {
                  cartController.quantityDecrement(index);
                  //cartController.cartList[index].quantity--;
                  print('pressed total price');
                  var res = cartController.cartPrice();
                  print('res ' + res.toString());

                  print('decremented');
                },
                icon: const Icon(
                  Icons.remove,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
