
import 'package:milkoride/models/cart_model.dart';

class OrderModel {
  late String customerName;
  late String userId;
  late int totalBill;
  late String orderId;
  late DateTime orderDate;
  late bool isDelivered;
  late String deliveryAddress;
  List<dynamic>? orderList;
  late Map deliveryBoy;

  OrderModel({
    required this.customerName,
    required this.userId,
    required this.orderId,
    required this.totalBill,
    required this.orderDate,
    required this.isDelivered,
    required this.orderList,
    required this.deliveryAddress,
    required this.deliveryBoy,
  });

  Map<String, dynamic> toMap() {
    return {
      'customerName':customerName,
      'userId':userId,
      'totalBill': totalBill,
      'orderId': orderId,
      'orderDate': orderDate,
      'isDelivered': isDelivered,
      'orderList': orderList,
      'deliveryAddress':deliveryAddress,
      'deliveryBoy':deliveryBoy,
    };
  }

  OrderModel.fromMap(Map<String, dynamic> map) {
    customerName=map['customerName'] as String;
      userId= map['userId']as String;
      totalBill= map['totalBill'] as int;
      orderId=map['orderId'] as String;
      orderDate=map['orderDate'].toDate();
      isDelivered =map['isDelivered'] as bool;
      deliveryAddress=map['deliveryAddress']as String;
      deliveryBoy=map['deliveryBoy'] as Map;
      if(map['orderList']!=null){
        orderList = <CartModel>[];
        (map['orderList'] as List).forEach((element) {
          orderList!.add(CartModel.fromMap(element));
        });
      }

  }



}


