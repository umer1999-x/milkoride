import 'package:flutter/material.dart';
import 'package:milkoride/screens/admin_screens/create_user_screen.dart';
import 'package:milkoride/screens/admin_screens/add_product.dart';
import 'package:milkoride/screens/admin_screens/show_products.dart';
import 'package:milkoride/screens/admin_screens/show_users.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({Key? key}) : super(key: key);

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
                children: const [
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
                      "Admin",
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
          ListTile(
            title: const Text("Create a User"),
            leading: IconButton(
              icon: const Icon(Icons.account_circle),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => CreateUser()));
            },
          ),
          ListTile(
            title: const Text("Add Product"),
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
          ListTile(
            title: const Text("Show All Product"),
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
          ListTile(
            title: const Text("Show All Users"),
            leading: IconButton(
              icon: const Icon(Icons.people),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => const ShowUsers(),
                ),
              );
            },
          ),
          const Divider(
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}
