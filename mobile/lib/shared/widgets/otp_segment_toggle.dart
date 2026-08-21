import 'package:flutter/material.dart';
import '../../core/constants/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_text_styles.dart';
import 'grozzby_asset.dart';

class OtpSegmentToggle extends StatelessWidget {
  const OtpSegmentToggle({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: AppColors.chart1,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.neutral100, width: 1.1),
      ),
      child: Row(
        children: [
          _Segment(
            label: 'Email',
            icon: AppAssets.icons.emailOtp,
            selected: selected == 'email',
            onTap: () => onChanged('email'),
          ),
          _Segment(
            label: 'Phone',
            icon: AppAssets.icons.phoneOtp,
            selected: selected == 'phone',
            onTap: () => onChanged('phone'),
          ),
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: selected ? AppColors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            boxShadow: selected
                ? const [
                    BoxShadow(
                      color: Color(0x1A000000),
                      offset: Offset(0, 1),
                      blurRadius: 3,
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GrozzbyAsset(icon, width: 12, height: 12),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppTextStyles.labelBold12Inter.copyWith(
                  color: selected ? AppColors.warningForeground : AppColors.neutral500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
