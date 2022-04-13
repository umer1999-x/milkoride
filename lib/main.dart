import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:milkoride/controllers/add_product_controller.dart';
import 'package:milkoride/controllers/create_user_controller.dart';
import 'package:milkoride/controllers/edituser_controller.dart';
import 'package:milkoride/controllers/login_controller.dart';
import 'package:milkoride/controllers/sign_up_controller.dart';
import 'package:milkoride/screens/login_signup_screens/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'controllers/admin_controller.dart';
import 'controllers/cart_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(CartController());
  Get.put(LoginController());
  Get.put(SignUpController());
  Get.put(AdminController());
  Get.put(EditController());
  Get.put(CreateUserController());
  Get.put(AddProductController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        fontFamily: GoogleFonts.openSans().fontFamily,
        visualDensity: const VisualDensity(vertical: 1, horizontal: 1),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/login':(context)=> LoginScreen(),
      },
      title: "Milkoride",
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Future<bool> showExitPopup() async {
    //   return await showDialog(
    //         context: context,
    //         builder: (context) => AlertDialog(
    //           title: const Text('Exit App'),
    //           content: const Text('Do you want to exit an App?'),
    //           actions: [
    //             TextButton(
    //               onPressed: () => Navigator.of(context).pop(false),
    //               //return false when click on "NO"
    //               child: const Text('No'),
    //             ),
    //             TextButton(
    //               onPressed: () => Navigator.of(context).pop(true),
    //               //return true when click on "Yes"
    //               child: const Text('Yes'),
    //             ),
    //           ],
    //         ),
    //       ) ??
    //       false; //if showDialouge had returned null, then return false
    // }

    // return WillPopScope(
    //   onWillPop: showExitPopup, //call function on back button press
    //   child:
    // );
    return SafeArea(
      child: Scaffold(
        body: LoginScreen(),
      ),
    );
  }
}
