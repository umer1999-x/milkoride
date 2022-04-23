import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../screens/customer_screens/cart_screen.dart';
import '../../screens/customer_screens/customer_order_place_screen.dart';
class CustomerDrawer extends StatelessWidget {
  const CustomerDrawer({Key? key}) : super(key: key);

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
                  const Expanded(
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
                      'Customer'.tr,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            title: Text('Place a Order'.tr),
            leading: IconButton(
              icon: const Icon(Icons.category_outlined),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => CustomerPlaceOrder()));
            },
          ),
          // ListTile(
          //   title: const Text("Order History"),
          //   leading: IconButton(
          //     icon: const Icon(Icons.history),
          //     onPressed: () {
          //       Navigator.of(context).pop();
          //     },
          //   ),
          //   onTap: () {
          //     Navigator.of(context).pop();
          //     // Navigator.of(context).push(
          //     //   MaterialPageRoute(
          //     //     builder: (BuildContext context) => const AddProduct(),
          //     //   ),
          //     // );
          //   },
          // ),
          ListTile(
            title: Text('Cart'.tr),
            leading: IconButton(
              icon: const Icon(Icons.shopping_cart_outlined),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => CartScreen(),
                ),
              );
            },
          ),
          // ListTile(
          //   title: const Text("Profile Information"),
          //   leading: IconButton(
          //     icon: const Icon(Icons.account_circle),
          //     onPressed: () {
          //       Navigator.of(context).pop();
          //     },
          //   ),
          //   onTap: () {
          //     Navigator.of(context).pop();
          //     // Navigator.of(context).push(MaterialPageRoute(
          //     //     builder: (BuildContext context) => CreateUser()));
          //   },
          // ),
        ],
      ),
    );
  }
}
