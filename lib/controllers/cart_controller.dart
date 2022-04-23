import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:milkoride/models/cart_model.dart';
import 'package:get/get.dart';
import 'package:milkoride/models/order_model.dart';
import 'package:milkoride/screens/customer_screens/customer_home_screen.dart';
import 'package:milkoride/services/auth_services.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartController extends GetxController {
  static CartController instance = Get.find();

  List<CartModel> cartList = <CartModel>[].obs;
  var totalCartPrice = 0.obs;
  RxBool isLoading = false.obs;

  int get TotalBill => totalCartPrice.value;

  int cartPrice() {
    if (cartList.isNotEmpty) {
      totalCartPrice.value = cartList
          .map((e) => e.quantity.value * e.productPrice)
          .reduce((value, element) => value + element);
      return totalCartPrice.value;
    } else {
      return 0;
    }
  }

  addToCart(CartModel cartProduct) {
    if (cartList
        .where((element) => element.productId == cartProduct.productId)
        .isNotEmpty) {
      Get.snackbar(
        'product already added to cart',
        cartProduct.productName.toString(),
        icon: const Icon(Icons.shopping_cart),
        backgroundColor: Colors.white70,
        barBlur: 0.0,
      );
      if (kDebugMode) {
        print('product already added');
      }
    } else {
      cartList.add(cartProduct);
      Get.snackbar(
        'product added to cart',
        cartProduct.productName.toString(),
        icon: const Icon(Icons.shopping_cart),
        backgroundColor: Colors.white70,
        barBlur: 0.0,
      );
      if (kDebugMode) {
        print('product added');
      }
    }
  }

  quantityIncrement(int index) {
    cartList[index].quantity.value++;

    if (kDebugMode) {
      print('cart quantity: ' + cartList[index].quantity.value.toString());
    }
    if (kDebugMode) {
      print('Cost: ' + cartList[index].cost.toString());
    }
  }

  quantityDecrement(int index) {
    if (cartList[index].quantity.value == 1) {
      cartList.removeAt(index);
      totalCartPrice.value = 0;
    } else {
      cartList[index].quantity.value--;
      if (kDebugMode) {
        print('cart quantity: ' + cartList[index].quantity.value.toString());
      }
      if (kDebugMode) {
        print('Cost: ' + cartList[index].cost.toString());
      }
    }
  }

  Map deliveryBoy = {
    'name': '',
    'address': '',
  };
  var uuid = const Uuid();
  Future<String> placeOrder() async {
    if (kDebugMode) {
      print('order button pressed');
    }
    String orderID = uuid.v4();
    OrderModel order = OrderModel(
        customerName: await FirebaseFirestore.instance
            .collection('users')
            .doc(AuthService.getUid!)
            .get()
            .then((value) => value['name'].toString()),
        userId: AuthService.getUid!,
        orderId: orderID,
        totalBill: TotalBill,
        orderDate: DateTime.now(),
        isDelivered: false,
        deliveryAddress: await FirebaseFirestore.instance
            .collection('users')
            .doc(AuthService.getUid!)
            .get()
            .then((value) => value['address'].toString()),
        orderList: getListMap(cartList),
        deliveryBoy: deliveryBoy);
    String res = 'OrderPlaced';
    try {
      if (kDebugMode) {
        print('here');
      }
      //print(int.parse(AuthService.firestore.collection('orders').doc(AuthService.getUid!).snapshots().length.toString()));
      List<dynamic> res1 = await AuthService.firestore
          .collection('orders')
          .doc(AuthService.getUid)
          .get()
          .then((value) => value.data()?['orderList']);
      if (kDebugMode) {
        print('RES: ' + res1.toString());
      }
      if (res1.isEmpty) {
        await AuthService.firestore
            .collection('orders')
            .doc(AuthService.getUid!)
            .set(order.toMap());
      } else {
        await AuthService.firestore
            .collection('orders')
            .doc(AuthService.getUid!)
            .update({
          'totalBill': FieldValue.increment(totalCartPrice.value),
          'orderList': FieldValue.arrayUnion(getListMap(cartList)),
          'orderDate': DateTime.now()
          //order.toMap()
        });
      }
      res = 'OrderPlaced';
      cartList.clear();
      totalCartPrice.value = 0;
      Get.offAll(() => const CustomerScreen());
    } catch (e) {
      res = e.toString();
    }
    return res;
    //cartController.isLoading.value=true;
  }
}

dynamic getListMap(List<dynamic> items) {
  if (items == null) {
    return null;
  }
  List<Map<String, dynamic>> Items = [];
  // List<CartModel> Items = [];
  items.forEach((element) {
    Items.add(element.toMap());
  });
  return Items;
}
