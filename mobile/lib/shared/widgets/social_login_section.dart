import 'package:flutter/material.dart';
import '../../core/constants/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_text_styles.dart';
import 'grozzby_asset.dart';

class SocialLoginSection extends StatelessWidget {
  const SocialLoginSection({
    super.key,
    this.showBorder = false,
    this.onSocialTap,
  });

  final bool showBorder;
  final void Function(String provider)? onSocialTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 2,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.divider,
            borderRadius: BorderRadius.circular(AppRadius.xs),
          ),
        ),
        const SizedBox(height: 29),
        Text('Or Continue with  Account', style: AppTextStyles.labelSemiBold12),
        const SizedBox(height: 26),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _SocialButton(
                asset: AppAssets.icons.facebook,
                showBorder: showBorder,
                onTap: () => onSocialTap?.call('facebook'),
              ),
              const SizedBox(width: 18),
              _SocialButton(
                asset: AppAssets.icons.google,
                showBorder: showBorder,
                onTap: () => onSocialTap?.call('google'),
              ),
              const SizedBox(width: 18),
              _SocialButton(
                asset: AppAssets.icons.apple,
                showBorder: showBorder,
                onTap: () => onSocialTap?.call('apple'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.asset,
    required this.onTap,
    this.showBorder = false,
  });

  final String asset;
  final VoidCallback onTap;
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.xl3),
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.xl3),
          border: showBorder ? Border.all(color: AppColors.neutral300) : null,
        ),
        padding: const EdgeInsets.all(12),
        child: GrozzbyAsset(asset, fit: BoxFit.contain),
      ),
    );
  }
}
