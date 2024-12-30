import 'package:flutter/material.dart';
import 'package:project/providers/product_provider.dart';
import 'package:project/widgets/subtitle_text.dart';
import 'package:project/widgets/title_text.dart';
import 'package:project/providers/cart_provider.dart';
import 'package:provider/provider.dart';

class CartBottomCheckout extends StatelessWidget {
  const CartBottomCheckout({super.key, required this.function});
  final Function function;
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);

    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: const Border(top: BorderSide(width: 1, color: Colors.grey))),
      child: SizedBox(
        height: kBottomNavigationBarHeight + 20,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitlesTextWidget(
                      label:
                          "Total(${cartProvider.getCartItems.length} products/${cartProvider.getQty()} Items)"),
                  SubtitleTextWidget(
                    label:
                        "${cartProvider.getTotal(productProvider: productProvider)}\$",
                    color: Colors.blue,
                  ),
                ],
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  await function();
                },
                child: const Text("Checkout")),
          ]),
        ),
      ),
    );
  }
}
