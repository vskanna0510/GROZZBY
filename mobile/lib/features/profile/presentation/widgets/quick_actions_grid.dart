import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'quick_action_card.dart';

class QuickActionsGrid extends StatelessWidget {
  final int ordersCount;
  final int wishlistCount;
  final int addressCount;
  final int cardsCount;
  final VoidCallback onOrdersTap;
  final VoidCallback onWishlistTap;
  final VoidCallback onAddressesTap;
  final VoidCallback onPaymentsTap;

  const QuickActionsGrid({
    super.key,
    required this.ordersCount,
    required this.wishlistCount,
    this.addressCount = 3,
    this.cardsCount = 2,
    required this.onOrdersTap,
    required this.onWishlistTap,
    required this.onAddressesTap,
    required this.onPaymentsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Row 1: Orders & Wishlist
        Row(
          children: [
            Expanded(
              child: QuickActionCard(
                icon: Icons.receipt_long_rounded,
                iconBgColor: AppColors.actionOrdersBg,
                iconColor: AppColors.actionOrdersIcon,
                title: 'My Orders',
                subtitle: ordersCount > 0 ? '$ordersCount Active Orders' : 'Track orders',
                badgeText: ordersCount > 0 ? '$ordersCount Active' : '0 Active',
                onTap: onOrdersTap,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: QuickActionCard(
                icon: Icons.favorite_rounded,
                iconBgColor: AppColors.actionWishlistBg,
                iconColor: AppColors.actionWishlistIcon,
                title: 'Wishlist',
                subtitle: wishlistCount > 0 ? '$wishlistCount Saved Items' : 'Favorite items',
                badgeText: wishlistCount > 0 ? '$wishlistCount Items' : '0 Items',
                onTap: onWishlistTap,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Row 2: Addresses & Payments
        Row(
          children: [
            Expanded(
              child: QuickActionCard(
                icon: Icons.location_on_rounded,
                iconBgColor: AppColors.actionAddressBg,
                iconColor: AppColors.actionAddressIcon,
                title: 'Addresses',
                subtitle: '$addressCount Delivery Locations',
                badgeText: '$addressCount Saved',
                onTap: onAddressesTap,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: QuickActionCard(
                icon: Icons.credit_card_rounded,
                iconBgColor: AppColors.actionPaymentBg,
                iconColor: AppColors.actionPaymentIcon,
                title: 'Payments',
                subtitle: '$cardsCount Saved Methods',
                badgeText: '$cardsCount Cards',
                onTap: onPaymentsTap,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
