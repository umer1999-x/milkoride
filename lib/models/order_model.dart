
class OrderModel {
  late int totalBill;
  late String orderId;
  late DateTime orderDate;
  late bool isDelivered;
  late List orderList = [];

  OrderModel({
    required this.orderId,
    required this.totalBill,
    required this.orderDate,
    required this.isDelivered,
    required this.orderList,
  });

  Map<String, dynamic> toMap() {
    return {
      'totalBill': this.totalBill,
      'orderId': this.orderId,
      'orderDate': this.orderDate,
      'isDelivered': this.isDelivered,
      'orderList': this.orderList,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      totalBill: map['totalBill'] as int,
      orderId: map['orderId'] as String,
      orderDate: map['orderDate'] as DateTime,
      isDelivered: map['isDelivered'] as bool,
      orderList: map['orderList'] as List,
    );
  }



}


