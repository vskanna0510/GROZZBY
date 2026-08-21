import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_provider.dart';
import 'account_setting_row.dart';

class AccountSettingsList extends StatelessWidget {
  const AccountSettingsList({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : AppColors.neutral200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            // 1. Notifications
            AccountSettingRow(
              icon: Icons.notifications_active_outlined,
              iconBgColor: AppColors.settingOrangeBg,
              iconColor: AppColors.settingOrange,
              title: 'Notifications',
              description: 'Push, email & SMS alerts',
              onTap: () => context.push('/profile/notification-preferences'),
            ),

            // 2. Privacy
            AccountSettingRow(
              icon: Icons.lock_outline_rounded,
              iconBgColor: AppColors.settingIndigoBg,
              iconColor: AppColors.settingIndigo,
              title: 'Privacy',
              description: 'Manage data & account visibility',
              onTap: () => context.push('/profile/privacy-security'),
            ),

            // 3. Payments & Security
            AccountSettingRow(
              icon: Icons.shield_outlined,
              iconBgColor: AppColors.settingEmeraldBg,
              iconColor: AppColors.settingEmerald,
              title: 'Payments & Security',
              description: 'Saved cards, UPI & biometric login',
              onTap: () => context.push('/profile/payments'),
            ),

            // 4. Shipping Preferences
            AccountSettingRow(
              icon: Icons.local_shipping_outlined,
              iconBgColor: AppColors.settingCyanBg,
              iconColor: AppColors.settingCyan,
              title: 'Shipping Preferences',
              description: 'Default delivery address & slots',
              onTap: () => context.push('/profile/shipping-preferences'),
            ),

            // 5. Language
            AccountSettingRow(
              icon: Icons.translate_rounded,
              iconBgColor: AppColors.settingVioletBg,
              iconColor: AppColors.settingViolet,
              title: 'Language',
              description: 'English (US), Spanish, French',
              onTap: () => context.push('/profile/language'),
            ),

            // 6. Theme
            Builder(
              builder: (ctx) {
                final themeProv = ctx.watch<ThemeProvider>();
                String themeLabel = 'Light Mode';
                if (themeProv.appThemeMode == AppThemeMode.dark) themeLabel = 'Dark Mode';
                if (themeProv.appThemeMode == AppThemeMode.system) themeLabel = 'System Default';

                return AccountSettingRow(
                  icon: Icons.palette_outlined,
                  iconBgColor: AppColors.settingSlateBg,
                  iconColor: AppColors.settingSlate,
                  title: 'Theme',
                  description: themeLabel,
                  onTap: () => context.push('/profile/theme'),
                );
              },
            ),

            // 7. Help Center
            AccountSettingRow(
              icon: Icons.help_outline_rounded,
              iconBgColor: AppColors.settingSkyBg,
              iconColor: AppColors.settingSky,
              title: 'Help Center',
              description: 'FAQs, live concierge & support',
              onTap: () => context.push('/support'),
            ),

            // 8. About Grozzy
            AccountSettingRow(
              icon: Icons.info_outline_rounded,
              iconBgColor: AppColors.settingBlueBg,
              iconColor: AppColors.settingBlue,
              title: 'About Grozzy',
              description: 'Version 2.4.1, terms & policies',
              showDivider: false,
              onTap: () => context.push('/profile/about'),
            ),
          ],
        ),
      ),
    );
  }
}
