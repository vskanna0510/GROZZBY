import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class QuantityStepper extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final double height;
  final bool isMini;

  const QuantityStepper({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    this.height = 36,
    this.isMini = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isMini ? 30 : height,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(isMini ? 8 : 10),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepButton(
            icon: Icons.remove_rounded,
            size: isMini ? 26 : 32,
            onPressed: onDecrement,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isMini ? 6 : 10),
            child: Text(
              quantity.toString(),
              style: isMini
                  ? AppTextStyles.labelBold12Inter.copyWith(color: AppColors.white)
                  : AppTextStyles.bodySemiBold14.copyWith(color: AppColors.white),
            ),
          ),
          _StepButton(
            icon: Icons.add_rounded,
            size: isMini ? 26 : 32,
            onPressed: onIncrement,
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  final IconData icon;
  final double size;
  final VoidCallback onPressed;

  const _StepButton({
    required this.icon,
    required this.size,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(size / 2),
          onTap: onPressed,
          child: Center(
            child: Icon(
              icon,
              size: size * 0.55,
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }
}
