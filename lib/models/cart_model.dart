import 'package:get/get.dart';

class CartModel extends GetxController {
  var productId;
  var productName;
  int productPrice;
  var productUnit;
  var productImage;
  RxInt quantity;
  int cost ;
  var orderType;
  CartModel({
    this.productId,
    this.productName,
    required this.productPrice,
    this.productUnit,
    this.productImage,
    required this.quantity,
    required this.cost,
    this.orderType,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'productPrice': productPrice,
      'productUnit': productUnit,
      'productImage': productImage,
      'quantity': quantity
    };
  }
}
