import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class CouponModel {
  final String code;
  final String title;
  final String description;
  final String minOrder;
  final String expiry;
  final double discountAmount;
  final double? discountPercentage;
  final bool isFeatured;

  const CouponModel({
    required this.code,
    required this.title,
    required this.description,
    required this.minOrder,
    required this.expiry,
    required this.discountAmount,
    this.discountPercentage,
    this.isFeatured = false,
  });
}

class CouponCard extends StatelessWidget {
  final CouponModel coupon;
  final bool isApplied;
  final VoidCallback onApply;

  const CouponCard({
    super.key,
    required this.coupon,
    required this.isApplied,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isApplied ? const Color(0xFF16A34A) : const Color(0xFFE2E8F0),
          width: isApplied ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isApplied
                ? Colors.green.withValues(alpha: 0.06)
                : Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Code Pill
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: isApplied
                            ? const Color(0xFFF0FDF4)
                            : const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isApplied
                              ? const Color(0xFF86EFAC)
                              : const Color(0xFFBFDBFE),
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isApplied ? Icons.check_circle_rounded : Icons.local_offer_outlined,
                            size: 14,
                            color: isApplied ? const Color(0xFF16A34A) : AppColors.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            coupon.code,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: isApplied ? const Color(0xFF16A34A) : AppColors.primary,
                              letterSpacing: 0.5,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Apply / Applied CTA
                    ElevatedButton(
                      onPressed: isApplied ? null : onApply,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isApplied ? const Color(0xFF16A34A) : AppColors.primary,
                        disabledBackgroundColor: const Color(0xFF16A34A),
                        foregroundColor: Colors.white,
                        disabledForegroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        minimumSize: Size.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        isApplied ? 'APPLIED' : 'APPLY',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Title
                Text(
                  coupon.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 4),

                // Description
                Text(
                  coupon.description,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF64748B),
                    fontFamily: 'Inter',
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 10),

                // Divider line with dotted styling
                Container(
                  height: 1,
                  color: const Color(0xFFF1F5F9),
                ),
                const SizedBox(height: 10),

                // Expiry and Min Order
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.shopping_bag_outlined,
                          size: 13,
                          color: Color(0xFF94A3B8),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          coupon.minOrder,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFF64748B),
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time_rounded,
                          size: 13,
                          color: Color(0xFF94A3B8),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          coupon.expiry,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF94A3B8),
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (coupon.isFeatured)
            Positioned(
              top: 0,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: const BoxDecoration(
                  color: Color(0xFFF97316),
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(6)),
                ),
                child: const Text(
                  'HOT DEAL',
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 0.5,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
