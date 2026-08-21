import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/grozzby_app_top_bar.dart';
import '../../auth/presentation/auth_controller.dart';
import '../../cart/data/cart_provider.dart';
import '../../orders/data/orders_provider.dart';
import '../../wishlist/data/wishlist_provider.dart';
import 'widgets/account_profile_hero.dart';
import 'widgets/account_settings_list.dart';
import 'widgets/quick_actions_grid.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Sign Out', style: AppTextStyles.headingBold18),
        content: Text(
          'Are you sure you want to sign out of your Grozzby account?',
          style: AppTextStyles.bodyRegular14.copyWith(color: AppColors.neutral700),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: AppTextStyles.bodySemiBold14.copyWith(color: AppColors.neutral600)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AuthController>().logout();
              context.go('/sign-in');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text('Sign Out', style: AppTextStyles.bodySemiBold14.copyWith(color: AppColors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    final ordersCount = context.watch<OrdersProvider>().orders.length;
    final wishlistCount = context.watch<WishlistProvider>().count;
    final cartCount = context.watch<CartProvider>().totalItemCount;

    final userName = auth.user?.name ?? 'Jonathan Sterling';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Header Bar with Location, Grozzby Mark, and Cart Icon
            GrozzbyAppTopBar(
              location: 'New York, 10001',
              showCart: true,
              cartCount: cartCount,
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 80),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Profile Hero Gradient Card (96px avatar + blur edit button)
                    AccountProfileHero(
                      name: userName,
                      subtitle: 'Member since Jan 2024 • Gold Tier',
                      isVerified: true,
                      onEditProfile: () => context.push('/profile/edit'),
                    ),

                    const SizedBox(height: 24),

                    // 2. Quick Actions Heading & 2x2 Grid
                    Text(
                      'Quick Actions',
                      style: AppTextStyles.accountSectionTitle,
                    ),
                    const SizedBox(height: 12),
                    QuickActionsGrid(
                      ordersCount: ordersCount,
                      wishlistCount: wishlistCount,
                      addressCount: 3,
                      cardsCount: 2,
                      onOrdersTap: () => context.push('/orders'),
                      onWishlistTap: () => context.push('/wishlist'),
                      onAddressesTap: () => context.push('/profile/addresses'),
                      onPaymentsTap: () => context.push('/profile/payments'),
                    ),

                    const SizedBox(height: 26),

                    // 3. Account Settings Heading & List Card
                    Text(
                      'Account Settings',
                      style: AppTextStyles.accountSectionTitle,
                    ),
                    const SizedBox(height: 12),
                    const AccountSettingsList(),

                    const SizedBox(height: 24),

                    // 4. Bottom Action: Switch Account
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.neutral200),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withValues(alpha: 0.02),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => context.push('/profile/switch-account'),
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.neutral100,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.switch_account_rounded,
                                    color: AppColors.neutral800,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Switch Account',
                                        style: AppTextStyles.bodySemiBold14,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Logged in as $userName',
                                        style: AppTextStyles.caption,
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.chevron_right_rounded,
                                  size: 20,
                                  color: AppColors.neutral400,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // 5. Bottom Action: Sign Out Button
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.dangerLight),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => _showLogoutDialog(context),
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.dangerLight,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.logout_rounded,
                                    color: AppColors.danger,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Sign Out',
                                        style: AppTextStyles.bodySemiBold14.copyWith(
                                          color: AppColors.danger,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Log out of this device',
                                        style: AppTextStyles.caption,
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.chevron_right_rounded,
                                  size: 20,
                                  color: AppColors.danger,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // App Version Footer
                    Center(
                      child: Text(
                        'Grozzby v2.4.1 • Made with ❤️ for fresh living',
                        style: AppTextStyles.caption.copyWith(color: AppColors.neutral400),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
