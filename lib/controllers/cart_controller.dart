import 'package:flutter/foundation.dart';
import 'package:milkoride/models/cart_model.dart';
import 'package:get/get.dart';
import 'package:milkoride/models/order_model.dart';
import 'package:milkoride/services/auth_services.dart';
import 'package:uuid/uuid.dart';

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

  var uuid = const Uuid();
  Future<String> placeOrder() async {
    if (kDebugMode) {
      print('order button pressed');
    }
    String orderID = uuid.v4();
    OrderModel order = OrderModel(
      userId: AuthService.getUid!,
      orderId: orderID,
      totalBill: TotalBill,
      orderDate: DateTime.now(),
      isDelivered: false,
      orderList:getListMap(cartList),
    );
    String res = 'OrderPlaced';
    try {
      if (kDebugMode) {
        print('here');
      }
      await AuthService.firestore
          .collection('orders')
          .doc(AuthService.getUid!)
          .set(order.toMap());
       res='OrderPlaced';
      cartList.clear();
      totalCartPrice.value=0;
    } catch (e) {
     res=e.toString();
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
  items.forEach((element) {
    Items.add(element.toMap());
  });
  return Items;
}
