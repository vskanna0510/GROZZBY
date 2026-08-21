import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../shop/models/order.dart';

class CourierInfoSheet extends StatelessWidget {
  final Order order;
  final VoidCallback? onCall;
  final VoidCallback? onMessage;
  final VoidCallback? onContactSupport;

  const CourierInfoSheet({
    super.key,
    required this.order,
    this.onCall,
    this.onMessage,
    this.onContactSupport,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Color(0x20000000),
            blurRadius: 20,
            offset: Offset(0, -6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Drag Handle
          Center(
            child: Container(
              width: 44,
              height: 4.5,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: AppColors.neutral300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          // 2. Delivery Time Estimate & Remaining stats (Figma 246:3482)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Arriving Today',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.neutral500,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '12:45 PM',
                    style: AppTextStyles.displayLarge.copyWith(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: AppColors.neutral900,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Text(
                    'Before 1:00 PM',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.neutral500,
                      fontWeight: FontWeight.w500,
                      fontSize: 11.5,
                    ),
                  ),
                ],
              ),

              // Distance & ETA tag
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '8 mins away',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF2563EB),
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '2.4 km remaining',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.neutral600,
                      fontWeight: FontWeight.w600,
                      fontSize: 11.5,
                    ),
                  ),
                  Text(
                    'Updated just now',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.neutral400,
                      fontSize: 10.5,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // 3. 4-Segment Green Progress Indicator (Figma 246:3482)
          Row(
            children: List.generate(4, (index) {
              final isFilled = index <= 2;
              return Expanded(
                child: Container(
                  height: 4,
                  margin: EdgeInsets.only(right: index == 3 ? 0 : 6),
                  decoration: BoxDecoration(
                    color: isFilled ? const Color(0xFF10B981) : AppColors.neutral200,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 6),
          Text(
            'Driver is on the way to your location',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.neutral600,
              fontSize: 11.5,
            ),
          ),

          const SizedBox(height: 14),

          // 4. Driver Profile Card (Marcus Chen / Alex River)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.neutral200),
            ),
            child: Row(
              children: [
                // Driver Avatar with Verified Tick
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(
                            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300&auto=format&fit=crop&q=80',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2563EB),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.white, width: 2),
                      ),
                      child: const Icon(Icons.check, size: 8, color: AppColors.white),
                    ),
                  ],
                ),

                const SizedBox(width: 12),

                // Driver Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Marcus Chen',
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w800,
                              color: AppColors.neutral900,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.verified, size: 14, color: Color(0xFF2563EB)),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, size: 13, color: Color(0xFFF59E0B)),
                          const SizedBox(width: 2),
                          Text(
                            '4.9',
                            style: AppTextStyles.caption.copyWith(
                              fontWeight: FontWeight.w800,
                              color: AppColors.neutral900,
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(1,240 deliveries)',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.neutral500,
                              fontSize: 10.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Electric Vehicle • Speaks English',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.neutral500,
                          fontSize: 10.5,
                        ),
                      ),
                    ],
                  ),
                ),

                // Actions: Call & Message (Icons in circles)
                Row(
                  children: [
                    InkWell(
                      onTap: onMessage ??
                          () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Opening chat with driver Marcus Chen...')),
                            );
                          },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: AppColors.neutral100,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.neutral200),
                        ),
                        child: const Icon(Icons.chat_bubble_outline_rounded, color: AppColors.neutral800, size: 18),
                      ),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: onCall ??
                          () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Calling driver Marcus Chen (+1-415-555-0199)...')),
                            );
                          },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: AppColors.neutral100,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.neutral200),
                        ),
                        child: const Icon(Icons.phone_outlined, color: AppColors.neutral800, size: 18),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // 5. Contact Support Button (Full width solid blue)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onContactSupport ??
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Connecting to Live Grozzby Support...')),
                    );
                  },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                'Contact Support',
                style: AppTextStyles.button.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // 6. Security Assurance Footer
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline_rounded, size: 11, color: AppColors.neutral500),
              const SizedBox(width: 3),
              Text(
                'Secure Delivery',
                style: AppTextStyles.caption.copyWith(color: AppColors.neutral500, fontSize: 10),
              ),
              const SizedBox(width: 8),
              const Text('•', style: TextStyle(color: AppColors.neutral400, fontSize: 10)),
              const SizedBox(width: 8),
              const Icon(Icons.gps_fixed_rounded, size: 11, color: AppColors.neutral500),
              const SizedBox(width: 3),
              Text(
                'Live GPS Tracking',
                style: AppTextStyles.caption.copyWith(color: AppColors.neutral500, fontSize: 10),
              ),
              const SizedBox(width: 8),
              const Text('•', style: TextStyle(color: AppColors.neutral400, fontSize: 10)),
              const SizedBox(width: 8),
              const Icon(Icons.verified_outlined, size: 11, color: AppColors.neutral500),
              const SizedBox(width: 3),
              Text(
                'Verified Courier',
                style: AppTextStyles.caption.copyWith(color: AppColors.neutral500, fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
