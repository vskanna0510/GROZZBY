import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shop/models/order.dart';

class OrderTimelineStepper extends StatelessWidget {
  final OrderStatus status;
  final bool isCompact;

  const OrderTimelineStepper({
    super.key,
    required this.status,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final steps = [
      {'title': 'Confirmed', 'date': 'Oct 24', 'icon': Icons.check_rounded},
      {'title': 'Packed', 'date': 'Oct 24', 'icon': Icons.check_rounded},
      {'title': 'In Transit', 'date': 'Oct 25', 'icon': Icons.local_shipping_rounded},
      {'title': 'Out for\nDelivery', 'date': 'Oct 26', 'icon': Icons.location_on_outlined},
      {'title': 'Delivered', 'date': 'Oct 26 - Oct 28', 'icon': Icons.home_outlined},
    ];

    // Current step index (0=Confirmed, 1=Packed, 2=In Transit, 3=Out for Delivery, 4=Delivered)
    int currentStep = 2; // Default to In Transit matching screenshot
    if (status == OrderStatus.placed || status == OrderStatus.confirmed) {
      currentStep = 0;
    } else if (status == OrderStatus.processing) {
      currentStep = 1;
    } else if (status == OrderStatus.inTransit) {
      currentStep = 2;
    } else if (status == OrderStatus.outForDelivery) {
      currentStep = 3;
    } else if (status == OrderStatus.delivered) {
      currentStep = 4;
    }

    if (isCompact) {
      return Row(
        children: List.generate(steps.length * 2 - 1, (index) {
          if (index.isOdd) {
            final stepIdx = index ~/ 2;
            final isPassed = stepIdx < currentStep;
            return Expanded(
              child: Container(
                height: 2.5,
                color: isPassed ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0),
              ),
            );
          } else {
            final stepIdx = index ~/ 2;
            final isCompleted = stepIdx <= currentStep;

            return Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted ? const Color(0xFF2563EB) : const Color(0xFFF1F5F9),
                border: Border.all(
                  color: isCompleted ? const Color(0xFF2563EB) : const Color(0xFFCBD5E1),
                  width: 1.5,
                ),
              ),
              child: isCompleted
                  ? const Icon(Icons.check, size: 8, color: Colors.white)
                  : null,
            );
          }
        }),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: List.generate(steps.length * 2 - 1, (index) {
              if (index.isOdd) {
                final stepIdx = index ~/ 2;
                final isPassed = stepIdx < currentStep;
                return Expanded(
                  child: Container(
                    height: 2.5,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    color: isPassed ? const Color(0xFF2563EB) : const Color(0xFFCBD5E1),
                  ),
                );
              } else {
                final stepIdx = index ~/ 2;
                final isCompleted = stepIdx < currentStep;
                final isCurrent = stepIdx == currentStep;
                final icon = steps[stepIdx]['icon'] as IconData;

                return Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (isCompleted || isCurrent)
                        ? const Color(0xFF2563EB)
                        : const Color(0xFFF8FAFC),
                    border: Border.all(
                      color: (isCompleted || isCurrent)
                          ? const Color(0xFF2563EB)
                          : const Color(0xFFCBD5E1),
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      icon,
                      size: 15,
                      color: (isCompleted || isCurrent) ? Colors.white : const Color(0xFF94A3B8),
                    ),
                  ),
                );
              }
            }),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(steps.length, (i) {
              final step = steps[i];
              final isCurrent = i == currentStep;
              final isCompleted = i <= currentStep;

              return SizedBox(
                width: 58,
                child: Column(
                  children: [
                    Text(
                      step['title'] as String,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w700,
                        color: isCompleted ? const Color(0xFF0F172A) : const Color(0xFF94A3B8),
                        fontFamily: 'Inter',
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      step['date'] as String,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 8.5,
                        color: isCompleted ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
