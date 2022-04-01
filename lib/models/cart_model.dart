import 'package:get/get.dart';

class CartModel extends GetxController {
  String productId;
  String productName;
  int productPrice;
  String  productUnit;
  String productImage;
  RxInt quantity;
  int cost;
  String orderType;
  CartModel({
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.productUnit,
    required this.productImage,
    required this.quantity,
    required this.cost,
    required this.orderType,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': this.productId,
      'productName': this.productName,
      'productPrice': this.productPrice,
      'productUnit': this.productUnit,
      'productImage': this.productImage,
      'quantity': this.quantity.value,
      'cost': this.cost,
      'orderType': this.orderType,
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      productId: map['productId'] as String,
      productName: map['productName'] as String,
      productPrice: map['productPrice'] as int,
      productUnit: map['productUnit'] as String,
      productImage: map['productImage'] as String,
      quantity: map['quantity'] as RxInt,
      cost: map['cost'] as int,
      orderType: map['orderType'] as String,
    );
  }
}
