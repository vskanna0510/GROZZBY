import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class OrderBillSummary extends StatelessWidget {
  final double subtotal;
  final double discount;
  final double deliveryFee;
  final double tax;
  final double couponDiscount;
  final String? appliedPromoCode;
  final double total;
  final VoidCallback? onApplyCouponTap;

  const OrderBillSummary({
    super.key,
    required this.subtotal,
    this.discount = 0.0,
    required this.deliveryFee,
    required this.tax,
    this.couponDiscount = 0.0,
    this.appliedPromoCode,
    required this.total,
    this.onApplyCouponTap,
  });

  @override
  Widget build(BuildContext context) {
    final totalSavings = discount + couponDiscount + (deliveryFee == 0 ? 40.0 : 0.0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.receipt_long_outlined,
                size: 18,
                color: AppColors.primary,
              ),
              SizedBox(width: 8),
              Text(
                'Bill Summary',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Subtotal
          _buildRow('Item Total (MRP)', '₹${subtotal.toStringAsFixed(2)}'),
          const SizedBox(height: 8),

          // Product Discount
          if (discount > 0) ...[
            _buildRow('Product Discount', '-₹${discount.toStringAsFixed(2)}', isGreen: true),
            const SizedBox(height: 8),
          ],

          // Delivery Fee
          _buildRow(
            'Delivery Fee',
            deliveryFee == 0.0 ? 'FREE' : '₹${deliveryFee.toStringAsFixed(2)}',
            isGreen: deliveryFee == 0.0,
          ),
          const SizedBox(height: 8),

          // Taxes & GST
          _buildRow('Taxes & GST (5%)', '₹${tax.toStringAsFixed(2)}'),
          const SizedBox(height: 8),

          // Coupon Discount
          if (couponDiscount > 0) ...[
            _buildRow(
              'Coupon ($appliedPromoCode)',
              '-₹${couponDiscount.toStringAsFixed(2)}',
              isGreen: true,
            ),
            const SizedBox(height: 8),
          ],

          const Divider(color: Color(0xFFF1F5F9), height: 20),

          // Total Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'To Pay',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                      fontFamily: 'Inter',
                    ),
                  ),
                  Text(
                    'Inclusive of all taxes',
                    style: TextStyle(
                      fontSize: 10,
                      color: Color(0xFF94A3B8),
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
              Text(
                '₹${total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),

          if (totalSavings > 0) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFDCFCE7)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.celebration_outlined,
                    size: 16,
                    color: Color(0xFF16A34A),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Yay! You saved ₹${totalSavings.toStringAsFixed(0)} on this order',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF16A34A),
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool isGreen = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF475569),
            fontFamily: 'Inter',
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isGreen ? FontWeight.w700 : FontWeight.w600,
            color: isGreen ? const Color(0xFF16A34A) : const Color(0xFF1E293B),
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }
}
