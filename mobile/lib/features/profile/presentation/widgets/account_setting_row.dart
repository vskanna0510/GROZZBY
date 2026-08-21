import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class AccountSettingRow extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String title;
  final String description;
  final Widget? trailing;
  final bool showDivider;
  final VoidCallback onTap;

  const AccountSettingRow({
    super.key,
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.title,
    required this.description,
    this.trailing,
    this.showDivider = true,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  // 40px Colored Icon Container Box
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: iconBgColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Icon(
                        icon,
                        color: iconColor,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Title and Supporting Description
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: AppTextStyles.settingRowTitle,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          description,
                          style: AppTextStyles.settingRowSubtitle,
                        ),
                      ],
                    ),
                  ),

                  // Trailing widget or right chevron
                  if (trailing != null)
                    trailing!
                  else
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
        if (showDivider)
          const Padding(
            padding: EdgeInsets.only(left: 68, right: 16),
            child: Divider(
              height: 1,
              thickness: 1,
              color: AppColors.neutral100,
            ),
          ),
      ],
    );
  }
}
