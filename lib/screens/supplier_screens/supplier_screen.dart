import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:milkoride/models/order_model.dart';
import '../../widgets/supplier_screen_widgets/supplier_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import 'boy_list.dart';

class SupplierScreen extends StatefulWidget {
  const SupplierScreen({Key? key}) : super(key: key);

  @override
  _SupplierScreenState createState() => _SupplierScreenState();
}

class _SupplierScreenState extends State<SupplierScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: const SupplierDrawer(),
        appBar: AppBar(
          title: Text('Supplier Screen'.tr),
          actions: [
            IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Get.offAndToNamed('/login');
              },
              icon: Icon(Icons.logout_outlined),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('orders').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('snapshot has error'),
                    );
                  }
                  try {
                    if (snapshot.data!.docs.isNotEmpty) {
                      if (kDebugMode) {
                        print('here in snap2');
                      }
                      List<OrderModel> orderData = snapshot.data!.docs
                          .map((e) => OrderModel.fromMap(
                              e.data() as Map<String, dynamic>))
                          .toList();
                      // if (kDebugMode) {
                      //   print(
                      //       'orderList+++' + orderData[0].orderList![1].productName);
                      // }
                      return ListView.builder(
                        itemCount: orderData.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding:
                                const EdgeInsets.only(right: 10.0, left: 10.0),
                            child: Card(
                              color: Colors.blue[50],
                              elevation: 10.0,
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Column(
                                      children: [
                                        Text('Customer Name'.tr +
                                            orderData[index]
                                                .customerName
                                                .toUpperCase()),
                                        Text(
                                          'Address'.tr +
                                              orderData[index]
                                                  .deliveryAddress
                                                  .toString()
                                                  .toUpperCase(),
                                        ),
                                      ],
                                    ),
                                    trailing: Column(
                                      children: [
                                        Text('Total Bill '.tr +
                                            '${orderData[index].totalBill}' +
                                            ' Rs '.tr),
                                        orderData[index].isDelivered
                                            ? Text('Status'.tr + 'Delivered'.tr)
                                            : Text('Status'.tr +
                                                'Not Deliver Yet'.tr),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: 200,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount:
                                          orderData[index].orderList!.length,
                                      itemBuilder: (context, picindex) {
                                        return Column(
                                          children: [
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 160,
                                                  height: 160,
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      Image.network(
                                                        orderData[index]
                                                            .orderList![
                                                                picindex]
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
                                          padding: const EdgeInsets.only(
                                            bottom: 10.0,
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              SizedBox(
                                                height: 50,
                                                width: 120,
                                                child: ElevatedButton.icon(
                                                  onPressed: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return DeliveryBoyList(
                                                            docId:
                                                                orderData[index]
                                                                    .docId
                                                                    .toString(),
                                                          );
                                                        });
                                                  },
                                                  icon: const Icon(Icons
                                                      .delivery_dining_outlined),
                                                  label:
                                                      Text('Assign Rider'.tr),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 120,
                                                height: 50,
                                                child: ElevatedButton.icon(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    //onPrimary: Colors.red,
                                                    primary: Colors.red,
                                                    //padding: EdgeInsets.all(10),
                                                  ),
                                                  onPressed: () async {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('orders')
                                                        .doc(orderData[index]
                                                            .docId
                                                            .toString())
                                                        .delete();
                                                    Get.snackbar(
                                                      'Cancel Order'.tr,
                                                      'Your Order Has Been Canceled',
                                                      backgroundColor:
                                                          Colors.white,
                                                    );
                                                  },
                                                  icon: const Icon(
                                                      Icons.cancel_outlined),
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
                                          icon: const Icon(
                                              Icons.bike_scooter_sharp),
                                          label: Text('Rider Assigned'.tr)),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                    // if (snapshot.data!.docs.isNotEmpty) {
                    //   List<OrderModel> order = snapshot.data!.docs
                    //       .map((e) => OrderModel.fromMap(
                    //           e.data() as Map<String, dynamic>))
                    //       .toList();
                    //   return Expanded(
                    //     child: ListView.builder(
                    //       //shrinkWrap: true,
                    //       itemCount: order.length,
                    //       itemBuilder: (context, index) {
                    //         if (kDebugMode) {
                    //           print(order.length.toString());
                    //         }
                    //         return Card(
                    //           elevation: 10.0,
                    //           color: Colors.blue[50],
                    //           child: Column(
                    //             mainAxisSize: MainAxisSize.max,
                    //             mainAxisAlignment: MainAxisAlignment.start,
                    //             crossAxisAlignment: CrossAxisAlignment.start,
                    //             children: [
                    //               ListTile(
                    //                 title: Text(
                    //                   'Customer Name'.tr +
                    //                       order[index]
                    //                           .customerName
                    //                           .toString()
                    //                           .toUpperCase(),
                    //                 ),
                    //                 subtitle: Column(
                    //                   children: [
                    //                     Row(
                    //                       children: [
                    //                         order[index].isDelivered
                    //                             ? Text('Status'.tr +
                    //                                 'Delivered'.tr)
                    //                             : Text('Status'.tr +
                    //                                 'Not Deliver Yet'.tr),
                    //                       ],
                    //                     ),
                    //                     Row(
                    //                       children: [
                    //                         Expanded(
                    //                           child: Text(
                    //                             'Address'.tr +
                    //                                 order[index]
                    //                                     .deliveryAddress
                    //                                     .toString()
                    //                                     .toUpperCase(),
                    //                           ),
                    //                         ),
                    //                       ],
                    //                     ),
                    //                   ],
                    //                 ),
                    //                 trailing: Text('Total Bill'.tr +
                    //                     order[index].totalBill.toString()),
                    //               ),
                    //               SizedBox(
                    //                 height:
                    //                     MediaQuery.of(context).size.height * .3,
                    //                 width:
                    //                     MediaQuery.of(context).size.width * 1,
                    //                 child: ListView.builder(
                    //                   scrollDirection: Axis.horizontal,
                    //                   itemCount: order[index].orderList!.length,
                    //                   itemBuilder: (context, position) {
                    //                     return Padding(
                    //                       padding: const EdgeInsets.all(8.0),
                    //                       child: Column(
                    //                         children: [
                    //                           Row(
                    //                             children: [
                    //                               Text(
                    //                                 order[index]
                    //                                     .orderList![position]
                    //                                     .productName
                    //                                     .toString()
                    //                                     .tr
                    //                                     .toUpperCase(),
                    //                               ),
                    //                               Text(
                    //                                 '  x' +
                    //                                     order[index]
                    //                                         .orderList![
                    //                                             position]
                    //                                         .quantity
                    //                                         .toString(),
                    //                               ),
                    //                             ],
                    //                           ),
                    //                           Expanded(
                    //                             child: Container(
                    //                               height: MediaQuery.of(context)
                    //                                       .size
                    //                                       .height *
                    //                                   .25,
                    //                               width: MediaQuery.of(context)
                    //                                       .size
                    //                                       .width *
                    //                                   .5,
                    //                               decoration: BoxDecoration(
                    //                                 borderRadius:
                    //                                     BorderRadius.circular(
                    //                                         10),
                    //                                 image: DecorationImage(
                    //                                   fit: BoxFit.cover,
                    //                                   image: NetworkImage(
                    //                                     order[index]
                    //                                         .orderList![
                    //                                             position]
                    //                                         .productImage
                    //                                         .toString(),
                    //                                   ),
                    //                                 ),
                    //                               ),
                    //                             ),
                    //                           ),
                    //                         ],
                    //                       ),
                    //                     );
                    //                   },
                    //                 ),
                    //               ),
                    //               order[index]
                    //                       .deliveryBoy['name']
                    //                       .toString()
                    //                       .isEmpty
                    //                   ? Row(
                    //                       mainAxisSize: MainAxisSize.max,
                    //                       mainAxisAlignment:
                    //                           MainAxisAlignment.spaceAround,
                    //                       children: [
                    //                         ElevatedButton.icon(
                    //                           onPressed: () async {
                    //                             showDialog(
                    //                                 context: context,
                    //                                 builder:
                    //                                     (BuildContext context) {
                    //                                   return DeliveryBoyList(
                    //                                     docId: order[index]
                    //                                         .userId
                    //                                         .toString(),
                    //                                   );
                    //                                 });
                    //                           },
                    //                           icon: const Icon(
                    //                               Icons.copy_outlined),
                    //                           label: Expanded(
                    //                               child:
                    //                                   Text('Assign Rider'.tr)),
                    //                         ),
                    //                         const SizedBox(
                    //                           width: 5.0,
                    //                         ),
                    //                         ElevatedButton.icon(
                    //                           style: ElevatedButton.styleFrom(
                    //                             primary: Colors.red,
                    //                           ),
                    //                           onPressed: () async {
                    //                             await FirebaseFirestore.instance
                    //                                 .collection('orders')
                    //                                 .doc(order[index]
                    //                                     .userId
                    //                                     .toString())
                    //                                 .delete();
                    //                           },
                    //                           icon: const Icon(
                    //                               Icons.cancel_rounded),
                    //                           label: Text('Cancel Order'.tr),
                    //                         ),
                    //                       ],
                    //                     )
                    //                   : Center(
                    //                       child: ElevatedButton.icon(
                    //                         style: ElevatedButton.styleFrom(
                    //                           primary: Colors.green,
                    //                         ),
                    //                         onPressed: () {},
                    //                         icon: const Icon(
                    //                             Icons.done_outline_rounded),
                    //                         label: Text('Rider Assigned'.tr),
                    //                       ),
                    //                     ),
                    //             ],
                    //           ),
                    //         );
                    //       },
                    //     ),
                    //   );
                    // }
                    else {
                      return Center(
                        child: Text('No Order Exist'.tr),
                      );
                    }
                  } catch (e) {
                    return Text(e.toString());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
