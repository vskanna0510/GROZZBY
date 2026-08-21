import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String time;
  final String category; // 'orders', 'offers', 'system'
  final IconData icon;
  final Color iconColor;
  bool isRead;
  final String? route;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.category,
    required this.icon,
    required this.iconColor,
    this.isRead = false,
    this.route,
  });
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _selectedCategory = 'all';

  final List<NotificationItem> _notifications = [
    NotificationItem(
      id: 'notif_1',
      title: 'Order Out for Delivery! 🛵',
      message: 'Courier David is on the way with your fresh groceries for Order #GRZ-89241.',
      time: '15 mins ago',
      category: 'orders',
      icon: Icons.two_wheeler_rounded,
      iconColor: AppColors.primary,
      isRead: false,
      route: '/order-tracking',
    ),
    NotificationItem(
      id: 'notif_2',
      title: 'Weekend Flash Sale is LIVE! ⚡',
      message: 'Get up to 40% off on fresh organic avocados, strawberries, and dairy essentials.',
      time: '2 hours ago',
      category: 'offers',
      icon: Icons.flash_on_rounded,
      iconColor: AppColors.warning,
      isRead: false,
      route: '/home',
    ),
    NotificationItem(
      id: 'notif_3',
      title: 'Promo Code Available: SAVE50 🏷️',
      message: 'Enjoy ₹50 off on all orders above ₹299 today. Use coupon SAVE50 at checkout.',
      time: 'Yesterday',
      category: 'offers',
      icon: Icons.local_offer_rounded,
      iconColor: AppColors.success,
      isRead: true,
      route: '/cart',
    ),
    NotificationItem(
      id: 'notif_4',
      title: 'Order Delivered Successfully 🎉',
      message: 'Order #GRZ-87512 was delivered to 742 Evergreen Terrace. How was your experience?',
      time: '3 days ago',
      category: 'orders',
      icon: Icons.check_circle_rounded,
      iconColor: AppColors.success,
      isRead: true,
      route: '/orders',
    ),
    NotificationItem(
      id: 'notif_5',
      title: 'Welcome to Grozzby Gold! 🌟',
      message: 'You have earned Gold membership status with free delivery on select categories.',
      time: '1 week ago',
      category: 'system',
      icon: Icons.stars_rounded,
      iconColor: AppColors.warning,
      isRead: true,
      route: '/profile',
    ),
  ];

  void _markAllAsRead() {
    setState(() {
      for (final n in _notifications) {
        n.isRead = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All notifications marked as read')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _selectedCategory == 'all'
        ? _notifications
        : _notifications.where((n) => n.category == _selectedCategory).toList();

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
          'Notifications',
          style: AppTextStyles.headingBold20.copyWith(color: AppColors.neutral900),
        ),
        actions: [
          TextButton(
            onPressed: _markAllAsRead,
            child: Text(
              'Read All',
              style: AppTextStyles.captionMedium11.copyWith(
                color: AppColors.primary,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Category Filter Chips
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildChip('all', 'All'),
                  _buildChip('orders', 'Orders'),
                  _buildChip('offers', 'Offers & Deals'),
                  _buildChip('system', 'Account'),
                ],
              ),
            ),
          ),
          const Divider(height: 1, color: AppColors.neutral200),

          // Notifications List
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.notifications_off_outlined, size: 48, color: AppColors.neutral300),
                        const SizedBox(height: 12),
                        Text('No notifications here', style: AppTextStyles.bodySemiBold14.copyWith(color: AppColors.neutral500)),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: filtered.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = filtered[index];

                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            setState(() => item.isRead = true);
                            if (item.route != null) {
                              context.push(item.route!);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: item.isRead ? AppColors.white : AppColors.primaryLight.withValues(alpha: 0.35),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: item.isRead ? AppColors.neutral200 : AppColors.primary.withValues(alpha: 0.3),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.black.withValues(alpha: 0.02),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: item.iconColor.withValues(alpha: 0.12),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(item.icon, color: item.iconColor, size: 20),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              item.title,
                                              style: AppTextStyles.bodySemiBold14.copyWith(
                                                color: AppColors.neutral900,
                                                fontSize: 13.5,
                                              ),
                                            ),
                                          ),
                                          if (!item.isRead)
                                            Container(
                                              width: 8,
                                              height: 8,
                                              decoration: const BoxDecoration(
                                                color: AppColors.primary,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        item.message,
                                        style: AppTextStyles.captionRegular10.copyWith(
                                          color: AppColors.neutral600,
                                          fontSize: 12,
                                          height: 1.35,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        item.time,
                                        style: AppTextStyles.captionRegular10.copyWith(
                                          color: AppColors.neutral400,
                                          fontSize: 10.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String id, String label) {
    final isSel = _selectedCategory == id;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSel,
        onSelected: (sel) {
          if (sel) setState(() => _selectedCategory = id);
        },
        selectedColor: AppColors.primaryDark,
        backgroundColor: AppColors.neutral100,
        labelStyle: AppTextStyles.labelBold12Inter.copyWith(
          fontSize: 12,
          color: isSel ? AppColors.white : AppColors.neutral700,
        ),
      ),
    );
  }
}
