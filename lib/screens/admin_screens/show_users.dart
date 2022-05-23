import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'edit_user_data.dart';

class ShowUsers extends StatefulWidget {
  const ShowUsers({Key? key}) : super(key: key);

  @override
  _ShowUsersState createState() => _ShowUsersState();
}

class _ShowUsersState extends State<ShowUsers> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Users List'.tr),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .where('role', isNotEqualTo: 'admin')
              .snapshots(),
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
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(doc['role'.tr]),
                IconButton(
                    onPressed: () {
                      Get.to(() => EditUser(), arguments: [
                        doc['uid'],
                        doc['email'],
                        doc['role'],
                        doc['name'],
                        doc['address'],
                      ]);
                    },
                    icon: const Icon(Icons.edit)),
                IconButton(
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(doc['uid'].toString())
                        .delete();
                  },
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
            title: Text(doc['name'.tr]),
            // onTap: () {
            //   Navigator.push(
            //       context, MaterialPageRoute(builder: (context) =>DataScreen(name: doc["name"])));
            // },
            subtitle: Text(
              doc["email"].toString(),
            ),
          ),
        ),
      );
    },
  ).toList();
}
