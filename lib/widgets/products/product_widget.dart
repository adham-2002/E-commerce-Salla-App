import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:project/providers/product_provider.dart';
import 'package:project/providers/viewed_prod_provider.dart';
import 'package:project/screens/inner_screens/product_details.dart';
import 'package:project/services/my_app_methods.dart';
import 'package:project/widgets/products/heart_btn.dart';
import 'package:project/widgets/subtitle_text.dart';
import 'package:project/widgets/title_text.dart';
import 'package:provider/provider.dart';
import 'package:project/providers/cart_provider.dart';

class ProductWidget extends StatefulWidget {
  const ProductWidget({
    super.key,
    required this.productId,
  });
  final String productId;
  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  @override
  Widget build(BuildContext context) {
    //final productModelProvider = Provider.of<ProductModel>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final getCurrProduct = productProvider.findByProdId(widget.productId);
    final cartProvider = Provider.of<CartProvider>(context);
    final viewedProvider = Provider.of<ViewedProdProvider>(context);

    Size size = MediaQuery.of(context).size;
    return getCurrProduct == null
        ? const SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.all(3.0),
            child: InkWell(
              onTap: () async {
                viewedProvider.addProdToHistory(
                    productId: getCurrProduct.productId);
                await Navigator.pushNamed(
                  context,
                  productDetails.routName,
                  arguments: getCurrProduct.productId,
                );
              },
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: FancyShimmerImage(
                      imageUrl: getCurrProduct.productImage,
                      width: double.infinity,
                      height: size.height * 0.22,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 5,
                        child: TitlesTextWidget(
                          label: getCurrProduct.productTitle,
                          maxLines: 2,
                          fontSize: 18,
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: HeartButtonWidget(
                            productId: getCurrProduct.productId),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 3,
                        child: SubtitleTextWidget(
                            label: "${getCurrProduct.productPrice}\$"),
                      ),
                      Flexible(
                        child: Material(
                          borderRadius: BorderRadius.circular(16.0),
                          color: Colors.lightBlue,
                          child: InkWell(
                            splashColor:
                                const Color.fromARGB(255, 248, 201, 198),
                            borderRadius: BorderRadius.circular(16.0),
                            onTap: () async {
                              if (cartProvider.isProductInCart(
                                  productId: getCurrProduct.productId)) {
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
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                cartProvider.isProductInCart(
                                        productId: getCurrProduct.productId)
                                    ? Icons.check
                                    : Icons.add_shopping_cart_rounded,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          );
  }
}
