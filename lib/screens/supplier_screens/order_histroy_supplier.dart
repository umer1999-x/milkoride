import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:milkoride/services/auth_services.dart';

import '../../models/order_model.dart';

class OrderHistroySupplier extends StatefulWidget {
  const OrderHistroySupplier({Key? key}) : super(key: key);

  @override
  State<OrderHistroySupplier> createState() => _OrderHistroySupplierState();
}

class _OrderHistroySupplierState extends State<OrderHistroySupplier> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order History'.tr),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('isDelivered', isEqualTo: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('snapshot has error'),
            );
          }
          try {
            if (kDebugMode) {
              print('here in snap');
              print(snapshot.data!.docs.toString());
            }
            if (snapshot.data!.docs.isNotEmpty) {
              if (kDebugMode) {
                print('here in snap2');
              }
              List<OrderModel> orderData = snapshot.data!.docs
                  .map((e) =>
                      OrderModel.fromMap(e.data() as Map<String, dynamic>))
                  .toList();
              // if (kDebugMode) {
              //   print(
              //       'orderList+++' + orderData[0].orderList![1].productName);
              // }
              return ListView.builder(
                itemCount: orderData.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 10.0, left: 10.0),
                    child: Card(
                      color: Colors.blue[50],
                      elevation: 10.0,
                      child: Column(
                        children: [
                          ListTile(
                            title: Text('Customer Name'.tr +
                                orderData[index].customerName.toUpperCase()),
                            trailing: Column(
                              children: [
                                Text('Total Bill '.tr +
                                    '${orderData[index].totalBill}' +
                                    ' Rs '.tr),
                                orderData[index].isDelivered
                                    ? Text('Status'.tr + 'Delivered'.tr)
                                    : Text('Status'.tr + 'Not Deliver Yet'.tr),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 200,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: orderData[index].orderList!.length,
                              itemBuilder: (context, picindex) {
                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 160,
                                          height: 160,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Image.network(
                                                orderData[index]
                                                    .orderList![picindex]
                                                    .productImage,
                                                fit: BoxFit.cover,
                                                width: 110,
                                                height: 110,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      orderData[index]
                                              .orderList![picindex]
                                              .productName
                                              .toString()
                                              .tr +
                                          '  x' +
                                          orderData[index]
                                              .orderList![picindex]
                                              .quantity
                                              .toString(),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          orderData[index]
                                  .deliveryBoy['name']
                                  .toString()
                                  .isEmpty
                              ? Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      SizedBox(
                                        width: 120,
                                        height: 50,
                                        child: ElevatedButton.icon(
                                          onPressed: () {},
                                          icon: const Icon(
                                              Icons.delivery_dining_outlined),
                                          label: orderData[index]
                                                      .isDelivered
                                                      .toString() ==
                                                  'false'
                                              ? Text('Not Deliver Yet'.tr)
                                              : Text('Delivered'.tr),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 120,
                                        height: 50,
                                        child: ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                            //onPrimary: Colors.red,
                                            primary: Colors.red,
                                          ),
                                          onPressed: () async {
                                            await FirebaseFirestore.instance
                                                .collection('orders')
                                                .doc(orderData[index]
                                                    .docId
                                                    .toString())
                                                .delete();
                                            Get.snackbar(
                                              'Cancel Order'.tr,
                                              'Your Order Has Been Canceled',
                                              backgroundColor: Colors.white,
                                            );
                                          },
                                          icon:
                                              const Icon(Icons.cancel_outlined),
                                          label: Text(
                                            'Cancel Order'.tr,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    //onPrimary: Colors.red,
                                    primary: Colors.green,
                                  ),
                                  onPressed: () {
                                    Get.snackbar('Rider Assigned'.tr,
                                        'Your Order On The Way'.tr,
                                        backgroundColor: Colors.white);
                                  },
                                  icon: const Icon(Icons.bike_scooter_sharp),
                                  label: Text('Rider Assigned'.tr)),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Text('No Order Exist'.tr),
              );
            }
          } catch (e) {
            return Text(e.toString());
          }
        },
      ),
    );
  }
}
