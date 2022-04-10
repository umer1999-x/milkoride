import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:milkoride/models/cart_model.dart';
import 'package:milkoride/services/auth_services.dart';
import '../../widgets/customer_screen_widgets/customer_drawer.dart';
import "package:cloud_firestore/cloud_firestore.dart";

class CustomerScreen extends StatelessWidget {
  const CustomerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: const CustomerDrawer(),
        appBar: AppBar(
          title: const Text('Customer Screen'),
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
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('orders')
              .doc(AuthService.getUid)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(
                child: Text('snapshot has error'),
              );
            }
            try {
              if (snapshot.data?.data() != null) {
                List<dynamic> data = snapshot.data!['orderList'];
                List<CartModel> orderList =
                    data.map((e) => CartModel.fromMap(e)).toList();
                return SingleChildScrollView(
                  physics: const ScrollPhysics(),
                  child: Column(
                    children: [
                      ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: orderList.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                color: Colors.blue,
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(8),
                                  title: Text(orderList[index].productName),
                                  trailing: Text(orderList[index]
                                      .quantity
                                      .value
                                      .toString()),
                                  leading: Image.network(
                                    orderList[index].productImage.toString(),
                                  ),
                                ),
                              ),
                            );
                          }),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.blue,
                              ),
                              onPressed: null,
                              child: Text(
                                'Total Bill ' +
                                    snapshot.data!['totalBill'].toString() +
                                    ' PKR',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            Expanded(
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                ),
                                onPressed: null,
                                child: snapshot.data!['isDelivered']
                                    ? const Text(
                                        'Delivered',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      )
                                    : const Text('Not Delivered',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
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
    );
  }
}
