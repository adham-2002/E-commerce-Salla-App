import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:project/models/cart_model.dart';
import 'package:project/providers/cart_provider.dart';
import 'package:project/screens/cart/quantity_btm_sheet.dart';
import 'package:project/widgets/products/heart_btn.dart';
import 'package:project/widgets/title_text.dart';
import 'package:provider/provider.dart';
import 'package:project/providers/product_provider.dart';
import '../../widgets/subtitle_text.dart';

class CartWidget extends StatelessWidget {
  const CartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cartModelProvider = Provider.of<CartModel>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final getCurrProduct =
        productProvider.findByProdId(cartModelProvider.productId);
    Size size = MediaQuery.of(context).size;
    final cartProvider = Provider.of<CartProvider>(context);

    return getCurrProduct == null
        ? const SizedBox.shrink()
        : FittedBox(
            child: IntrinsicWidth(
                child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: FancyShimmerImage(
                  imageUrl: getCurrProduct.productImage,
                  height: size.height * 0.2,
                  width: size.height * 0.2,
                ),
              ),
              const SizedBox(
                width: 10.0,
              ),
              IntrinsicWidth(
                  child: Column(children: [
                Row(
                  children: [
                    SizedBox(
                        width: size.width * 0.6,
                        child: TitlesTextWidget(
                          label: getCurrProduct.productTitle,
                          maxLines: 2,
                        )),
                    Column(children: [
                      IconButton(
                          onPressed: () async {
                            await cartProvider.removeCartItemFirebase(
                              cartId: cartModelProvider.cartId,
                              productId: cartModelProvider.productId,
                              qty: cartModelProvider.quantity,
                            );
                            // local
                            // cartProvider.removeOneItem(
                            //   productId: getCurrProduct.productId,
                            // );
                          },
                          icon: const Icon(
                            Icons.clear,
                            color: Colors.red,
                          )),
                      HeartButtonWidget(
                        productId: getCurrProduct.productId,
                      ),
                    ])
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SubtitleTextWidget(
                      label: "${getCurrProduct.productPrice}\$",
                      fontSize: 20,
                      color: Colors.blue,
                    ),
                    OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            width: 1,
                            color: Colors.blue,
                          ),
                        ),
                        onPressed: () async {
                          await showModalBottomSheet(
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16.0),
                                  topRight: Radius.circular(16.0),
                                ),
                              ),
                              context: context,
                              builder: (context) {
                                return QuantityBottomSheetWidget(
                                  cartModel: cartModelProvider,
                                );
                              });
                        },
                        icon: const Icon(IconlyLight.arrowDown),
                        label: Text("Qty:${cartModelProvider.quantity}")),
                  ],
                )
              ]))
            ]),
          )));
  }
}
