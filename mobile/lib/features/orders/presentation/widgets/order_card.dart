import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../shop/models/order.dart';
import 'order_status_badge.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  final bool isCompletedTab;
  final VoidCallback? onBuyAgain;

  const OrderCard({
    super.key,
    required this.order,
    this.isCompletedTab = false,
    this.onBuyAgain,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    final timeFormat = DateFormat('hh:mm a');
    final firstItem = order.items.isNotEmpty ? order.items.first : null;
    final otherItemsCount = order.items.length - 1;

    return InkWell(
      onTap: () => context.push('/orders/${order.id}', extra: order),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.neutral200),
          boxShadow: const [
            BoxShadow(
              color: Color(0x08000000),
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          // 1. Header: Order ID, Date & Status Badge
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'ORDER #${order.orderNumber}',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.neutral500,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: order.orderNumber));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Order #${order.orderNumber} copied!'),
                                duration: const Duration(seconds: 1),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          child: const Icon(
                            Icons.copy_rounded,
                            size: 13,
                            color: AppColors.neutral400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Text(
                          dateFormat.format(order.createdAt),
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.neutral900,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          timeFormat.format(order.createdAt),
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.neutral500,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                OrderStatusBadge(status: order.status),
              ],
            ),
          ),

          // 2. 4-step Stepper for Active Orders (Figma 246:2050)
          if (!isCompletedTab && order.status != OrderStatus.delivered) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _buildMiniTimeline(order.status),
            ),
          ],

          const Divider(height: 1, color: AppColors.neutral200),

          // 3. Product Preview Box
          if (firstItem != null)
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 58,
                      height: 58,
                      color: AppColors.neutral50,
                      child: Image.network(
                        firstItem.product.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Center(
                          child: Icon(Icons.shopping_bag_outlined, color: AppColors.primary),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          firstItem.product.name + (otherItemsCount > 0 ? ' + $otherItemsCount More Items' : ''),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.neutral900,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          firstItem.product.unit.isNotEmpty ? firstItem.product.unit : 'Standard Delivery',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.neutral500,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '₹${order.total.toStringAsFixed(2)}',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.neutral900,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Arrival ETA Tag
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Arriving by',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.neutral500,
                            fontSize: 9.5,
                          ),
                        ),
                        Text(
                          order.status == OrderStatus.delivered ? 'Delivered' : 'Tomorrow',
                          style: AppTextStyles.caption.copyWith(
                            color: const Color(0xFF2563EB),
                            fontWeight: FontWeight.w700,
                            fontSize: 10.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          const Divider(height: 1, color: AppColors.neutral200),

          // 4. 3-Button Action Row (Figma exact: Invoice, Support, Track/Buy Again)
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Invoice button
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      context.push('/orders/${order.id}/invoice', extra: order);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.neutral800,
                      side: const BorderSide(color: AppColors.neutral300),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(
                      'Invoice',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Support button
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      context.push('/support');
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.neutral800,
                      side: const BorderSide(color: AppColors.neutral300),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(
                      'Support',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Primary Action Button (Track Order -> or Buy Again)
                if (!isCompletedTab && order.status != OrderStatus.delivered)
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () {
                        context.push('/orders/${order.id}/track', extra: order);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Track Order',
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.white,
                            ),
                          ),
                          const SizedBox(width: 3),
                          const Icon(Icons.arrow_forward_rounded, size: 13, color: AppColors.white),
                        ],
                      ),
                    ),
                  )
                else
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: onBuyAgain ??
                          () {
                            context.push('/product-details', extra: firstItem?.product);
                          },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(
                        'Buy Again',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    ),
    );
  }

  Widget _buildMiniTimeline(OrderStatus status) {
    int currentStep = 1;
    switch (status) {
      case OrderStatus.placed:
      case OrderStatus.confirmed:
        currentStep = 0;
        break;
      case OrderStatus.processing:
        currentStep = 1;
        break;
      case OrderStatus.inTransit:
      case OrderStatus.outForDelivery:
        currentStep = 2;
        break;
      case OrderStatus.delivered:
        currentStep = 3;
        break;
      case OrderStatus.cancelled:
        currentStep = 0;
        break;
    }

    final steps = ['Order Placed', 'Packed', 'Shipped', 'Delivered'];

    return Row(
      children: List.generate(7, (index) {
        if (index % 2 == 1) {
          final lineIdx = index ~/ 2;
          final isCompletedLine = lineIdx < currentStep;
          return Expanded(
            child: Container(
              height: 2,
              color: isCompletedLine ? AppColors.primary : AppColors.neutral200,
            ),
          );
        } else {
          final stepIdx = index ~/ 2;
          final isCompleted = stepIdx < currentStep;
          final isCurrent = stepIdx == currentStep;

          return Column(
            children: [
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted || isCurrent ? AppColors.primary : AppColors.neutral200,
                  border: isCurrent
                      ? Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 3)
                      : null,
                ),
                child: isCompleted
                    ? const Icon(Icons.check, size: 10, color: AppColors.white)
                    : null,
              ),
              const SizedBox(height: 3),
              Text(
                steps[stepIdx],
                style: AppTextStyles.caption.copyWith(
                  fontSize: 9,
                  fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                  color: isCurrent || isCompleted ? AppColors.neutral800 : AppColors.neutral400,
                ),
              ),
            ],
          );
        }
      }),
    );
  }
}
