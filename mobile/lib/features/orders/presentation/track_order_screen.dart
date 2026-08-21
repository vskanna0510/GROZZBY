import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/grozzby_app_top_bar.dart';
import '../../../shared/widgets/grozzby_bottom_nav_bar.dart';
import '../../shop/models/order.dart';
import '../data/orders_provider.dart';
import 'widgets/shipping_info_card.dart';
import 'widgets/vertical_tracking_timeline.dart';
import 'widgets/need_help_support_card.dart';

class TrackOrderScreen extends StatelessWidget {
  final Order? order;
  final String? orderId;

  const TrackOrderScreen({
    super.key,
    this.order,
    this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    final ordersProvider = context.watch<OrdersProvider>();
    final activeOrder = order ??
        (orderId != null ? ordersProvider.getOrderById(orderId!) : null) ??
        ordersProvider.orders.first;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Shared Brand Top Bar
            const GrozzbyAppTopBar(),

            // 2. Subheader with Back Button & Title
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: AppColors.white,
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go('/orders');
                      }
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.neutral50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.neutral200),
                      ),
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        size: 18,
                        color: AppColors.neutral900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Track Order',
                    style: AppTextStyles.headingBold20.copyWith(
                      color: AppColors.neutral900,
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),

            // 3. Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                child: Column(
                  children: [
                    // 1. Courier / Shipping Info Card (Figma 246:2840)
                    ShippingInfoCard(order: activeOrder),

                    const SizedBox(height: 14),

                    // 2. Live Map Navigation Banner (Quick Access)
                    InkWell(
                      onTap: () {
                        context.push('/orders/${activeOrder.id}/live-tracking', extra: activeOrder);
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFBFDBFE)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.navigation_rounded, color: AppColors.white, size: 16),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Live GPS Tracking Available',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: const Color(0xFF1D4ED8),
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    'Driver Alex is 8 mins away • View on Map',
                                    style: AppTextStyles.caption.copyWith(
                                      color: const Color(0xFF3B82F6),
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFF1D4ED8)),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // 3. Vertical Tracking Timeline (Figma 246:2840 matching Screenshot 2)
                    VerticalTrackingTimeline(order: activeOrder),

                    const SizedBox(height: 14),

                    // 4. Expected Delivery Card Banner (Figma 246:2840)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.neutral200),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Expected Delivery',
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.neutral500,
                                    fontSize: 11.5,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  activeOrder.estimatedDelivery,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.neutral900,
                                    fontSize: 14.5,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Before 8 PM',
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.neutral600,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.calendar_month_rounded,
                              color: AppColors.primary,
                              size: 26,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // 5. Share Tracking Action Card (Figma 246:2840)
                    InkWell(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Sharing tracking link for #${activeOrder.orderNumber}...'),
                            duration: const Duration(seconds: 1),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.neutral200),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.share_outlined, color: AppColors.primary, size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Share Tracking',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.neutral900,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    'Share tracking details with others',
                                    style: AppTextStyles.caption.copyWith(
                                      color: AppColors.neutral500,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right_rounded, color: AppColors.neutral400),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 6. Need Help Support Card
                    const NeedHelpSupportCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: GrozzbyBottomNavBar(
        currentIndex: 4,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/home');
              break;
            case 1:
              context.go('/categories');
              break;
            case 2:
              context.go('/search');
              break;
            case 3:
              context.go('/cart');
              break;
            case 4:
              context.go('/profile');
              break;
          }
        },
      ),
    );
  }
}
