import 'package:flutter/material.dart';
import 'package:project/models/viewed_prod_model.dart';
import 'package:uuid/uuid.dart';

class ViewedProdProvider with ChangeNotifier {
  final Map<String, ViewedProdModel> _viewedProdItems = {};
  Map<String, ViewedProdModel> get getviewedProdItems {
    return _viewedProdItems;
  }

  //check if product in cart or  not
  // bool isProductInWishlist({required String productId}) {
  //   return _viewedProdItems.containsKey(productId);
  // }

  //change value of Wishlist to add
  void addProdToHistory({required String productId}) {
    if (_viewedProdItems.containsKey(productId)) {
      _viewedProdItems.remove(productId);
    } else {
      //edit map use productid as key
      _viewedProdItems.putIfAbsent(
        productId, //specific key
        () => ViewedProdModel(
          //increase cartid do generation by uuid
          id: const Uuid().v4(),
          productId: productId,
        ),
      );
    }
    //to change action live
    notifyListeners();
  }

  void removeOneItem({required String productId}) {
    _viewedProdItems.remove(productId);
    notifyListeners();
  }

  // void clearLocalWishlist() {
  //   _viewedProdItems.clear();
  //   notifyListeners();
  // }
}
