// ignore_for_file: null_check_always_fails

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project/models/cart_model.dart';
import 'package:project/models/product_model.dart';
import 'package:project/providers/product_provider.dart';
import 'package:project/services/my_app_methods.dart';
import 'package:uuid/uuid.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartModel> _cartItems = {};
  Map<String, CartModel> get getCartItems {
    return _cartItems;
  }
  // firebase

  final usersDB = FirebaseFirestore.instance.collection("users");
  final auth = FirebaseAuth.instance;
  Future<void> addToCartFirebase({
    required String productId,
    required int qty,
    required BuildContext context,
  }) async {
    final User? user = auth.currentUser;
    if (user == null) {
      MyAppMethods.showErrorORWarningDialog(
          context: context, fct: () {}, subtitle: 'No user found');
      return;
    }
    final uid = user.uid;
    final cartId = const Uuid().v4();

    try {
      usersDB.doc(uid).update({
        'userCart': FieldValue.arrayUnion([
          {
            "cartId": cartId,
            "productId": productId,
            "quantity": qty,
          }
        ])
      });
      await fetchCart();
      Fluttertoast.showToast(
        msg: 'Item has been added to your cart',
        backgroundColor: Colors.green,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchCart() async {
    User? user = auth.currentUser;
    if (user == null) {
      _cartItems.clear();
      return;
    }
    try {
      final userDoc = await usersDB.doc(user.uid).get();
      final data = userDoc.data();

      if (data == null || !data.containsKey("userCart")) {
        return;
      }

      final length = userDoc.get("userCart").length;
      for (int i = 0; i < length; i++) {
        _cartItems.putIfAbsent(
          userDoc.get('userCart')[i]['productId'],
          () => CartModel(
            cartId: userDoc.get('userCart')[i]['cartId'],
            productId: userDoc.get('userCart')[i]['productId'],
            quantity: userDoc.get('userCart')[i]['quantity'],
          ),
        );
      }
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }

  Future<void> clearCartFromFirebase() async {
    User? user = auth.currentUser;
    try {
      await usersDB.doc(user!.uid).update({
        "userCart": [],
      });
      _cartItems.clear();
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }

  Future<void> removeCartItemFirebase({
    required String cartId,
    required String productId,
    required int qty,
  }) async {
    User? user = auth.currentUser;
    try {
      await usersDB.doc(user!.uid).update({
        "userCart": FieldValue.arrayRemove([
          {
            "cartId": cartId,
            "productId": productId,
            "quantity": qty,
          }
        ]),
      });
      _cartItems.remove(productId);
      await fetchCart();
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }

  // local

  //check if product in cart or  not
  bool isProductInCart({required String productId}) {
    return _cartItems.containsKey(productId);
  }

  //change value of cart to add
  void addProductToCart({required String productId}) {
    //edit map use productid as key
    _cartItems.putIfAbsent(
      productId, //specific key
      () => CartModel(
          //increase cartid do generation by uuid
          cartId: const Uuid().v4(),
          productId: productId,
          //1 cuz user add as 1st if he  wanna change from function in cart model
          quantity: 1),
    );
    //to change action live
    notifyListeners();
  }

  void updateQuantity({required String productId, required int quantity}) {
    _cartItems.update(
      productId, //specific key
      (item) => CartModel(
          //increase cartid do generation by uuid
          cartId: item.cartId, // no need to change and use uuid
          productId: productId,
          //1 cuz user add as 1st if he  wanna change from function in cart model
          quantity: quantity),
    );
    notifyListeners();
  }

  double getTotal({required ProductProvider productProvider}) {
    double total = 0.0;
    _cartItems.forEach((key, value) {
      //to get peice
      final ProductModel? getCurrentProduct =
          productProvider.findByProdId(value.productId);
      if (getCurrentProduct == null) {
        total += 0;
      } else {
        total += double.parse(getCurrentProduct.productPrice) * value.quantity;
      }
    });
    return total;
  }

  void removeOneItem({required String productId}) {
    _cartItems.remove(productId);
    notifyListeners();
  }

  void clearLocalCart() {
    _cartItems.clear();
    notifyListeners();
  }

  int getQty() {
    int total = 0;
    _cartItems.forEach((key, value) {
      total += value.quantity;
    });
    return total;
  }
}
