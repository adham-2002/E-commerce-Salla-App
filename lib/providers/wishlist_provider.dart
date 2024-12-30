import 'package:flutter/material.dart';
import 'package:project/models/wishlist_model.dart';
import 'package:uuid/uuid.dart';

class WishlistProvider with ChangeNotifier {
  final Map<String, WishlistModel> _wishlistItem = {};
  Map<String, WishlistModel> get getWishlistItems {
    return _wishlistItem;
  }

  //check if product in cart or  not
  bool isProductInWishlist({required String productId}) {
    return _wishlistItem.containsKey(productId);
  }

  //change value of Wishlist to add
  void addOrRemoveFromWishlist({required String productId}) {
    if (_wishlistItem.containsKey(productId)) {
      _wishlistItem.remove(productId);
    } else {
      //edit map use productid as key
      _wishlistItem.putIfAbsent(
        productId, //specific key
        () => WishlistModel(
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
    _wishlistItem.remove(productId);
    notifyListeners();
  }

  void clearLocalWishlist() {
    _wishlistItem.clear();
    notifyListeners();
  }
}
