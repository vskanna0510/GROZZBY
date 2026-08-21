import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../shop/models/order.dart';

class InvoiceTable extends StatelessWidget {
  final Order order;

  const InvoiceTable({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Table Header (ITEM | QTY | PRICE)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: const BoxDecoration(
              color: AppColors.neutral50,
              borderRadius: BorderRadius.vertical(top: Radius.circular(13)),
              border: Border(bottom: BorderSide(color: AppColors.neutral200)),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Text(
                    'ITEM',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.neutral500,
                      fontWeight: FontWeight.w800,
                      fontSize: 11,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'QTY',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.neutral500,
                      fontWeight: FontWeight.w800,
                      fontSize: 11,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    'PRICE',
                    textAlign: TextAlign.right,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.neutral500,
                      fontWeight: FontWeight.w800,
                      fontSize: 11,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 2. Order Item Rows
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: order.items.length,
            separatorBuilder: (_, _) => const Divider(height: 1, color: AppColors.neutral200),
            itemBuilder: (context, index) {
              final item = order.items[index];

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    // Item Name
                    Expanded(
                      flex: 5,
                      child: Text(
                        item.product.name.toUpperCase(),
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.neutral900,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Quantity
                    Expanded(
                      flex: 2,
                      child: Text(
                        '${item.quantity}',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.neutral700,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.5,
                        ),
                      ),
                    ),
                    // Price
                    Expanded(
                      flex: 3,
                      child: Text(
                        '₹${item.totalPrice.toStringAsFixed(2)}',
                        textAlign: TextAlign.right,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.neutral900,
                          fontSize: 12.5,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          const Divider(height: 1, color: AppColors.neutral200),

          // 3. Price Calculation Breakdown (Figma 246:3104)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildSummaryRow('Subtotal (${order.items.length} items)', '₹${order.subtotal.toStringAsFixed(2)}'),
                const SizedBox(height: 8),
                _buildSummaryRow(
                  'Discount',
                  '- ₹${order.discount.toStringAsFixed(2)}',
                  valueColor: const Color(0xFF16A34A),
                ),
                const SizedBox(height: 8),
                _buildSummaryRow(
                  'Shipping',
                  order.deliveryFee == 0 ? 'FREE' : '₹${order.deliveryFee.toStringAsFixed(2)}',
                  valueColor: order.deliveryFee == 0 ? const Color(0xFF16A34A) : null,
                ),
                const SizedBox(height: 8),
                _buildSummaryRow('Tax', '₹${order.tax.toStringAsFixed(2)}'),
                const SizedBox(height: 14),
                const Divider(height: 1, color: AppColors.neutral200),
                const SizedBox(height: 14),

                // Total Row (Figma 246:3104: Total Paid • ₹200.00, You saved ₹160.00)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Paid',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.neutral900,
                            fontSize: 14.5,
                          ),
                        ),
                        if (order.discount > 0)
                          Text(
                            'You saved ₹${order.discount.toStringAsFixed(2)}',
                            style: AppTextStyles.caption.copyWith(
                              color: const Color(0xFF16A34A),
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                            ),
                          ),
                      ],
                    ),
                    Text(
                      '₹${order.total.toStringAsFixed(2)}',
                      style: AppTextStyles.headingBold20.copyWith(
                        fontWeight: FontWeight.w900,
                        color: AppColors.neutral900,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.neutral600,
            fontSize: 12.5,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w700,
            color: valueColor ?? AppColors.neutral900,
            fontSize: 12.5,
          ),
        ),
      ],
    );
  }
}
