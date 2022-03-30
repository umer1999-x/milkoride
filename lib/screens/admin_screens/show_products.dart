import 'package:flutter/material.dart';
import "package:cloud_firestore/cloud_firestore.dart";

class ShowProduct extends StatefulWidget {
  const ShowProduct({Key? key}) : super(key: key);

  @override
  _ShowProductState createState() => _ShowProductState();
}

class _ShowProductState extends State<ShowProduct> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xAF6394AB),
        appBar: AppBar(
          title: const Text("Products List"),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('products').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView(
                 children: getProductItems(snapshot, context));
          },
        ),
      ),
    );
  }
}

getProductItems(AsyncSnapshot<QuerySnapshot> snapshot, BuildContext context) {
  return snapshot.data?.docs.map(
    (doc) {
      return Container(
        padding:const EdgeInsets.all(8) ,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.blueGrey,
        ),
        child: ListTile(
          leading: Image.network(
            doc["productPicUrl"],
          ),
          trailing: Text(doc["productUnit"].toString()),
          title: Text(doc["productName"].toString()),
          // onTap: () {
          //   Navigator.push(
          //       context, MaterialPageRoute(builder: (context) =>DataScreen(name: doc["name"])));
          // },
          subtitle: Text(
            doc["productType"].toString(),
          ),
        ),
      );
    },
  ).toList();
}
