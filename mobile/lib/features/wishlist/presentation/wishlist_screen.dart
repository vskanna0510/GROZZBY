import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/product_card.dart';
import '../data/wishlist_provider.dart';
import '../../cart/data/cart_provider.dart';

class WishlistScreen extends StatelessWidget {
  final VoidCallback? onExplore;

  const WishlistScreen({
    super.key,
    this.onExplore,
  });

  @override
  Widget build(BuildContext context) {
    final wishlist = context.watch<WishlistProvider>();
    final cart = context.watch<CartProvider>();
    final favoriteProducts = wishlist.favoriteProducts;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 1,
        title: Text(
          'My Wishlist (${wishlist.count})',
          style: AppTextStyles.headingBold20.copyWith(color: AppColors.neutral900),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_bag_outlined, color: AppColors.neutral800),
                onPressed: () => context.push('/cart'),
              ),
              if (cart.totalItemCount > 0)
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.warning,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      cart.totalItemCount.toString(),
                      textAlign: TextAlign.center,
                      style: AppTextStyles.captionBlack10.copyWith(fontSize: 9),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: favoriteProducts.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: AppColors.danger.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite_border_rounded,
                        size: 46,
                        color: AppColors.danger,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Your Wishlist is Empty',
                      style: AppTextStyles.headingBold20.copyWith(color: AppColors.neutral900),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Save your favorite grocery essentials here to re-order quickly whenever you need them.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyRegular14.copyWith(color: AppColors.neutral500),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        if (onExplore != null) {
                          onExplore!();
                        } else {
                          context.go('/home');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: Text(
                        'Explore Products',
                        style: AppTextStyles.bodySemiBold14.copyWith(color: AppColors.white),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: favoriteProducts.length,
              itemBuilder: (context, index) {
                return ProductCard(product: favoriteProducts[index]);
              },
            ),
    );
  }
}
