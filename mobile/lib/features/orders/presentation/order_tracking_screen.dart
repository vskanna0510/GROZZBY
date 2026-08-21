import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../shop/data/shop_data.dart';
import '../../shop/models/order.dart';

class OrderTrackingScreen extends StatelessWidget {
  final Order? order;

  const OrderTrackingScreen({
    super.key,
    this.order,
  });

  @override
  Widget build(BuildContext context) {
    final currentOrder = order ?? ShopData.sampleOrders.first;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.neutral900, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Track Order #${currentOrder.orderNumber}',
          style: AppTextStyles.headingBold20.copyWith(color: AppColors.neutral900, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline_rounded, color: AppColors.neutral800),
            onPressed: () => context.push('/support'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Live Map Simulation Graphic Card
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.neutral200),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Map grid lines texture
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CustomPaint(
                        painter: _MapRoadPainter(),
                      ),
                    ),
                  ),

                  // Courier marker on map
                  Positioned(
                    top: 60,
                    left: 120,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryDark,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(color: AppColors.black.withValues(alpha: 0.2), blurRadius: 4),
                            ],
                          ),
                          child: Text(
                            'David (Courier)',
                            style: AppTextStyles.captionBlack10.copyWith(color: AppColors.white, fontSize: 9),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.white, width: 2),
                          ),
                          child: const Icon(Icons.two_wheeler_rounded, color: AppColors.white, size: 18),
                        ),
                      ],
                    ),
                  ),

                  // Destination Pin
                  Positioned(
                    bottom: 30,
                    right: 40,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.danger,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.white, width: 2),
                          ),
                          child: const Icon(Icons.home_rounded, color: AppColors.white, size: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Estimated Delivery Time Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.neutral200),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.timer_outlined, color: AppColors.warningForeground, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Estimated Delivery', style: AppTextStyles.captionRegular10.copyWith(fontSize: 11, color: AppColors.neutral500)),
                        const SizedBox(height: 2),
                        Text(
                          currentOrder.estimatedDelivery,
                          style: AppTextStyles.headingBold18.copyWith(
                            fontSize: 16,
                            color: AppColors.neutral900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Courier Agent Contact Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.neutral200),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.primaryLight,
                    child: Icon(Icons.person_rounded, color: AppColors.primary, size: 28),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('David Martinez', style: AppTextStyles.bodySemiBold14.copyWith(fontSize: 15)),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, size: 14, color: AppColors.starRating),
                            const SizedBox(width: 2),
                            Text('4.9 (1,240+ deliveries)', style: AppTextStyles.captionRegular10.copyWith(color: AppColors.neutral500)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    style: IconButton.styleFrom(backgroundColor: AppColors.primaryLight),
                    icon: const Icon(Icons.phone_rounded, color: AppColors.primary, size: 20),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Calling Courier (+1 555-0192)...')),
                      );
                    },
                  ),
                  const SizedBox(width: 6),
                  IconButton(
                    style: IconButton.styleFrom(backgroundColor: AppColors.primaryLight),
                    icon: const Icon(Icons.chat_bubble_outline_rounded, color: AppColors.primary, size: 20),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Opening chat with driver...')),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Live Stepper Timeline
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.neutral200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Order Progress', style: AppTextStyles.headingBold18.copyWith(fontSize: 16)),
                  const SizedBox(height: 16),
                  ...List.generate(currentOrder.trackingSteps.length, (index) {
                    final step = currentOrder.trackingSteps[index];
                    final isLast = index == currentOrder.trackingSteps.length - 1;

                    return _TimelineStep(
                      step: step,
                      isLast: isLast,
                    );
                  }),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Delivery Address Summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.neutral200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded, color: AppColors.primary, size: 18),
                      const SizedBox(width: 8),
                      Text('Delivery Address', style: AppTextStyles.bodySemiBold14),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(currentOrder.address.recipientName, style: AppTextStyles.bodyRegular14.copyWith(fontWeight: FontWeight.w500)),
                  Text(currentOrder.address.fullAddress, style: AppTextStyles.bodyRegular13.copyWith(color: AppColors.neutral600)),
                  const SizedBox(height: 4),
                  Text(currentOrder.address.phoneNumber, style: AppTextStyles.captionRegular10.copyWith(color: AppColors.neutral500)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimelineStep extends StatelessWidget {
  final TrackingStep step;
  final bool isLast;

  const _TimelineStep({
    required this.step,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final color = step.isCompleted
        ? AppColors.primary
        : step.isCurrent
            ? AppColors.warning
            : AppColors.neutral300;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: step.isCompleted ? AppColors.primary : AppColors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: color,
                  width: step.isCompleted ? 1 : 2,
                ),
              ),
              child: Center(
                child: step.isCompleted
                    ? const Icon(Icons.check_rounded, color: AppColors.white, size: 14)
                    : step.isCurrent
                        ? Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.warning,
                              shape: BoxShape.circle,
                            ),
                          )
                        : null,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 42,
                color: step.isCompleted ? AppColors.primary : AppColors.neutral200,
              ),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    step.title,
                    style: AppTextStyles.bodySemiBold14.copyWith(
                      color: step.isCompleted || step.isCurrent
                          ? AppColors.neutral900
                          : AppColors.neutral500,
                    ),
                  ),
                  Text(
                    step.time,
                    style: AppTextStyles.captionRegular10.copyWith(
                      color: step.isCompleted ? AppColors.neutral600 : AppColors.neutral400,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                step.description,
                style: AppTextStyles.captionRegular10.copyWith(
                  color: AppColors.neutral500,
                  fontSize: 11,
                ),
              ),
              if (!isLast) const SizedBox(height: 12),
            ],
          ),
        ),
      ],
    );
  }
}

class _MapRoadPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 14
      ..style = PaintingStyle.stroke;

    final dashPaint = Paint()
      ..color = const Color(0xFFCBD5E1)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, size.height * 0.4);
    path.cubicTo(
      size.width * 0.3,
      size.height * 0.2,
      size.width * 0.6,
      size.height * 0.7,
      size.width,
      size.height * 0.6,
    );

    canvas.drawPath(path, roadPaint);
    canvas.drawPath(path, dashPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
