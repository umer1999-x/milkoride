import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:milkoride/models/order_model.dart';
import 'package:milkoride/models/rider_model.dart';
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
          title: const Text('Supplier Screen'),
          actions: [
            TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.white,
                ),
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Get.offAndToNamed('/login');
                },
                child: const Text(
                  'Sign Out',
                )),
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
                      List<OrderModel> order = snapshot.data!.docs
                          .map((e) => OrderModel.fromMap(
                              e.data() as Map<String, dynamic>))
                          .toList();
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: order.length,
                          itemBuilder: (context, index) {
                            if (kDebugMode) {
                              print(order.length.toString());
                            }
                            return Card(
                              elevation: 10.0,
                              color: Colors.white70,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                    title: Text(order[index].userId.toString()),
                                    subtitle: Text(
                                        order[index].isDelivered.toString()),
                                  ),
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height * .3,
                                    width:
                                        MediaQuery.of(context).size.width * 1,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: order[index].orderList!.length,
                                      itemBuilder: (context, position) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .25,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .5,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(order[index]
                                                    .orderList![position]
                                                    .productImage
                                                    .toString()),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  order[index]
                                          .deliveryBoy['name']
                                          .toString()
                                          .isEmpty
                                      ? Row(
                                          children: [
                                            Expanded(
                                              child: ElevatedButton.icon(
                                                onPressed: () async {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return DeliveryBoyList(
                                                          docId: order[index]
                                                              .userId
                                                              .toString(),
                                                        );
                                                      });
                                                  // Get.to(()=>const DeliveryBoyList());
                                                  // Navigator.push(context, MaterialPageRoute(builder: builder));
                                                  // await FirebaseFirestore.instance
                                                  //     .collection('users')
                                                  //     .where('role',
                                                  //         isEqualTo: 'user')
                                                  //     .snapshots()
                                                  //     .listen((event) {
                                                  //       event.docs.map((e) {
                                                  //        RiderModel rider = RiderModel.fromMap(e.data());
                                                  //       }).toList();
                                                  // },
                                                  // );
                                                },
                                                icon: const Icon(
                                                    Icons.copy_outlined),
                                                label:
                                                    const Text('Assign Rider'),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5.0,
                                            ),
                                            Expanded(
                                              child: ElevatedButton.icon(
                                                onPressed: () async {
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('orders')
                                                      .doc(order[index]
                                                          .userId
                                                          .toString())
                                                      .delete();
                                                },
                                                icon: const Icon(
                                                    Icons.cancel_outlined),
                                                label:
                                                    const Text('Cancel Order'),
                                              ),
                                            ),
                                          ],
                                        )
                                      : Center(
                                          child: ElevatedButton.icon(
                                             style: ButtonStyle(
                                               backgroundColor: MaterialStateProperty.all(Colors.lightBlue),
                                             ),
                                              onPressed: null,
                                              icon:
                                                  const Icon(Icons.done_outline_rounded),
                                              label: const Text("Rider Assigned")),
                                        ),
                                ],
                              ),
                            );
                          });
                    } else {
                      return const Center(
                        child: Text('No Order Exist'),
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
