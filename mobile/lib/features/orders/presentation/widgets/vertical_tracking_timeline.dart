import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shop/models/order.dart';

class VerticalTrackingTimeline extends StatelessWidget {
  final Order? order;
  final List<TrackingStep>? steps;

  const VerticalTrackingTimeline({
    super.key,
    this.order,
    this.steps,
  });

  @override
  Widget build(BuildContext context) {
    final timelineItems = [
      {
        'title': 'Order Confirmed',
        'time': 'Oct 24, 10:45 AM',
        'description': 'Your order has been placed',
        'icon': Icons.check_rounded,
        'state': 'completed', // completed, active, upcoming
      },
      {
        'title': 'Packed',
        'time': 'Oct 24, 03:20 PM',
        'description': 'Your item has been packed',
        'icon': Icons.check_rounded,
        'state': 'completed',
      },
      {
        'title': 'In Transit',
        'time': 'Oct 25, 07:30 AM',
        'description': 'Your order is on the way',
        'icon': Icons.local_shipping_rounded,
        'state': 'active',
      },
      {
        'title': 'Out for Delivery',
        'time': 'Oct 28, 09:00 AM',
        'description': 'Your order is out for delivery',
        'icon': Icons.location_on_rounded,
        'state': 'upcoming',
        'hasLive': true,
      },
      {
        'title': 'Delivered',
        'time': 'Oct 28 - Oct 30',
        'description': 'Expected delivery by end of day',
        'icon': Icons.home_rounded,
        'state': 'upcoming',
      },
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: timelineItems.length,
      itemBuilder: (context, index) {
        final item = timelineItems[index];
        final isLast = index == timelineItems.length - 1;
        final state = item['state'] as String;
        final isActive = state == 'active';
        final isCompleted = state == 'completed';
        final icon = item['icon'] as IconData;
        final hasLive = item['hasLive'] == true;

        final isLineCompleted = isCompleted || (isActive && !isLast);

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left Column: Node Icon + Vertical Progress Line
              SizedBox(
                width: 44,
                child: Column(
                  children: [
                    // Node Icon Circle
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: (isCompleted || isActive)
                            ? const Color(0xFF2563EB)
                            : const Color(0xFFF1F5F9),
                        border: Border.all(
                          color: (isCompleted || isActive)
                              ? const Color(0xFF2563EB)
                              : const Color(0xFFCBD5E1),
                          width: 1.5,
                        ),
                        boxShadow: isActive
                            ? [
                                BoxShadow(
                                  color: const Color(0xFF2563EB).withValues(alpha: 0.25),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ]
                            : null,
                      ),
                      child: Center(
                        child: Icon(
                          icon,
                          size: 18,
                          color: (isCompleted || isActive)
                              ? Colors.white
                              : const Color(0xFF64748B),
                        ),
                      ),
                    ),
                    // Connector Vertical Line
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 3,
                          color: isLineCompleted
                              ? const Color(0xFF2563EB)
                              : const Color(0xFFE2E8F0),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // Right Column: Timeline Card
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isActive ? const Color(0xFFEFF6FF) : AppColors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isActive ? const Color(0xFFBFDBFE) : const Color(0xFFE2E8F0),
                        width: isActive ? 1.5 : 1.0,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x04000000),
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'] as String,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: isActive
                                ? const Color(0xFF2563EB)
                                : const Color(0xFF0F172A),
                            fontFamily: 'Inter',
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          item['time'] as String,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['description'] as String,
                          style: const TextStyle(
                            fontSize: 11.5,
                            color: Color(0xFF94A3B8),
                            fontFamily: 'Inter',
                          ),
                        ),
                        if (hasLive) ...[
                          const SizedBox(height: 6),
                          InkWell(
                            onTap: () {
                              if (order != null) {
                                context.push('/orders/${order!.id}/live-tracking', extra: order);
                              }
                            },
                            child: const Text(
                              'Live',
                              style: TextStyle(
                                color: Color(0xFF2563EB),
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
