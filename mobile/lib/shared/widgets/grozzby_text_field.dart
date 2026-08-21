import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_text_styles.dart';
import 'grozzby_asset.dart';

class GrozzbyTextField extends StatelessWidget {
  const GrozzbyTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.leadingIcon,
    this.obscureText = false,
    this.keyboardType,
    this.trailing,
  });

  final TextEditingController controller;
  final String hint;
  final String? leadingIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.input,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 13),
      child: Row(
        children: [
          if (leadingIcon != null) ...[
            GrozzbyAsset(leadingIcon!, width: 24, height: 24),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscureText,
              keyboardType: keyboardType,
              style: AppTextStyles.labelBold12.copyWith(color: AppColors.neutral950),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: hint,
                hintStyle: AppTextStyles.labelBold12.copyWith(color: AppColors.neutral950),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}
