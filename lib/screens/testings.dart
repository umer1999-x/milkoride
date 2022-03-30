

import 'package:flutter/material.dart';

class DataScreen extends StatefulWidget {
  final String name;
  DataScreen({Key? key, required this.name}) : super(key: key);

  @override
  _DataScreenState createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Text(widget.name,
        style: const TextStyle(
          fontSize: 50,
        ),
      ),
    );
  }
}
