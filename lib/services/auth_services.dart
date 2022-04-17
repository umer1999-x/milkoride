
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:milkoride/models/add_product_model.dart';
import 'package:milkoride/services/storages_methods.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth;
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static String? get getUid => FirebaseAuth.instance.currentUser?.uid.toString();
  //static String? get getAddress => FirebaseAuth.instance.currentUser?.toString();

  AuthService(this._auth);

  Stream<User?> get authStateChanges => _auth.idTokenChanges();

  Future<String> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return "Logged In";
    } catch (e) {
      return e.toString() + "errorrrrrrrrrrr";
    }
  }

  Future<String> signUp(
      String name, String email, String password, String role,String address) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        User? user = FirebaseAuth.instance.currentUser;

        await FirebaseFirestore.instance
            .collection("users")
            .doc(user!.uid)
            .set({
          'name': name,
          'uid': user.uid,
          'email': email,
          'password': password,
          'role': role,
          'address':address
        });
      });
      return "Signed Up";
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> deleteUser(String uid) async {
    try {
      await FirebaseFirestore.instance.collection("users").doc(uid).delete();
      if (kDebugMode) {
        print('in delete func');
      }
      return "successfully deleted";
    } catch (e) {
      return '$e.toString()';
    }
  }

  static Future<String> updateUser(String name, String newRole, String email ,String uid,String address) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({
        'name': name,
        'role': newRole,
        'email': email,
        'address':address
        //'password': newPassword,
      });
      Get.defaultDialog(
        title: 'Alert',
        content: const Text('Updated'),
      );
      return 'successfully updated';
    } catch (e) {
      return '$e.toString()';
    }
  }

  Future<String> uploadProduct(
    Uint8List file,
    String uid,
    String productName,
    String unit,
    String prodType,
    int price,
  ) async {
    // asking uid here because we don't want to make extra calls to firebase auth when we can just get from our state management
    String res = "Some error occurred";
    try {
      String photoUrl = await StorageMethods().uploadImageToStorage(
        'products',
        file,
      );
      String prodId = const Uuid().v1(); // creates unique id based on time
      AddProduct addProduct = AddProduct(
        productId: prodId,
        productAdderUid: uid,
        productName: productName,
        productPrice: price,
        productType: prodType,
        productUnit: unit,
        productPicUrl: photoUrl,
      );
      await firestore
          .collection('products')
          .doc(prodId)
          .set(addProduct.toMap());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
