import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:project/providers/wishlist_provider.dart';
import 'package:provider/provider.dart';

class HeartButtonWidget extends StatefulWidget {
  const HeartButtonWidget({
    super.key,
    this.size = 22,
    this.color = Colors.transparent,
    required this.productId,
  });
  final double size;
  final Color color;
  final String productId;
  @override
  State<HeartButtonWidget> createState() => _HeartButtonWidgetState();
}

class _HeartButtonWidgetState extends State<HeartButtonWidget> {
  @override
  Widget build(BuildContext context) {
    final wishListprovider = Provider.of<WishlistProvider>(context);
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: widget.color,
      ),
      child: IconButton(
        style: IconButton.styleFrom(
          shape: const CircleBorder(),
        ),
        onPressed: () {
          wishListprovider.addOrRemoveFromWishlist(productId: widget.productId);
          // wishListprovider
        },
        icon: Icon(
          wishListprovider.isProductInWishlist(productId: widget.productId)
              ? IconlyBold.heart
              : IconlyLight.heart,
          size: widget.size,
          color:
              wishListprovider.isProductInWishlist(productId: widget.productId)
                  ? Colors.red
                  : Colors.blue,
        ),
      ),
    );
  }
}
