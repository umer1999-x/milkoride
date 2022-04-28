import 'package:flutter/material.dart';
import 'package:milkoride/screens/admin_screens/add_product.dart';
import 'package:milkoride/screens/admin_screens/create_user_screen.dart';
import 'package:milkoride/screens/customer_screens/order_histroy.dart';
import '../../screens/admin_screens/show_products.dart';
import 'package:get/get.dart';

class SupplierDrawer extends StatelessWidget {
  const SupplierDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: Center(
              child: Row(
                children: [
                  Expanded(
                    child: Icon(
                      Icons.account_circle,
                      color: Colors.white,
                      size: 40,
                    ),
                    flex: 2,
                  ),
                  Expanded(
                    flex: 6,
                    child: Text(
                      'Supplier'.tr,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // ListTile(
          //   title: const Text("Create a User"),
          //   leading: IconButton(
          //     icon: const Icon(Icons.account_circle),
          //     onPressed: () {
          //       Navigator.of(context).pop();
          //     },
          //   ),
          //   onTap: () {
          //     Navigator.of(context).pop();
          //     Navigator.of(context).push(MaterialPageRoute(
          //         builder: (BuildContext context) => CreateUser()));
          //   },
          // ),
          // const Divider(
          //   color: Colors.grey,
          // ),
          ListTile(
            title: Text('Add Product'.tr),
            leading: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => const AddProduct(),
                ),
              );
            },
          ),
          const Divider(
            color: Colors.grey,
          ),
          ListTile(
            title: Text('Show All Product'.tr),
            leading: IconButton(
              icon: const Icon(Icons.category),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => const ShowProduct(),
                ),
              );
            },
          ),
          const Divider(
            color: Colors.grey,
          ),
          ListTile(
            title: Text('Add New Rider'.tr),
            leading: IconButton(
              icon: const Icon(Icons.create),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => CreateUser(),
                ),
              );
            },
          ),
           
        ],
      ),
    );
  }
}
