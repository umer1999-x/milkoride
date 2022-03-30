import 'package:flutter/foundation.dart';
import 'package:milkoride/models/cart_model.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  static CartController instance = Get.find();

  List<CartModel> cartList = <CartModel>[].obs;
  var totalCartPrice = 0.obs;

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
      if (kDebugMode) {
        print('product already added');
      }
    } else {
      cartList.add(cartProduct);
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
}
