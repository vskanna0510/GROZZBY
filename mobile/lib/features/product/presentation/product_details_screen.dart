import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/product_card.dart';
import '../../../shared/widgets/quantity_stepper.dart';
import '../../cart/data/cart_provider.dart';
import '../../wishlist/data/wishlist_provider.dart';
import '../../shop/data/shop_data.dart';
import '../../shop/models/product.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;

  const ProductDetailsScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _selectedQuantity = 1;
  bool _isDescriptionExpanded = false;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final cart = context.watch<CartProvider>();
    final wishlist = context.watch<WishlistProvider>();
    final isFav = wishlist.isFavorite(product.id);
    final inCartQty = cart.getQuantity(product.id);

    final relatedProducts = ShopData.products
        .where((p) => p.categoryId == product.categoryId && p.id != product.id)
        .toList();

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.neutral900, size: 20),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: AppColors.neutral800),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Sharing ${product.name}')),
              );
            },
          ),
          IconButton(
            icon: Icon(
              isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: isFav ? AppColors.danger : AppColors.neutral800,
            ),
            onPressed: () => wishlist.toggleFavorite(product.id),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Product Image
            Container(
              height: 280,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.neutral50,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.neutral200.withValues(alpha: 0.6)),
              ),
              child: Stack(
                children: [
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.network(
                        product.imageUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.shopping_basket_outlined,
                          size: 80,
                          color: AppColors.neutral400,
                        ),
                      ),
                    ),
                  ),
                  if (product.discountPercent > 0)
                    Positioned(
                      top: 14,
                      left: 14,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.danger,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${product.discountPercent}% OFF',
                          style: AppTextStyles.captionBlack10.copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Product Information
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category & Rating Row
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          product.categoryName,
                          style: AppTextStyles.captionBlack10.copyWith(
                            color: AppColors.primary,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        product.unit,
                        style: AppTextStyles.captionRegular10.copyWith(
                          fontSize: 12,
                          color: AppColors.neutral500,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.star_rounded, size: 18, color: AppColors.starRating),
                      const SizedBox(width: 3),
                      Text(
                        product.rating.toStringAsFixed(1),
                        style: AppTextStyles.bodySemiBold14.copyWith(fontSize: 13),
                      ),
                      Text(
                        ' (${product.reviewCount} reviews)',
                        style: AppTextStyles.captionRegular10.copyWith(
                          fontSize: 11,
                          color: AppColors.neutral500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Product Title
                  Text(
                    product.name,
                    style: AppTextStyles.headingBold24.copyWith(
                      color: AppColors.neutral900,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Pricing row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '₹${product.price.toStringAsFixed(0)}',
                        style: AppTextStyles.priceBold20.copyWith(
                          fontSize: 26,
                          color: AppColors.primaryDark,
                        ),
                      ),
                      if (product.originalPrice != null) ...[
                        const SizedBox(width: 10),
                        Text(
                          '₹${product.originalPrice!.toStringAsFixed(0)}',
                          style: AppTextStyles.priceOld12.copyWith(fontSize: 16),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.successLight,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Save ₹${(product.originalPrice! - product.price).toStringAsFixed(0)}',
                            style: AppTextStyles.captionBlack10.copyWith(
                              color: AppColors.success,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 16),
                  const Divider(color: AppColors.neutral200),
                  const SizedBox(height: 12),

                  // Delivery Guarantee Box
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.neutral50,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.neutral200),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: AppColors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.bolt_rounded, color: AppColors.warning, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Instant 15-Min Delivery',
                                style: AppTextStyles.bodySemiBold14.copyWith(fontSize: 13),
                              ),
                              Text(
                                'Free doorstep returns if item is damaged or sub-par',
                                style: AppTextStyles.captionRegular10.copyWith(
                                  color: AppColors.neutral500,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Store Fulfillment Card: From where the products are coming
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFCBDAEF).withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFB9CEEC)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: const BoxDecoration(
                                color: Color(0xFF00288E),
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Icon(Icons.storefront_rounded, size: 18, color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Fulfilled from Aura Flagship - Soho',
                                    style: TextStyle(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF191C1D),
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                  Text(
                                    '123 Prince St • 1.2 mi • Open until 9 PM',
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      color: const Color(0xFF505050).withValues(alpha: 0.9),
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => context.push('/stores/soho'),
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: const Color(0xFF00288E),
                                  side: const BorderSide(color: Color(0xFF00288E)),
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                child: const Text(
                                  'View Store Details →',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, fontFamily: 'Inter'),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => context.push('/stores'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF00288E),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                child: const Text(
                                  'Nearest Stores 📍',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, fontFamily: 'Inter'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Nutrition facts
                  if (product.nutrition.isNotEmpty) ...[
                    Text('Nutritional Highlights', style: AppTextStyles.headingBold18.copyWith(fontSize: 16)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: product.nutrition.entries.map((entry) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.neutral200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry.key,
                                style: AppTextStyles.captionRegular10.copyWith(
                                  color: AppColors.neutral500,
                                  fontSize: 10,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                entry.value,
                                style: AppTextStyles.bodySemiBold14.copyWith(
                                  fontSize: 12,
                                  color: AppColors.primaryDark,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Description
                  Text('Description', style: AppTextStyles.headingBold18.copyWith(fontSize: 16)),
                  const SizedBox(height: 6),
                  Text(
                    product.description,
                    maxLines: _isDescriptionExpanded ? null : 3,
                    style: AppTextStyles.bodyRegular14.copyWith(
                      color: AppColors.neutral700,
                      height: 1.5,
                    ),
                  ),
                  if (product.description.length > 100)
                    InkWell(
                      onTap: () => setState(() => _isDescriptionExpanded = !_isDescriptionExpanded),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          _isDescriptionExpanded ? 'Read Less' : 'Read More',
                          style: AppTextStyles.labelBold12Inter.copyWith(color: AppColors.primary),
                        ),
                      ),
                    ),

                  const SizedBox(height: 24),

                  // Related Products
                  if (relatedProducts.isNotEmpty) ...[
                    Text('You Might Also Like', style: AppTextStyles.headingBold18.copyWith(fontSize: 16)),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 245,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: relatedProducts.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: ProductCard(
                              width: 154,
                              product: relatedProducts[index],
                            ),
                          );
                        },
                      ),
                    ),
                  ],

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),

      // Sticky Bottom Cart Bar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 20),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: const Border(top: BorderSide(color: AppColors.neutral200)),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Quantity stepper
              QuantityStepper(
                quantity: inCartQty > 0 ? inCartQty : _selectedQuantity,
                onIncrement: () {
                  if (inCartQty > 0) {
                    cart.increment(product.id);
                  } else {
                    setState(() => _selectedQuantity++);
                  }
                },
                onDecrement: () {
                  if (inCartQty > 0) {
                    cart.decrement(product.id);
                  } else {
                    if (_selectedQuantity > 1) {
                      setState(() => _selectedQuantity--);
                    }
                  }
                },
              ),
              const SizedBox(width: 14),

              // Add to Cart Button
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (inCartQty == 0) {
                      cart.addItem(product, _selectedQuantity);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Added ${_selectedQuantity}x ${product.name} to Cart'),
                          action: SnackBarAction(
                            label: 'VIEW CART',
                            textColor: AppColors.warning,
                            onPressed: () => context.push('/cart'),
                          ),
                        ),
                      );
                    } else {
                      context.push('/cart');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        inCartQty > 0 ? Icons.shopping_bag_rounded : Icons.add_shopping_cart_rounded,
                        color: AppColors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        inCartQty > 0
                            ? 'Go to Cart (₹${(product.price * inCartQty).toStringAsFixed(0)})'
                            : 'Add to Cart (₹${(product.price * _selectedQuantity).toStringAsFixed(0)})',
                        style: AppTextStyles.bodySemiBold16.copyWith(color: AppColors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
