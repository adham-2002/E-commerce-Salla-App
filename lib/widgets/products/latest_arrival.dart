import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:project/models/product_model.dart';
import 'package:project/providers/cart_provider.dart';
import 'package:project/providers/product_provider.dart';
import 'package:project/providers/viewed_prod_provider.dart';
import 'package:project/screens/inner_screens/product_details.dart';
import 'package:project/services/my_app_methods.dart';
import 'package:project/widgets/products/heart_btn.dart';
import 'package:project/widgets/subtitle_text.dart';
import 'package:provider/provider.dart';

class LatestArrivalProductWidget extends StatelessWidget {
  const LatestArrivalProductWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final productProvider = Provider.of<ProductProvider>(
      context,
      listen: false,
    );
    final productModelProvider = Provider.of<ProductModel>(context);
    final viewedProvider = Provider.of<ViewedProdProvider>(context);
    // final productId = ModalRoute.of(context)!.settings.arguments as String;
    final cartProvider = Provider.of<CartProvider>(context);
    final getCurrProduct =
        productProvider.findByProdId(productModelProvider.productId);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () async {
          viewedProvider.addProdToHistory(
              productId: productModelProvider.productId);
          await Navigator.pushNamed(
            context,
            productDetails.routName,
            arguments: productModelProvider.productId,
          );
        },
        child: SizedBox(
          width: size.width * 0.45,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: FancyShimmerImage(
                    imageUrl: productModelProvider.productImage,
                    width: size.width * 0.30,
                    height: size.width * 0.30,
                    boxFit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                width: 7,
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productModelProvider.productTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    FittedBox(
                      child: Row(
                        children: [
                          HeartButtonWidget(
                              productId: productModelProvider.productId),
                          IconButton(
                            onPressed: () async {
                              // local
                              // if (cartProvider.isProductInCart(
                              //     productId: getCurrProduct?.productId ?? '')) {
                              //   return;
                              // }
                              // cartProvider.addProductToCart(
                              //     productId: getCurrProduct?.productId ?? '');

                              if (cartProvider.isProductInCart(
                                  productId: productModelProvider.productId)) {
                                return;
                              }
                              // local
                              // cartProvider.addProductToCart(
                              //     productId: getCurrProduct.productId);
                              // firebase
                              try {
                                await cartProvider.addToCartFirebase(
                                    context: context,
                                    productId: productModelProvider.productId,
                                    qty: 1);
                              } catch (e) {
                                // if (!mounted) return;
                                MyAppMethods.showErrorORWarningDialog(
                                  context: context,
                                  subtitle: e.toString(),
                                  fct: () {},
                                );
                              }
                            },
                            icon: Icon(
                              cartProvider.isProductInCart(
                                      productId:
                                          getCurrProduct?.productId ?? '')
                                  ? Icons.check
                                  : Icons.add_shopping_cart_rounded,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    FittedBox(
                      child: SubtitleTextWidget(
                        label: '${productModelProvider.productPrice}\$',
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


// IconButton(
//                             onPressed: () {},
//                             icon: const Icon(
//                               IconlyLight.heart,
//                               size: 18,
//                             ),
//                           ),