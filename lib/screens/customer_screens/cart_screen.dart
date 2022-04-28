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
        body: SingleChildScrollView(
          physics: ScrollPhysics(),
          padding: EdgeInsets.all(6),
          child: Column(children: [
            Obx(
              () => ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  CartModel product = cartController.cartList[index];
                  return Card(
                    margin: const EdgeInsets.all(6),
                    elevation: 5.0,
                    color: Colors.blue[50],
                    child: CartTile(
                      productImageUrl: product.productImage,
                      productName: product.productName.tr,
                      index: index,
                      productItemCount: product.quantity,
                      productPrice: product.productPrice,
                      productUnit: product.productUnit.tr,
                      orderType: product.orderType,
                    ),
                  );
                },
                itemCount: cartController.cartList.length,
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            Obx(
              () => cartController.isLoading.value
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : AbsorbPointer(
                      absorbing:
                          cartController.TotalBill.isEqual(0) ? true : false,
                      child: TextButton(
                        onPressed: () async {
                          String res;
                          cartController.isLoading.value = true;
                          res = await cartController.placeOrder();
                          print(res.toString());
                          SnackBar(content: Text(res));
                          cartController.isLoading.value = false;
                        },
                        style: TextButton.styleFrom(
                          elevation: 5,
                          primary: Colors.white,
                          backgroundColor: Colors.blue,
                          textStyle: const TextStyle(
                            fontSize: 24,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        child: Text('Order'.tr +
                            cartController.totalCartPrice.string +
                            ' Rs '.tr),
                      ),
                    ),
            ),
          ]),
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
    required this.orderType,
  }) : super(key: key);
  var productImageUrl;
  var productName;
  var productPrice;
  var productUnit;
  var orderType;
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
            flex: 5,
            child: ListTile(
              // title: Text(productName),
              subtitle: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(productName),
                  Text(' Rs '.tr + productPrice.toString()),
                  Text(' Per '.tr + productUnit),
                  Text('OrderType'.tr + orderType),
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 6,
          ),
          Expanded(
            flex: 2,
            child: Container(
              decoration: const BoxDecoration(
                // borderRadius: BorderRadius.circular(22),
                shape: BoxShape.circle,
                color: Colors.blue,
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
            flex: 2,
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
