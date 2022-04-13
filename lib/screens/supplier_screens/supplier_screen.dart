import 'package:flutter/material.dart';

import '../../widgets/supplier_screen_widgets/supplier_drawer.dart';

class SupplierScreen extends StatefulWidget {
  const SupplierScreen({Key? key}) : super(key: key);

  @override
  _SupplierScreenState createState() => _SupplierScreenState();
}

class _SupplierScreenState extends State<SupplierScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      drawer: const SupplierDrawer(),
      appBar: AppBar(title: const Text('Supplier Screen'),),
      body: const Center(
        child: Text('Supplier Screen'),
      ),
    ));
  }
}
