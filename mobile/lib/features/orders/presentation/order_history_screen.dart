import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/grozzby_app_top_bar.dart';
import '../../../shared/widgets/grozzby_bottom_nav_bar.dart';
import '../../cart/data/cart_provider.dart';
import '../data/orders_provider.dart';
import '../../shop/models/order.dart';
import 'widgets/order_card.dart';
import 'widgets/need_help_support_card.dart';

class OrderHistoryScreen extends StatefulWidget {
  final int initialTabIndex;

  const OrderHistoryScreen({
    super.key,
    this.initialTabIndex = 0,
  });

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTabIndex.clamp(0, 1),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ordersProvider = context.watch<OrdersProvider>();
    final cartProvider = context.watch<CartProvider>();
    final activeOrders = ordersProvider.activeOrders;
    final completedOrders = ordersProvider.completedOrders;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Shared Brand Top Bar
            const GrozzbyAppTopBar(),

            // 2. Screen Subheader with Back Button & Subtitle (Figma 246:2050 / 246:3304)
            Container(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              color: AppColors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          if (context.canPop()) {
                            context.pop();
                          } else {
                            context.go('/profile');
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
                        'My Order',
                        style: AppTextStyles.headingBold20.copyWith(
                          color: AppColors.neutral900,
                          fontWeight: FontWeight.w800,
                          fontSize: 19,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.only(left: 48),
                    child: Text(
                      'Track and manage your recent purchases',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.neutral500,
                        fontSize: 12.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 3. Tab Navigation (Active vs Completed)
                  Container(
                    height: 42,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: AppColors.neutral200, width: 1.5),
                      ),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicatorColor: AppColors.primary,
                      indicatorWeight: 3,
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelColor: AppColors.primary,
                      unselectedLabelColor: AppColors.neutral500,
                      labelStyle: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 13.5,
                      ),
                      unselectedLabelStyle: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 13.5,
                      ),
                      tabs: [
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.inventory_2_outlined, size: 16),
                              const SizedBox(width: 6),
                              Text('Active (${activeOrders.length})'),
                            ],
                          ),
                        ),
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.check_circle_outline_rounded, size: 16),
                              const SizedBox(width: 6),
                              Text('Completed (${completedOrders.length})'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 4. Tab Content List
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Active Tab (Figma 246:2050)
                  _buildOrderList(
                    orders: activeOrders,
                    isCompletedTab: false,
                    emptyMessage: 'No active orders right now.',
                    cartProvider: cartProvider,
                  ),
                  // Completed Tab (Figma 246:3304)
                  _buildOrderList(
                    orders: completedOrders,
                    isCompletedTab: true,
                    emptyMessage: 'No completed orders yet.',
                    cartProvider: cartProvider,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: GrozzbyBottomNavBar(
        currentIndex: 4, // Profile / Account Tab
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

  Widget _buildOrderList({
    required List<Order> orders,
    required bool isCompletedTab,
    required String emptyMessage,
    required CartProvider cartProvider,
  }) {
    if (orders.isEmpty) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.receipt_long_outlined,
                size: 36,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              emptyMessage,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.neutral900,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Browse our fresh catalog to place your first order!',
              style: AppTextStyles.caption.copyWith(color: AppColors.neutral500),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Start Shopping'),
            ),
            const SizedBox(height: 30),
            const NeedHelpSupportCard(),
          ],
        ),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
      itemCount: orders.length + 1, // +1 for Support card
      itemBuilder: (context, index) {
        if (index == orders.length) {
          return const NeedHelpSupportCard();
        }

        final order = orders[index];
        return OrderCard(
          order: order,
          isCompletedTab: isCompletedTab,
          onBuyAgain: () {
            for (final item in order.items) {
              cartProvider.addItem(item.product, item.quantity);
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Items from #${order.orderNumber} added to cart!'),
                action: SnackBarAction(
                  label: 'View Cart',
                  textColor: AppColors.white,
                  onPressed: () => context.push('/cart'),
                ),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        );
      },
    );
  }
}
