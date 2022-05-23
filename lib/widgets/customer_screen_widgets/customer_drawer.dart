// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milkoride/screens/customer_screens/order_histroy.dart';
import '../../screens/customer_screens/cart_screen.dart';
import '../../screens/customer_screens/customer_order_place_screen.dart';

class CustomerDrawer extends StatelessWidget {
  CustomerDrawer({Key? key}) : super(key: key);
  var locale = Get.locale;
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
                  builder: (BuildContext context) =>
                      const CustomerPlaceOrder()));
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
                  builder: (BuildContext context) => const CartScreen(),
                ),
              );
            },
          ),

          ListTile(
            title: Text('Order History'.tr),
            leading: IconButton(
              icon: const Icon(Icons.history_outlined),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => const OrderHistroy(),
                ),
              );
            },
          ),

          ListTile(
            title: Text('Language change'.tr),
            leading: IconButton(
              icon: const Icon(Icons.translate),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            onTap: () {
              Navigator.of(context).pop();
              if (locale.toString() == 'Ur_Pak') {
                locale = const Locale('en', 'US');
                Get.updateLocale(locale!);
              } else if (locale.toString() == 'en_US') {
                locale = const Locale('Ur', 'Pak');
                Get.updateLocale(locale!);
              }
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (BuildContext context) => const OrderHistroy(),
              //   ),
              // );
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
