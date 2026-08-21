import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

enum CheckoutStep {
  cart,
  address,
  payment,
  review,
}

class CheckoutStepper extends StatelessWidget {
  final CheckoutStep currentStep;
  final ValueChanged<CheckoutStep>? onStepTapped;

  const CheckoutStepper({
    super.key,
    required this.currentStep,
    this.onStepTapped,
  });

  @override
  Widget build(BuildContext context) {
    const steps = [
      (CheckoutStep.cart, 'Cart', Icons.shopping_cart_outlined),
      (CheckoutStep.address, 'Address', Icons.location_on_outlined),
      (CheckoutStep.payment, 'Payment', Icons.credit_card_outlined),
      (CheckoutStep.review, 'Review', Icons.verified_outlined),
    ];

    final currentIndex = currentStep.index;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(steps.length * 2 - 1, (index) {
          if (index.isOdd) {
            // Connector line
            final stepBefore = index ~/ 2;
            final isCompleted = stepBefore < currentIndex;
            return Expanded(
              child: Container(
                margin: const EdgeInsets.only(bottom: 20),
                height: 1.5,
                decoration: BoxDecoration(
                  color: isCompleted ? AppColors.primary : const Color(0xFFE2E8F0),
                ),
              ),
            );
          }

          final stepIndex = index ~/ 2;
          final stepData = steps[stepIndex];
          final isCompleted = stepIndex < currentIndex;
          final isActive = stepIndex == currentIndex;

          return GestureDetector(
            onTap: onStepTapped != null && stepIndex <= currentIndex
                ? () => onStepTapped!(stepData.$1)
                : null,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isCompleted
                            ? AppColors.primaryLight
                            : isActive
                                ? AppColors.white
                                : const Color(0xFFF1F5F9),
                        border: Border.all(
                          color: isCompleted
                              ? AppColors.primary
                              : isActive
                                  ? AppColors.primary
                                  : const Color(0xFFE2E8F0),
                          width: isActive ? 2 : 1.5,
                        ),
                        boxShadow: isActive
                            ? [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.18),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Center(
                        child: Icon(
                          isCompleted ? Icons.check_rounded : stepData.$3,
                          size: 18,
                          color: isCompleted
                              ? AppColors.primary
                              : isActive
                                  ? AppColors.primary
                                  : const Color(0xFF94A3B8),
                        ),
                      ),
                    ),
                    if (isCompleted)
                      Positioned(
                        bottom: -2,
                        right: -2,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                          child: const Icon(
                            Icons.check_rounded,
                            size: 9,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  stepData.$2,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isActive || isCompleted ? FontWeight.w700 : FontWeight.w500,
                    color: isActive
                        ? AppColors.primary
                        : isCompleted
                            ? const Color(0xFF1E293B)
                            : const Color(0xFF94A3B8),
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
