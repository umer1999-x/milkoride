import 'package:flutter/material.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:milkoride/screens/admin_screens/edit_product.dart';

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
            return ListView(children: getProductItems(snapshot, context));
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
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Card(
          elevation: 10.0,
          child: ListTile(
            contentPadding: const EdgeInsets.all(8),
            leading: Image.network(
              doc["productPicUrl"],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(doc["productUnit"].toString()),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProduct(
                            doc["productId"].toString(),
                            doc["productName"].toString(),
                            doc["productPrice"],
                            doc["productUnit"].toString(),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit)),
                IconButton(
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('products')
                        .doc(doc['productId'].toString())
                        .delete();
                  },
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
            title: Text(doc["productName"].toString()),
            // onTap: () {
            //   Navigator.push(
            //       context, MaterialPageRoute(builder: (context) =>DataScreen(name: doc["name"])));
            // },
            subtitle: Text(
              doc["productType"].toString(),
            ),
          ),
        ),
      );
    },
  ).toList();
}
