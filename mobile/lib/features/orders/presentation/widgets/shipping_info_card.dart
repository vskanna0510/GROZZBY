import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../shop/models/order.dart';
import 'delivery_van_illustration.dart';

class ShippingInfoCard extends StatelessWidget {
  final Order order;

  const ShippingInfoCard({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    final courier = order.courier;

    return Container(
      padding: const EdgeInsets.all(14),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Delivery Van Circular Illustration
          const DeliveryVanIllustration(size: 80),

          const SizedBox(width: 14),

          // 2. Courier Details & Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Courier Name & Last Updated
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Grozzby Express',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF0F172A),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: const Color(0xFFDBEAFE)),
                          ),
                          child: const Text(
                            'FAST',
                            style: TextStyle(
                              color: Color(0xFF2563EB),
                              fontSize: 8.5,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Last Updated',
                          style: TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 9.5,
                            fontFamily: 'Inter',
                          ),
                        ),
                        Text(
                          courier.lastUpdated.isNotEmpty ? courier.lastUpdated : '5 mins ago',
                          style: const TextStyle(
                            color: Color(0xFF0F172A),
                            fontWeight: FontWeight.w700,
                            fontSize: 10.5,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                // Tracking ID
                const Text(
                  'Tracking ID',
                  style: TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 10,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 1),
                Row(
                  children: [
                    Text(
                      courier.trackingId.isNotEmpty ? courier.trackingId : 'AE-23981782',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF2563EB),
                        fontSize: 12.5,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(width: 4),
                    InkWell(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: courier.trackingId.isNotEmpty ? courier.trackingId : 'AE-23981782'));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Tracking ID copied!'),
                            duration: Duration(seconds: 1),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.copy_rounded,
                        size: 13,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                // Expected Delivery
                const Text(
                  'Expected Delivery',
                  style: TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 10,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 1),
                Row(
                  children: [
                    const Text(
                      'Tomorrow, Oct 28',
                      style: TextStyle(
                        color: Color(0xFF16A34A),
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      '⏰ Before 8 PM',
                      style: TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 10.5,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                // Secured & Insured Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFDCFCE7)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.shield_outlined, size: 12, color: Color(0xFF16A34A)),
                      SizedBox(width: 4),
                      Text(
                        'Secured & Insured',
                        style: TextStyle(
                          color: Color(0xFF16A34A),
                          fontWeight: FontWeight.w700,
                          fontSize: 9.5,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
