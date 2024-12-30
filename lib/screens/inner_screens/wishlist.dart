import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:project/providers/wishlist_provider.dart';
import 'package:project/services/assets_manager.dart';
import 'package:project/services/my_app_methods.dart';
import 'package:project/widgets/empty_bag.dart';
import 'package:project/widgets/products/product_widget.dart';
import 'package:project/widgets/title_text.dart';
import 'package:provider/provider.dart';

class WishListScreen extends StatelessWidget {
  static const String routeName = '/wishlistscreen';
  const WishListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wishListprovider = Provider.of<WishlistProvider>(context);
    return wishListprovider.getWishlistItems.isEmpty
        ? Scaffold(
            body: EmptyBagWidget(
              imagePath: AssetsManager.shoppingBasket,
              title: "Your Wishlist is empty",
              subtitle:
                  'Looks like you didn\'t add anything yet to your cart \ngo ahead and start shopping now',
              buttonText: "Shop Now",
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: TitlesTextWidget(
                  label:
                      "Wishlist (${wishListprovider.getWishlistItems.length})"),
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(AssetsManager.shoppingCart),
              ),
              actions: [
                IconButton(
                    onPressed: () {
                          MyAppMethods.showErrorORWarningDialog(isError: false,
                          context: context,
                          subtitle: "remove item",
                          fct: () {
                            wishListprovider.clearLocalWishlist();
                          });
                    },
                    icon: const Icon(
                      Icons.delete_forever_rounded,
                      color: Colors.red,
                    ))
              ],
            ),
            body: DynamicHeightGridView(
              itemCount: wishListprovider.getWishlistItems.length,
              builder: ((context, index) {
                return ProductWidget(
                  //??
                  productId: wishListprovider.getWishlistItems.values
                      .toList()[index]
                      .productId,
                );
              }),
              crossAxisCount: 2,
            ),
          );
  }
}
