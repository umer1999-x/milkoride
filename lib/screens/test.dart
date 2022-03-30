import 'package:flutter/material.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:milkoride/screens/testings.dart';

class ExpenseList extends StatelessWidget {
  const ExpenseList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(children: getExpenseItems(snapshot,context));
        });
  }
}

getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot,BuildContext context) {
  return snapshot.data?.docs
      .map((doc) => ListTile(
          title: Text(doc["name"]),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) =>DataScreen(name: doc["name"])));
          },
          subtitle: Text(doc["email"].toString())))
      .toList();
}
