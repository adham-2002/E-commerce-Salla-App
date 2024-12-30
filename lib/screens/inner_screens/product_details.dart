import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:project/providers/cart_provider.dart';
import 'package:project/providers/product_provider.dart';
import 'package:project/services/my_app_methods.dart';
import 'package:project/widgets/app_name_text.dart';
import 'package:project/widgets/products/heart_btn.dart';
import 'package:project/widgets/subtitle_text.dart';
import 'package:project/widgets/title_text.dart';
import 'package:provider/provider.dart';

class productDetails extends StatefulWidget {
  static const routName = '/ProductDetails';
  const productDetails({super.key});

  @override
  State<productDetails> createState() => _productDetailsState();
}

class _productDetailsState extends State<productDetails> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final productProvider = Provider.of<ProductProvider>(
      context,
      listen: false,
    );
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final getCurrProduct = productProvider.findByProdId(productId);
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: const AppNameTextWidget(
            fontSize: 25,
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.canPop(context) ? Navigator.pop(context) : null;
            },
            icon: const Icon(Icons.arrow_back_ios, size: 18),
          ),
        ),
        body: getCurrProduct == null
            ? const SizedBox.shrink()
            : SingleChildScrollView(
                child: Column(
                children: [
                  FancyShimmerImage(
                    imageUrl: getCurrProduct.productImage,
                    height: size.height * 0.38,
                    width: double.infinity,
                    boxFit: BoxFit.contain,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                getCurrProduct.productTitle,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 18,
                            ),
                            SubtitleTextWidget(
                              label: "${getCurrProduct.productPrice}\$",
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              HeartButtonWidget(
                                productId: getCurrProduct.productId,
                                color: Theme.of(context).secondaryHeaderColor,
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: SizedBox(
                                  height: kBottomNavigationBarHeight - 10,
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      side: BorderSide(
                                        color: Colors.purple,
                                        width: 2,
                                      ),
                                      backgroundColor: Theme.of(context)
                                          .secondaryHeaderColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular((30)),
                                      ),
                                    ),
                                    onPressed: () async {
                                      if (cartProvider.isProductInCart(
                                          productId:
                                              getCurrProduct.productId)) {
                                        return;
                                      }
                                      // local
                                      // cartProvider.addProductToCart(
                                      //     productId: getCurrProduct.productId);
                                      // firebase
                                      try {
                                        await cartProvider.addToCartFirebase(
                                            context: context,
                                            productId: getCurrProduct.productId,
                                            qty: 1);
                                      } catch (e) {
                                        // if (!mounted) return;
                                        MyAppMethods.showErrorORWarningDialog(
                                          context: context,
                                          subtitle: e.toString(),
                                          fct: () {},
                                        );
                                      }

                                      // local
                                      // if (cartProvider.isProductInCart(
                                      //     productId:
                                      //         getCurrProduct.productId)) {
                                      //   return;
                                      // }
                                      // cartProvider.addProductToCart(
                                      //     productId: getCurrProduct.productId);
                                    },
                                    icon: Icon(
                                      cartProvider.isProductInCart(
                                              productId:
                                                  getCurrProduct.productId)
                                          ? Icons.check
                                          : Icons.add_shopping_cart_rounded,
                                    ),
                                    label: Text(
                                      cartProvider.isProductInCart(
                                              productId:
                                                  getCurrProduct.productId)
                                          ? "In cart"
                                          : "Add to cart",
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const TitlesTextWidget(label: "About this item"),
                            SubtitleTextWidget(
                                label: "In ${getCurrProduct.productCategory}")
                          ],
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: SubtitleTextWidget(
                            label: getCurrProduct.productDescription,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )));
  }
}
