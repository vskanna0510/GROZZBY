import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class PaymentMethodTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget leading;
  final bool isSelected;
  final VoidCallback onSelect;
  final Widget? trailing;
  final Widget? extraContent;

  const PaymentMethodTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.leading,
    required this.isSelected,
    required this.onSelect,
    this.trailing,
    this.extraContent,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEFF6FF) : AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0xFFE2E8F0),
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.06)
                  : Colors.black.withValues(alpha: 0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                // Radio indicator
                Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    border: Border.all(
                      color: isSelected ? AppColors.primary : const Color(0xFF94A3B8),
                      width: isSelected ? 4.5 : 1.5,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Icon / Logo
                leading,
                const SizedBox(width: 12),

                // Title & Subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0F172A),
                          fontFamily: 'Inter',
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle!,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF64748B),
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Trailing if any
                if (trailing != null) trailing!,
              ],
            ),
            if (isSelected && extraContent != null) ...[
              const SizedBox(height: 12),
              extraContent!,
            ],
          ],
        ),
      ),
    );
  }
}
