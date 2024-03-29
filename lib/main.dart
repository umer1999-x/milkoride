// ignore_for_file: non_constant_identifier_names

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:milkoride/controllers/add_product_controller.dart';
import 'package:milkoride/controllers/create_user_controller.dart';
import 'package:milkoride/controllers/edit_product_controller.dart';
import 'package:milkoride/controllers/edituser_controller.dart';
import 'package:milkoride/controllers/login_controller.dart';
import 'package:milkoride/controllers/sign_up_controller.dart';
import 'package:milkoride/screens/login_signup_screens/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:milkoride/translation.dart';
import 'controllers/admin_controller.dart';
import 'controllers/cart_controller.dart';
// import 'package:dcdg/dcdg.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: WidgetsBinding.instance);
  await Firebase.initializeApp();
  Get.put(CartController());
  Get.put(LoginController());
  Get.put(SignUpController());
  Get.put(AdminController());
  Get.put(EditController());
  Get.put(CreateUserController());
  Get.put(AddProductController());
  Get.put(EditProductController());

  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
 const MyApp({Key? key}) : super(key: key);
  @override

  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return GetMaterialApp(
      translations: LocaleString(),
      locale: const Locale('en', 'US'),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: GoogleFonts.openSans().fontFamily,
        visualDensity: const VisualDensity(vertical: 1, horizontal: 1),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/login': (context) => LoginScreen(),
      },
      title: "Milkoride",
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

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
