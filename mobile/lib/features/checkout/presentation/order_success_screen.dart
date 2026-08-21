import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../shared/widgets/grozzby_app_top_bar.dart';
import '../../../shared/widgets/grozzby_bottom_nav_bar.dart';
import '../../orders/data/orders_provider.dart';
import '../../shop/data/shop_data.dart';
import '../../shop/models/order.dart';
import '../../shop/models/product.dart';

class OrderSuccessScreen extends StatelessWidget {
  final Order? order;

  const OrderSuccessScreen({super.key, this.order});

  @override
  Widget build(BuildContext context) {
    // Retrieve actual order or fallback to latest order in OrdersProvider
    final ordersProvider = context.watch<OrdersProvider>();
    final currentOrder = order ??
        (ordersProvider.orders.isNotEmpty
            ? ordersProvider.orders.first
            : ShopData.sampleOrders.first);

    final orderId = currentOrder.orderNumber.startsWith('#')
        ? currentOrder.orderNumber
        : '#${currentOrder.orderNumber}';
    final totalPaid = currentOrder.total;
    final subtotal = currentOrder.subtotal > 0 ? currentOrder.subtotal : totalPaid;
    final shipping = currentOrder.deliveryFee;
    final discount = currentOrder.discount;
    final orderItems = currentOrder.items.isNotEmpty
        ? currentOrder.items
        : ShopData.sampleOrders.first.items;
    final itemsCount = orderItems.length;

    final dateFormat = DateFormat('MMM dd, yyyy • hh:mm a');
    final formattedDate = dateFormat.format(currentOrder.createdAt);

    // Recommended products for "You May Also Like" in Indian Rupees (₹)
    final recommendedProducts = [
      Product(
        id: 'rec_1',
        name: 'Nike Air Max 270',
        categoryId: 'cat_shoes',
        categoryName: 'Shoes',
        imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500&auto=format&fit=crop&q=80',
        price: 1290.00,
        originalPrice: 1590.00,
        unit: '1 pair',
        rating: 4.8,
        reviewCount: 320,
        description: 'Iconic lifestyle sneakers featuring maximum cushioning and lightweight comfort.',
        isFeatured: true,
      ),
      Product(
        id: 'rec_2',
        name: 'Fogg Intense Perfume',
        categoryId: 'cat_beauty',
        categoryName: 'Beauty',
        imageUrl: 'https://images.unsplash.com/photo-1523293182086-7651a899d37f?w=500&auto=format&fit=crop&q=80',
        price: 290.00,
        originalPrice: 390.00,
        unit: '100 ml bottle',
        rating: 4.7,
        reviewCount: 180,
        description: 'Long-lasting eau de parfum fragrance with exotic oriental undertones.',
        isFeatured: true,
      ),
      Product(
        id: 'rec_3',
        name: 'Ray-Ban Classic Aviator',
        categoryId: 'cat_accessories',
        categoryName: 'Accessories',
        imageUrl: 'https://images.unsplash.com/photo-1511499767150-a48a237f0083?w=500&auto=format&fit=crop&q=80',
        price: 990.00,
        originalPrice: 1290.00,
        unit: '1 piece',
        rating: 4.9,
        reviewCount: 240,
        description: 'Timeless pilot style sunglasses with 100% UV protection and polarized lenses.',
        isFeatured: true,
      ),
      Product(
        id: 'rec_4',
        name: 'Fresh Organic Hass Avocados',
        categoryId: 'cat_fruits_veggies',
        categoryName: 'Fruits & Veggies',
        imageUrl: 'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?w=500&auto=format&fit=crop&q=80',
        price: 149.00,
        originalPrice: 199.00,
        unit: '3 pcs pack',
        rating: 4.9,
        reviewCount: 142,
        description: 'Creamy, rich and naturally grown organic avocados packed with healthy fats.',
        isFeatured: true,
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      bottomNavigationBar: GrozzbyBottomNavBar(
        currentIndex: 3, // Cart / Checkout active tab
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
      body: SafeArea(
        child: Column(
          children: [
            // 1. Shared Brand Top Bar
            const GrozzbyAppTopBar(),

            // 2. Main Order Confirmation Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Column(
                  children: [
                    // --- SECTION 1: Celebration & Confirmation Header ---
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Decorative Confetti Shapes
                        Positioned(
                          left: 20,
                          top: 10,
                          child: Transform.rotate(
                            angle: 0.78, // ~45 deg diamond
                            child: Container(
                              width: 9,
                              height: 9,
                              decoration: const BoxDecoration(color: Color(0xFFF59E0B)),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 45,
                          bottom: 25,
                          child: Container(
                            width: 7,
                            height: 7,
                            decoration: const BoxDecoration(
                              color: Color(0xFF93C5FD),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 35,
                          top: 15,
                          child: Container(
                            width: 7,
                            height: 7,
                            decoration: const BoxDecoration(
                              color: Color(0xFF34D399),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 15,
                          bottom: 20,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(color: Color(0xFF60A5FA)),
                          ),
                        ),

                        // Glowing Radiant Golden Checkmark Circle
                        Container(
                          width: 84,
                          height: 84,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF3C7),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFF59E0B).withValues(alpha: 0.25),
                                blurRadius: 18,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Container(
                              width: 66,
                              height: 66,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Color(0xFFFBBF24), Color(0xFFF59E0B)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check_rounded,
                                size: 38,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Title & Subtitle
                    const Text(
                      'Your Order is Confirmed!',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "We've sent a confirmation email to your inbox.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12.5,
                        color: Color(0xFF64748B),
                        fontFamily: 'Inter',
                      ),
                    ),

                    const SizedBox(height: 18),

                    // --- SECTION 2: Order Meta Info Card (2x2 Grid) ---
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Order ID with Copy Action
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'ORDER ID',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF94A3B8),
                                      letterSpacing: 0.5,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Row(
                                    children: [
                                      Text(
                                        orderId,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w900,
                                          color: Color(0xFF0F172A),
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      InkWell(
                                        onTap: () {
                                          Clipboard.setData(ClipboardData(text: orderId));
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('$orderId copied to clipboard!'),
                                              duration: const Duration(seconds: 1),
                                              behavior: SnackBarBehavior.floating,
                                            ),
                                          );
                                        },
                                        child: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.copy_rounded, size: 13, color: Color(0xFF2563EB)),
                                            SizedBox(width: 2),
                                            Text(
                                              'Copy',
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w700,
                                                color: Color(0xFF2563EB),
                                                fontFamily: 'Inter',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              // Payment Method
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text(
                                    'PAYMENT METHOD',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF94A3B8),
                                      letterSpacing: 0.5,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: currentOrder.paymentMethod.toLowerCase().contains('upi')
                                              ? const Color(0xFF16A34A)
                                              : (currentOrder.paymentMethod.toLowerCase().contains('cod')
                                                  ? const Color(0xFFEA580C)
                                                  : const Color(0xFF1E3A8A)),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          currentOrder.paymentMethod.toLowerCase().contains('upi')
                                              ? 'UPI'
                                              : (currentOrder.paymentMethod.toLowerCase().contains('cod') ? 'COD' : 'VISA'),
                                          style: const TextStyle(
                                            fontSize: 9,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.white,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        currentOrder.paymentMethod.isNotEmpty
                                            ? currentOrder.paymentMethod
                                            : 'Visa **** 4242',
                                        style: const TextStyle(
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w800,
                                          color: Color(0xFF0F172A),
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Divider(height: 1, color: Color(0xFFF1F5F9)),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // Placed On Date
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'PLACED ON',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF94A3B8),
                                      letterSpacing: 0.5,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Row(
                                    children: [
                                      const Icon(Icons.calendar_today_outlined, size: 13, color: Color(0xFF64748B)),
                                      const SizedBox(width: 5),
                                      Text(
                                        formattedDate,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF334155),
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              // Total Paid (₹ Rupees)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text(
                                    'TOTAL PAID',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF94A3B8),
                                      letterSpacing: 0.5,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '₹${totalPaid.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF16A34A),
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

                    const SizedBox(height: 14),

                    // --- SECTION 3: 4-Step Order Status Stepper Card ---
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        children: [
                          // Stepper Icons and Connectors Row
                          Row(
                            children: [
                              _buildStepCircle(
                                icon: Icons.check_rounded,
                                isActive: true,
                                isCompleted: true,
                              ),
                              _buildConnectorLine(isActive: true),
                              _buildStepCircle(
                                icon: Icons.inventory_2_rounded,
                                isActive: true,
                                isCompleted: false,
                              ),
                              _buildConnectorLine(isActive: false),
                              _buildStepCircle(
                                icon: Icons.local_shipping_outlined,
                                isActive: false,
                                isCompleted: false,
                              ),
                              _buildConnectorLine(isActive: false),
                              _buildStepCircle(
                                icon: Icons.home_outlined,
                                isActive: false,
                                isCompleted: false,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Stepper Labels & Subtext Row
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Order Confirmed',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF0F172A),
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      DateFormat('MMM dd, hh:mm a').format(currentOrder.createdAt),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 8.5, color: Color(0xFF94A3B8), fontFamily: 'Inter'),
                                    ),
                                  ],
                                ),
                              ),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Preparing Order',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF0F172A),
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      "We're packing your items",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 8.5, color: Color(0xFF94A3B8), fontFamily: 'Inter'),
                                    ),
                                  ],
                                ),
                              ),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Shipped',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF64748B),
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      "You'll receive an update soon",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 8.5, color: Color(0xFF94A3B8), fontFamily: 'Inter'),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Delivered',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF64748B),
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      currentOrder.estimatedDelivery.isNotEmpty
                                          ? currentOrder.estimatedDelivery
                                          : 'Expected Today',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 8.5, color: Color(0xFF94A3B8), fontFamily: 'Inter'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // --- SECTION 4: Express Delivery Parcel Card ---
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Parcel Box Photo
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              width: 105,
                              height: 115,
                              color: const Color(0xFFF1F5F9),
                              child: Image.asset(
                                'assets/figma_assets/figma_121_247.png',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Image.network(
                                  'https://images.unsplash.com/photo-1549465220-1a8b9238cd48?w=500&auto=format&fit=crop&q=80',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          // Delivery Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFFEF3C7),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.local_shipping_rounded, size: 14, color: Color(0xFFD97706)),
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        'Arriving via ${currentOrder.courier.name}',
                                        style: const TextStyle(
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w800,
                                          color: Color(0xFF0F172A),
                                          fontFamily: 'Inter',
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFEDD5),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Text(
                                        'FAST',
                                        style: TextStyle(
                                          fontSize: 8.5,
                                          fontWeight: FontWeight.w900,
                                          color: Color(0xFFD97706),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  'Estimated Delivery',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF94A3B8),
                                    fontFamily: 'Inter',
                                  ),
                                ),
                                const SizedBox(height: 1),
                                Text(
                                  currentOrder.estimatedDelivery.isNotEmpty
                                      ? currentOrder.estimatedDelivery
                                      : 'Tomorrow, Oct 24',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF16A34A),
                                    fontFamily: 'Inter',
                                  ),
                                ),
                                const SizedBox(height: 2),
                                const Row(
                                  children: [
                                    Icon(Icons.access_time_rounded, size: 12, color: Color(0xFF64748B)),
                                    SizedBox(width: 4),
                                    Text(
                                      'Before 8 PM',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFF64748B),
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () => context.push('/order-tracking', extra: currentOrder),
                                      child: Text(
                                        'Tracking ID: ${currentOrder.courier.trackingId}',
                                        style: const TextStyle(
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF2563EB),
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                    ),
                                    const Row(
                                      children: [
                                        Icon(Icons.verified_user_outlined, size: 12, color: Color(0xFF16A34A)),
                                        SizedBox(width: 3),
                                        Text(
                                          'Secured & Insured',
                                          style: TextStyle(
                                            fontSize: 9.5,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF16A34A),
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
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // --- SECTION 5: Order Summary Card (Real Item Thumbnails + Price Table in ₹) ---
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    'Order Summary',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF0F172A),
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '($itemsCount items)',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF64748B),
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ],
                              ),
                              InkWell(
                                onTap: () => context.push('/orders/${currentOrder.id}', extra: currentOrder),
                                child: const Row(
                                  children: [
                                    Text(
                                      'View Details',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF2563EB),
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                    SizedBox(width: 2),
                                    Icon(Icons.chevron_right_rounded, size: 16, color: Color(0xFF2563EB)),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 14),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Dynamic Product Thumbnails Grid from real order items
                              SizedBox(
                                width: 96,
                                height: 96,
                                child: Wrap(
                                  spacing: 6,
                                  runSpacing: 6,
                                  children: orderItems.take(4).map((item) {
                                    return _buildThumbnail(item.product.imageUrl);
                                  }).toList(),
                                ),
                              ),

                              const SizedBox(width: 14),

                              // Real Price Breakdown Table in ₹
                              Expanded(
                                child: Column(
                                  children: [
                                    _buildBreakdownRow('Subtotal', '₹${subtotal.toStringAsFixed(2)}'),
                                    const SizedBox(height: 5),
                                    _buildBreakdownRow(
                                      'Shipping',
                                      shipping == 0 ? 'FREE' : '₹${shipping.toStringAsFixed(2)}',
                                      isGreen: shipping == 0,
                                    ),
                                    if (discount > 0) ...[
                                      const SizedBox(height: 5),
                                      _buildBreakdownRow('Discount (PROMO)', '-₹${discount.toStringAsFixed(2)}', isGreen: true),
                                    ],
                                    const Padding(
                                      padding: EdgeInsets.symmetric(vertical: 8),
                                      child: Divider(height: 1, color: Color(0xFFF1F5F9)),
                                    ),
                                    _buildBreakdownRow('Total Paid', '₹${totalPaid.toStringAsFixed(2)}', isBold: true),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // --- SECTION 6: 4 Quick Action Buttons ---
                    Row(
                      children: [
                        _buildQuickActionCard(
                          icon: Icons.description_outlined,
                          iconColor: const Color(0xFF2563EB),
                          bgColor: const Color(0xFFEFF6FF),
                          title: 'Download\nInvoice',
                          onTap: () => context.push('/invoice', extra: currentOrder),
                        ),
                        const SizedBox(width: 8),
                        _buildQuickActionCard(
                          icon: Icons.share_outlined,
                          iconColor: const Color(0xFF16A34A),
                          bgColor: const Color(0xFFF0FDF4),
                          title: 'Share\nOrder',
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: 'https://grozzby.app/orders/${currentOrder.id}'));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Order link copied to clipboard!'),
                                duration: Duration(seconds: 1),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                        _buildQuickActionCard(
                          icon: Icons.copy_rounded,
                          iconColor: const Color(0xFF7C3AED),
                          bgColor: const Color(0xFFFAF5FF),
                          title: 'Copy\nOrder ID',
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: orderId));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('$orderId copied to clipboard!'),
                                duration: const Duration(seconds: 1),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                        _buildQuickActionCard(
                          icon: Icons.chat_bubble_outline_rounded,
                          iconColor: const Color(0xFFEA580C),
                          bgColor: const Color(0xFFFFF7ED),
                          title: 'Need\nHelp?',
                          onTap: () => context.push('/support'),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // --- SECTION 7: Trust Badges (3 items) ---
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFF1F5F9)),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.shield_outlined, size: 16, color: Color(0xFF16A34A)),
                              SizedBox(width: 5),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Secure Payment', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF0F172A), fontFamily: 'Inter')),
                                  Text('100% Protected', style: TextStyle(fontSize: 8.5, color: Color(0xFF64748B), fontFamily: 'Inter')),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.replay_rounded, size: 16, color: Color(0xFF2563EB)),
                              SizedBox(width: 5),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Easy Returns', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF0F172A), fontFamily: 'Inter')),
                                  Text('7-Day Return Policy', style: TextStyle(fontSize: 8.5, color: Color(0xFF64748B), fontFamily: 'Inter')),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.verified_outlined, size: 16, color: Color(0xFF16A34A)),
                              SizedBox(width: 5),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Genuine Products', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF0F172A), fontFamily: 'Inter')),
                                  Text('Quality Assured', style: TextStyle(fontSize: 8.5, color: Color(0xFF64748B), fontFamily: 'Inter')),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // --- SECTION 8: "You May Also Like" Product Carousel in ₹ ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'You May Also Like',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F172A),
                            fontFamily: 'Inter',
                          ),
                        ),
                        InkWell(
                          onTap: () => context.push('/categories'),
                          child: const Text(
                            'View All',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF2563EB),
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    SizedBox(
                      height: 195,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: recommendedProducts.length,
                        itemBuilder: (context, index) {
                          final prod = recommendedProducts[index];
                          return Container(
                            width: 145,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: InkWell(
                              onTap: () => context.push('/product-details', extra: prod),
                              borderRadius: BorderRadius.circular(14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                                        child: Container(
                                          height: 110,
                                          width: double.infinity,
                                          color: const Color(0xFFF8FAFC),
                                          child: Image.network(
                                            prod.imageUrl,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) => const Center(
                                              child: Icon(Icons.shopping_bag_outlined, color: Color(0xFF94A3B8)),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 6,
                                        right: 6,
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withValues(alpha: 0.9),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(Icons.favorite_border_rounded, size: 14, color: Color(0xFF64748B)),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          prod.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF0F172A),
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '₹${prod.price.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w900,
                                            color: Color(0xFF0F172A),
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    // --- SECTION 9: Secondary Trust Strip ---
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.verified_user_outlined, size: 14, color: Color(0xFF16A34A)),
                              SizedBox(width: 4),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Secure Checkout', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Color(0xFF334155), fontFamily: 'Inter')),
                                  Text('256-bit SSL Encryption', style: TextStyle(fontSize: 7.5, color: Color(0xFF64748B), fontFamily: 'Inter')),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.replay_rounded, size: 14, color: Color(0xFF16A34A)),
                              SizedBox(width: 4),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Easy Returns', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Color(0xFF334155), fontFamily: 'Inter')),
                                  Text('7-day Return Policy', style: TextStyle(fontSize: 7.5, color: Color(0xFF64748B), fontFamily: 'Inter')),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.check_circle_outline_rounded, size: 14, color: Color(0xFF16A34A)),
                              SizedBox(width: 4),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('100% Authentic', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Color(0xFF334155), fontFamily: 'Inter')),
                                  Text('Genuine Products', style: TextStyle(fontSize: 7.5, color: Color(0xFF64748B), fontFamily: 'Inter')),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // --- SECTION 10: Full Width "Track Order" Button ---
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          context.push('/orders/${currentOrder.id}', extra: currentOrder);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 3,
                          shadowColor: const Color(0xFF2563EB).withValues(alpha: 0.35),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Track Order',
                              style: TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                fontFamily: 'Inter',
                              ),
                            ),
                            SizedBox(width: 6),
                            Icon(Icons.chevron_right_rounded, size: 18, color: Colors.white),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Continue Shopping Text Link
                    TextButton(
                      onPressed: () => context.go('/home'),
                      child: const Text(
                        'Continue Shopping',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF64748B),
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepCircle({required IconData icon, required bool isActive, required bool isCompleted}) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF2563EB) : const Color(0xFFF1F5F9),
        shape: BoxShape.circle,
        border: Border.all(
          color: isActive ? const Color(0xFF2563EB) : const Color(0xFFCBD5E1),
          width: 1.5,
        ),
      ),
      child: Center(
        child: Icon(
          icon,
          size: 14,
          color: isActive ? Colors.white : const Color(0xFF94A3B8),
        ),
      ),
    );
  }

  Widget _buildConnectorLine({required bool isActive}) {
    return Expanded(
      child: Container(
        height: 2,
        color: isActive ? const Color(0xFF2563EB) : const Color(0xFFCBD5E1),
      ),
    );
  }

  Widget _buildThumbnail(String url) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 44,
        height: 44,
        color: const Color(0xFFF8FAFC),
        child: Image.network(
          url,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.shopping_bag_outlined, size: 16, color: Color(0xFF94A3B8)),
        ),
      ),
    );
  }

  Widget _buildBreakdownRow(String label, String value, {bool isBold = false, bool isGreen = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isBold ? 14 : 11.5,
            fontWeight: isBold ? FontWeight.w900 : FontWeight.w500,
            color: isBold ? const Color(0xFF0F172A) : const Color(0xFF64748B),
            fontFamily: 'Inter',
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 15 : 12,
            fontWeight: isBold ? FontWeight.w900 : FontWeight.w700,
            color: isGreen
                ? const Color(0xFF16A34A)
                : (isBold ? const Color(0xFF0F172A) : const Color(0xFF334155)),
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 16, color: iconColor),
              ),
              const SizedBox(height: 6),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF334155),
                  fontFamily: 'Inter',
                  height: 1.15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
