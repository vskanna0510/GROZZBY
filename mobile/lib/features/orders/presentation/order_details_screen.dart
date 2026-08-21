import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/grozzby_app_top_bar.dart';
import '../../../shared/widgets/grozzby_bottom_nav_bar.dart';
import '../../cart/data/cart_provider.dart';
import '../../shop/models/order.dart';
import '../data/orders_provider.dart';
import 'widgets/order_timeline_stepper.dart';
import 'widgets/shipping_info_card.dart';

class OrderDetailsScreen extends StatelessWidget {
  final Order? order;
  final String? orderId;

  const OrderDetailsScreen({
    super.key,
    this.order,
    this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    final ordersProvider = context.watch<OrdersProvider>();
    final cartProvider = context.read<CartProvider>();
    final activeOrder = order ??
        (orderId != null ? ordersProvider.getOrderById(orderId!) : null) ??
        ordersProvider.orders.first;

    final dateFormat = DateFormat('MMM dd, yyyy \'at\' hh:mm a');

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      bottomNavigationBar: GrozzbyBottomNavBar(
        currentIndex: 4,
        onTap: (idx) {
          if (idx == 0) context.go('/home');
          if (idx == 1) context.go('/categories');
          if (idx == 2) context.go('/search');
          if (idx == 3) context.go('/cart');
          if (idx == 4) context.go('/profile');
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Shared Brand Top Bar
            const GrozzbyAppTopBar(),

            // 2. Subheader matching Figma design exactly
            Container(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              color: AppColors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back Arrow + Order # with Copy + Status Badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
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
                            child: const Padding(
                              padding: EdgeInsets.all(4),
                              child: Icon(
                                Icons.arrow_back_rounded,
                                size: 20,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'ORDER #${activeOrder.orderNumber}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF64748B),
                              fontFamily: 'Inter',
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(width: 4),
                          InkWell(
                            onTap: () {
                              Clipboard.setData(ClipboardData(text: activeOrder.orderNumber));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Order #${activeOrder.orderNumber} copied!'),
                                  duration: const Duration(seconds: 1),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            child: const Icon(
                              Icons.copy_rounded,
                              size: 13,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),
                      // Status Badge (In Transit)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFFDBEAFE)),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.local_shipping_rounded, size: 12, color: Color(0xFF2563EB)),
                            SizedBox(width: 4),
                            Text(
                              'In Transit',
                              style: TextStyle(
                                color: Color(0xFF2563EB),
                                fontWeight: FontWeight.w800,
                                fontSize: 10,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'My Order Details',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0F172A),
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Placed on ${dateFormat.format(activeOrder.createdAt)}',
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: Color(0xFF64748B),
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),

            // 3. Scrollable Order Details Body
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 5-Step Horizontal Stepper (Figma 246:2384)
                    OrderTimelineStepper(status: activeOrder.status),

                    const SizedBox(height: 14),

                    // Courier Information Card (Figma 246:2384)
                    ShippingInfoCard(order: activeOrder),

                    const SizedBox(height: 14),

                    // 2 Action Buttons: Track Order & Download Invoice
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              context.push('/orders/${activeOrder.id}/track', extra: activeOrder);
                            },
                            icon: const Icon(Icons.location_on_rounded, size: 16, color: Colors.white),
                            label: const Text('Track Order'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2563EB),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, fontFamily: 'Inter'),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              context.push('/orders/${activeOrder.id}/invoice', extra: activeOrder);
                            },
                            icon: const Icon(Icons.download_rounded, size: 16, color: Color(0xFF0F172A)),
                            label: const Text('Download Invoice'),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: AppColors.white,
                              foregroundColor: const Color(0xFF0F172A),
                              side: const BorderSide(color: Color(0xFFE2E8F0), width: 1.2),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF0F172A), fontFamily: 'Inter'),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Ordered Items Breakdown List (Figma 246:2384)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: const [
                          BoxShadow(color: Color(0x04000000), blurRadius: 6, offset: Offset(0, 2)),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Items (${activeOrder.items.length})',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF0F172A),
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                ),
                              ),
                              InkWell(
                                onTap: () => context.push('/cart'),
                                child: const Text(
                                  'View All Items',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF2563EB),
                                    fontSize: 12,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: activeOrder.items.length,
                            separatorBuilder: (_, _) => const Divider(height: 20, color: Color(0xFFF1F5F9)),
                            itemBuilder: (context, index) {
                              final item = activeOrder.items[index];

                              return InkWell(
                                onTap: () {
                                  context.push('/product-details', extra: item.product);
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        width: 58,
                                        height: 58,
                                        color: const Color(0xFFF8FAFC),
                                        child: Image.network(
                                          item.product.imageUrl,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, _, _) => const Center(
                                            child: Icon(Icons.shopping_bag_outlined, color: Color(0xFF2563EB)),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.product.brand.toUpperCase(),
                                            style: const TextStyle(
                                              fontSize: 9,
                                              fontWeight: FontWeight.w800,
                                              color: Color(0xFF94A3B8),
                                              fontFamily: 'Inter',
                                            ),
                                          ),
                                          const SizedBox(height: 1),
                                          Text(
                                            item.product.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: Color(0xFF0F172A),
                                              fontSize: 12.5,
                                              fontFamily: 'Inter',
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            item.product.unit.isNotEmpty ? item.product.unit : 'Black • ANC Over Ear',
                                            style: const TextStyle(
                                              color: Color(0xFF64748B),
                                              fontSize: 10.5,
                                              fontFamily: 'Inter',
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '₹${item.product.price.toStringAsFixed(2)}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w800,
                                              color: Color(0xFF0F172A),
                                              fontSize: 13,
                                              fontFamily: 'Inter',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'Qty: ${item.quantity}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w700,
                                                color: Color(0xFF0F172A),
                                                fontSize: 11,
                                                fontFamily: 'Inter',
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            const Icon(Icons.chevron_right_rounded, size: 16, color: Color(0xFF94A3B8)),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF0FDF4),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: const Text(
                                            'Return Eligible\nTill Nov 5',
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              color: Color(0xFF16A34A),
                                              fontWeight: FontWeight.w700,
                                              fontSize: 8.5,
                                              height: 1.1,
                                              fontFamily: 'Inter',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Two side-by-side Cards: Delivery Address & Payment Method
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left: Delivery Address Card
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                              boxShadow: const [
                                BoxShadow(color: Color(0x04000000), blurRadius: 6, offset: Offset(0, 2)),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.location_on_rounded, size: 14, color: Color(0xFF16A34A)),
                                    SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        'Delivery Address',
                                        style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: Color(0xFF0F172A), fontFamily: 'Inter'),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF0FDF4),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'Home (Default)',
                                    style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.w700, color: Color(0xFF16A34A), fontFamily: 'Inter'),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  activeOrder.address.recipientName.isNotEmpty ? activeOrder.address.recipientName : 'Julian Thorne',
                                  style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: Color(0xFF0F172A), fontFamily: 'Inter'),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  activeOrder.address.streetAddress.isNotEmpty
                                      ? '${activeOrder.address.streetAddress}, ${activeOrder.address.apartment}\n${activeOrder.address.city}, CA ${activeOrder.address.postalCode},\nUSA\n${activeOrder.address.phoneNumber}'
                                      : '842 Aurora Blvd, Suite 4\nSan Francisco, CA 94110,\nUSA\n+1 (415) 555-0198',
                                  style: const TextStyle(fontSize: 9, color: Color(0xFF64748B), height: 1.35, fontFamily: 'Inter'),
                                ),
                                const SizedBox(height: 8),
                                InkWell(
                                  onTap: () => context.push('/profile/addresses'),
                                  child: const Text(
                                    'Change Address >',
                                    style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, color: Color(0xFF2563EB), fontFamily: 'Inter'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Right: Payment Method Card
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                              boxShadow: const [
                                BoxShadow(color: Color(0x04000000), blurRadius: 6, offset: Offset(0, 2)),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.credit_card_rounded, size: 14, color: Color(0xFF2563EB)),
                                    SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        'Payment Method',
                                        style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: Color(0xFF0F172A), fontFamily: 'Inter'),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF1E3A8A),
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                      child: const Text(
                                        'VISA',
                                        style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 0.5),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    const Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Visa Platinum', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: Color(0xFF0F172A), fontFamily: 'Inter')),
                                          Text('•••• 9012', style: TextStyle(fontSize: 8.5, color: Color(0xFF64748B), fontFamily: 'Inter')),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                const Row(
                                  children: [
                                    Icon(Icons.check_circle_rounded, size: 12, color: Color(0xFF16A34A)),
                                    SizedBox(width: 4),
                                    Text(
                                      'Paid Successfully',
                                      style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: Color(0xFF16A34A), fontFamily: 'Inter'),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 18),
                                InkWell(
                                  onTap: () => context.push('/profile/payments'),
                                  child: const Text(
                                    'Change Payment >',
                                    style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, color: Color(0xFF2563EB), fontFamily: 'Inter'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // Order Summary Breakdown Card (Figma 246:2384)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: const [
                          BoxShadow(color: Color(0x04000000), blurRadius: 6, offset: Offset(0, 2)),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Order Summary',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF0F172A),
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                ),
                              ),
                              InkWell(
                                onTap: () {},
                                child: const Text(
                                  'See Price Details',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF2563EB),
                                    fontSize: 12,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          _buildPriceRow('Subtotal (${activeOrder.items.length} items)', '₹${activeOrder.subtotal.toStringAsFixed(2)}'),
                          const SizedBox(height: 8),
                          _buildPriceRow('Discount', '- ₹${activeOrder.discount.toStringAsFixed(2)}', isDiscount: true),
                          const SizedBox(height: 8),
                          _buildPriceRow('Shipping', activeOrder.deliveryFee == 0 ? 'FREE' : '₹${activeOrder.deliveryFee.toStringAsFixed(2)}', isFree: activeOrder.deliveryFee == 0),
                          const SizedBox(height: 8),
                          _buildPriceRow('Tax', '₹${activeOrder.tax.toStringAsFixed(2)}'),
                          const SizedBox(height: 12),
                          const Divider(height: 1, color: Color(0xFFF1F5F9)),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Total Paid',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF0F172A),
                                      fontSize: 14,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                  if (activeOrder.discount > 0) ...[
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF0FDF4),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        'You saved ₹${activeOrder.discount.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          color: Color(0xFF16A34A),
                                          fontWeight: FontWeight.w800,
                                          fontSize: 9.5,
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              Text(
                                '₹${activeOrder.total.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 20,
                                  color: Color(0xFF0F172A),
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // 4. Three Trust Badges (Row of 3 cards matching Screenshot)
                    Row(
                      children: [
                        _buildTrustCard(
                          icon: Icons.shield_outlined,
                          title: 'Secure Payment',
                          subtitle: '100% Protected',
                        ),
                        const SizedBox(width: 8),
                        _buildTrustCard(
                          icon: Icons.replay_rounded,
                          title: 'Easy Returns',
                          subtitle: '7-Day Return Policy',
                        ),
                        const SizedBox(width: 8),
                        _buildTrustCard(
                          icon: Icons.workspace_premium_outlined,
                          title: 'Genuine Products',
                          subtitle: 'Quality Assured',
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // 5. Two Quick Action Cards (Buy Again & Rate Products)
                    Row(
                      children: [
                        // Left: Buy Again
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              for (final item in activeOrder.items) {
                                cartProvider.addItem(item.product);
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Items re-added to cart!'),
                                  backgroundColor: Color(0xFF2563EB),
                                  duration: Duration(seconds: 1),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                              context.push('/cart');
                            },
                            borderRadius: BorderRadius.circular(14),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF7ED),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: const Color(0xFFFFEDD5)),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(Icons.shopping_cart_rounded, size: 16, color: Color(0xFFF97316)),
                                  ),
                                  const SizedBox(width: 8),
                                  const Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Buy Again',
                                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF0F172A), fontFamily: 'Inter'),
                                        ),
                                        Text(
                                          'Buy your favorites again',
                                          style: TextStyle(fontSize: 8.5, color: Color(0xFF64748B), fontFamily: 'Inter'),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.chevron_right_rounded, size: 16, color: Color(0xFFF97316)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Right: Rate Products
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              _showRateProductsDialog(context, activeOrder);
                            },
                            borderRadius: BorderRadius.circular(14),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEFF6FF),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: const Color(0xFFDBEAFE)),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(Icons.star_outline_rounded, size: 16, color: Color(0xFF2563EB)),
                                  ),
                                  const SizedBox(width: 8),
                                  const Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Rate Products',
                                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF0F172A), fontFamily: 'Inter'),
                                        ),
                                        Text(
                                          'Rate & earn rewards',
                                          style: TextStyle(fontSize: 8.5, color: Color(0xFF64748B), fontFamily: 'Inter'),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.chevron_right_rounded, size: 16, color: Color(0xFF2563EB)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // 6. Need Help with Your Order Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: const [
                          BoxShadow(color: Color(0x04000000), blurRadius: 6, offset: Offset(0, 2)),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFEFF6FF),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.support_agent_rounded, size: 22, color: Color(0xFF2563EB)),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Need help with your order?',
                                      style: TextStyle(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF0F172A),
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      'Our support team is here to help you 24/7',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFF64748B),
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          const Divider(height: 1, color: Color(0xFFF1F5F9)),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildSupportAction(
                                context,
                                icon: Icons.chat_bubble_outline_rounded,
                                label: 'Live Chat',
                                onTap: () => context.push('/support'),
                              ),
                              _buildSupportAction(
                                context,
                                icon: Icons.phone_outlined,
                                label: 'Call Support',
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Calling Grozzby 24/7 Support: +1 (800) 476-9929...'),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                },
                              ),
                              _buildSupportAction(
                                context,
                                icon: Icons.mail_outline_rounded,
                                label: 'Email Support',
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Opening email support: support@grozzby.com'),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrustCard({required IconData icon, required String title, required String subtitle}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: const [
            BoxShadow(color: Color(0x04000000), blurRadius: 4, offset: Offset(0, 2)),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: const Color(0xFF16A34A)),
            const SizedBox(height: 6),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0F172A),
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 8.5,
                color: Color(0xFF64748B),
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportAction(BuildContext context, {required IconData icon, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            Icon(icon, size: 14, color: const Color(0xFF2563EB)),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2563EB),
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isDiscount = false, bool isFree = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF64748B),
            fontSize: 12,
            fontFamily: 'Inter',
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: isDiscount
                ? const Color(0xFF16A34A)
                : (isFree ? const Color(0xFF16A34A) : const Color(0xFF0F172A)),
            fontSize: 12.5,
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }

  void _showRateProductsDialog(BuildContext context, Order order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFCBD5E1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Rate Your Ordered Products',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
            ),
            const SizedBox(height: 6),
            const Text(
              'Share your feedback & earn up to 50 Grozzby Coins',
              style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (i) => const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(Icons.star_rounded, size: 34, color: Color(0xFFF59E0B)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Thank you! 50 Coins credited to your wallet.'),
                      backgroundColor: Color(0xFF16A34A),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'Submit Rating',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
