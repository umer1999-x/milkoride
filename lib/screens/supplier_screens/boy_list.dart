import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeliveryBoyList extends StatefulWidget {
  const DeliveryBoyList({Key? key, required this.docId}) : super(key: key);
  final String docId;
  @override
  _DeliveryBoyListState createState() => _DeliveryBoyListState();
}

class _DeliveryBoyListState extends State<DeliveryBoyList> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            AppBar(
              title: const Text('Select Rider'),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('role', isEqualTo: 'rider')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text("Loading");
                }

                return ListView(
                  shrinkWrap: true,
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    return ListTile(
                      onTap: () async {
                        await FirebaseFirestore.instance
                            .collection('orders')
                            .doc(widget.docId)
                            .update({
                          "deliveryBoy": {
                            "name": data['name'].toString(),
                            'address': data['address'].toString(),
                          }
                        });
                        Navigator.pop(context);
                      },
                      title: Text(data['name']),
                      subtitle: Text(data['role']),
                    );
                  }).toList(),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
