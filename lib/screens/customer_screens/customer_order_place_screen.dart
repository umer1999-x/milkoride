import 'package:flutter/material.dart';
import 'package:milkoride/screens/customer_screens/product_card_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerPlaceOrder extends StatefulWidget {
  const CustomerPlaceOrder({Key? key}) : super(key: key);

  @override
  State<CustomerPlaceOrder> createState() => _CustomerPlaceOrderState();
}

class _CustomerPlaceOrderState extends State<CustomerPlaceOrder> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Place a order'),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('products').snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.blue,
                    margin: const EdgeInsets.all(6),
                    elevation: 5.0,
                      child: ProductCard(snap: snapshot.data!.docs[index].data()));
                },
                itemCount: snapshot.data!.docs.length,
              ),
            );
          },
        ),
      ),
    );
  }
}
