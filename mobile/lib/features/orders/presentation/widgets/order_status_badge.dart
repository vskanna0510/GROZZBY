import 'package:flutter/material.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../shop/models/order.dart';

class OrderStatusBadge extends StatelessWidget {
  final OrderStatus status;
  final bool isPaid;

  const OrderStatusBadge({
    super.key,
    required this.status,
    this.isPaid = false,
  });

  const OrderStatusBadge.paid({
    super.key,
  })  : status = OrderStatus.delivered,
        isPaid = true;

  @override
  Widget build(BuildContext context) {
    if (isPaid) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3.5),
        decoration: BoxDecoration(
          color: const Color(0xFFDCFCE7),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF86EFAC), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: Color(0xFF008E5E),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 5),
            Text(
              'Paid',
              style: AppTextStyles.caption.copyWith(
                color: const Color(0xFF008E5E),
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }

    final String label;
    final Color bgColor = status.badgeBgColor;
    final Color textColor = status.badgeTextColor;
    final IconData icon;

    switch (status) {
      case OrderStatus.delivered:
        label = 'Delivered';
        icon = Icons.check_circle_rounded;
        break;
      case OrderStatus.inTransit:
      case OrderStatus.outForDelivery:
        label = 'In Transit';
        icon = Icons.local_shipping_rounded;
        break;
      case OrderStatus.processing:
      case OrderStatus.placed:
      case OrderStatus.confirmed:
        label = 'Processing';
        icon = Icons.hourglass_top_rounded;
        break;
      case OrderStatus.cancelled:
        label = 'Cancelled';
        icon = Icons.cancel_rounded;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4.5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: textColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: textColor,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
