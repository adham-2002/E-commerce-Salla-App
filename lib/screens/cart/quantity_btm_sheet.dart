import 'package:flutter/material.dart';
import 'package:project/widgets/subtitle_text.dart';
import 'package:project/providers/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:project/models/cart_model.dart';

class QuantityBottomSheetWidget extends StatelessWidget {
  const QuantityBottomSheetWidget({super.key, required this.cartModel});
  //init product id
  final CartModel cartModel;

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 6,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: Colors.grey,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 30,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      cartProvider.updateQuantity(
                          productId: cartModel.productId, quantity: index + 1);
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Center(
                        child: SubtitleTextWidget(
                          label: "${index + 1}",
                        ),
                      ),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
