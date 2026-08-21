import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../auth/presentation/auth_controller.dart';
import '../../orders/data/orders_provider.dart';
import '../../wishlist/data/wishlist_provider.dart';

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

    final userName = auth.user?.name ?? 'Alex Johnson';
    final userEmail = auth.user?.email ?? 'alex.johnson@example.com';
    final userPhone = auth.user?.phone ?? '+1 (555) 234-5678';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 1,
        title: Text(
          'My Account',
          style: AppTextStyles.headingBold20.copyWith(color: AppColors.neutral900),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: AppColors.neutral800),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('App Settings v1.0.0')),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
        child: Column(
          children: [
            // Profile Info Header Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.neutral200),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 68,
                            height: 68,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.primary, width: 2),
                            ),
                            child: const Center(
                              child: Icon(Icons.person_rounded, size: 40, color: AppColors.primary),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: AppColors.warning,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.edit_rounded, size: 12, color: AppColors.warningForeground),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    userName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.headingBold18.copyWith(color: AppColors.neutral900),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.warning.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    'GOLD 🌟',
                                    style: AppTextStyles.captionBlack10.copyWith(fontSize: 8.5, color: AppColors.warningForeground),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(userEmail, style: AppTextStyles.bodyRegular13.copyWith(color: AppColors.neutral600)),
                            const SizedBox(height: 1),
                            Text(userPhone, style: AppTextStyles.captionRegular10.copyWith(color: AppColors.neutral500)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1, color: AppColors.neutral200),
                  const SizedBox(height: 12),

                  // Quick Stats Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _QuickStat(count: '$ordersCount', label: 'Orders', onTap: () => context.push('/orders')),
                      Container(height: 28, width: 1, color: AppColors.neutral200),
                      _QuickStat(count: '$wishlistCount', label: 'Wishlist', onTap: () => context.push('/wishlist')),
                      Container(height: 28, width: 1, color: AppColors.neutral200),
                      _QuickStat(count: '₹450.00', label: 'Wallet', onTap: () {}),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Account Options Menu List
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.neutral200),
              ),
              child: Column(
                children: [
                  _ProfileMenuItem(
                    icon: Icons.receipt_long_rounded,
                    iconColor: AppColors.primary,
                    title: 'My Orders',
                    subtitle: '$ordersCount active & past orders',
                    onTap: () => context.push('/orders'),
                  ),
                  const Divider(height: 1, indent: 56, color: AppColors.neutral200),
                  _ProfileMenuItem(
                    icon: Icons.local_shipping_outlined,
                    iconColor: AppColors.success,
                    title: 'Shipping Preferences',
                    subtitle: 'Default delivery address & speed',
                    onTap: () => context.push('/profile/shipping-preferences'),
                  ),
                  const Divider(height: 1, indent: 56, color: AppColors.neutral200),
                  _ProfileMenuItem(
                    icon: Icons.language_rounded,
                    iconColor: AppColors.accentSky,
                    title: 'Language',
                    subtitle: 'English (United States)',
                    onTap: () => context.push('/profile/language'),
                  ),
                  const Divider(height: 1, indent: 56, color: AppColors.neutral200),
                  _ProfileMenuItem(
                    icon: Icons.security_rounded,
                    iconColor: AppColors.primary,
                    title: 'Privacy & Security',
                    subtitle: 'Password, 2FA, & data privacy',
                    onTap: () => context.push('/profile/privacy-security'),
                  ),
                  const Divider(height: 1, indent: 56, color: AppColors.neutral200),
                  _ProfileMenuItem(
                    icon: Icons.favorite_rounded,
                    iconColor: AppColors.danger,
                    title: 'Wishlist & Saved Items',
                    subtitle: '$wishlistCount products saved',
                    onTap: () => context.push('/wishlist'),
                  ),
                  const Divider(height: 1, indent: 56, color: AppColors.neutral200),
                  _ProfileMenuItem(
                    icon: Icons.notifications_rounded,
                    iconColor: AppColors.warning,
                    title: 'Notification Preferences',
                    subtitle: 'Order updates and promotional alerts',
                    onTap: () => context.push('/profile/notification-preferences'),
                  ),
                  const Divider(height: 1, indent: 56, color: AppColors.neutral200),
                  _ProfileMenuItem(
                    icon: Icons.storefront_rounded,
                    iconColor: AppColors.primary,
                    title: 'Find Stores Nearby',
                    subtitle: 'Store locator, hours & amenities',
                    onTap: () => context.push('/stores'),
                  ),
                  const Divider(height: 1, indent: 56, color: AppColors.neutral200),
                  _ProfileMenuItem(
                    icon: Icons.help_outline_rounded,
                    iconColor: AppColors.accentSky,
                    title: 'Help Center & FAQs',
                    subtitle: 'Browse articles & get answers',
                    onTap: () => context.push('/support'),
                  ),
                  const Divider(height: 1, indent: 56, color: AppColors.neutral200),
                  _ProfileMenuItem(
                    icon: Icons.support_agent_rounded,
                    iconColor: AppColors.success,
                    title: 'Contact Concierge',
                    subtitle: '24/7 Live chat, email & phone',
                    onTap: () => context.push('/support/contact'),
                  ),
                  const Divider(height: 1, indent: 56, color: AppColors.neutral200),
                  _ProfileMenuItem(
                    icon: Icons.info_outline_rounded,
                    iconColor: AppColors.neutral700,
                    title: 'About Grozzby',
                    subtitle: 'Version 2.4.1 • Mission & terms',
                    onTap: () => context.push('/profile/about'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Logout Button
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.neutral200),
              ),
              child: _ProfileMenuItem(
                icon: Icons.logout_rounded,
                iconColor: AppColors.danger,
                title: 'Sign Out',
                subtitle: 'Log out of this device',
                titleColor: AppColors.danger,
                onTap: () => _showLogoutDialog(context),
              ),
            ),

            const SizedBox(height: 16),
            Text(
              'Grozzby v2.4.1 • Made with ❤️ for fresh living',
              style: AppTextStyles.captionRegular10.copyWith(color: AppColors.neutral400),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickStat extends StatelessWidget {
  final String count;
  final String label;
  final VoidCallback onTap;

  const _QuickStat({
    required this.count,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Column(
          children: [
            Text(
              count,
              style: AppTextStyles.headingBold18.copyWith(
                color: AppColors.primaryDark,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTextStyles.captionRegular10.copyWith(color: AppColors.neutral500),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Color? titleColor;
  final VoidCallback onTap;

  const _ProfileMenuItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.titleColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.bodySemiBold14.copyWith(
                        color: titleColor ?? AppColors.neutral900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTextStyles.captionRegular10.copyWith(
                        color: AppColors.neutral500,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.neutral400),
            ],
          ),
        ),
      ),
    );
  }
}
