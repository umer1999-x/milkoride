import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:milkoride/main.dart';

import '../../widgets/customer_screen_widgets/customer_drawer.dart';

class CustomerScreen extends StatelessWidget {
  const CustomerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: CustomerDrawer(),
        appBar: AppBar(
          title: const Text('Customer Screen'),
          actions: [
            TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.white,
                ),
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => const MyApp()));
                },
                child: const Text(
                  'Sign Out',
                )),
          ],
        ),
        body: Column(
          children:[
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              height: MediaQuery.of(context).size.height/4,
              width: MediaQuery.of(context).size.width,
              child: Text('abc'),
              color: Colors.red,
            )
          ],
        ),
      ),
    );
  }
}
