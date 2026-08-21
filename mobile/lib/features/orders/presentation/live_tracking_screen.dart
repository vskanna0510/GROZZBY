import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../shared/widgets/grozzby_app_top_bar.dart';
import '../../../shared/widgets/grozzby_bottom_nav_bar.dart';
import '../../shop/data/shop_data.dart';
import '../../shop/models/order.dart';
import '../data/orders_provider.dart';

class LiveTrackingScreen extends StatefulWidget {
  final Order? order;
  final String? orderId;

  const LiveTrackingScreen({
    super.key,
    this.order,
    this.orderId,
  });

  @override
  State<LiveTrackingScreen> createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends State<LiveTrackingScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _vehicleMoveController;
  bool _isExpanded = false;
  DateTime _lastUpdated = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Pulsing radar animation
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();

    // Smooth movement animation along the delivery route
    _vehicleMoveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _vehicleMoveController.dispose();
    super.dispose();
  }

  void _refreshTracking() {
    setState(() {
      _lastUpdated = DateTime.now();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('GPS Location updated in real-time!'),
        duration: Duration(milliseconds: 900),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ordersProvider = context.watch<OrdersProvider>();
    final activeOrder = widget.order ??
        (widget.orderId != null ? ordersProvider.getOrderById(widget.orderId!) : null) ??
        (ordersProvider.orders.isNotEmpty
            ? ordersProvider.orders.first
            : ShopData.sampleOrders.first);

    final courier = activeOrder.courier;
    final recipientAddress = activeOrder.address.streetAddress.isNotEmpty
        ? activeOrder.address.streetAddress
        : '842 Aurora Blvd';

    return Scaffold(
      backgroundColor: const Color(0xFFE8EEF5),
      bottomNavigationBar: GrozzbyBottomNavBar(
        currentIndex: 3, // Cart / Tracking section
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

            // 2. Interactive Map & Live Tracking Floating Elements
            Expanded(
              child: Stack(
                children: [
                  // Full Interactive mapcn.dev / CARTO Style Vector Map Canvas
                  Positioned.fill(
                    child: AnimatedBuilder(
                      animation: Listenable.merge([_pulseController, _vehicleMoveController]),
                      builder: (context, _) {
                        return CustomPaint(
                          painter: _MapcnTrackingPainter(
                            pulseValue: _pulseController.value,
                            progress: 0.18 + (_vehicleMoveController.value * 0.45),
                            destinationAddress: recipientAddress,
                          ),
                        );
                      },
                    ),
                  ),

                  // 3. Subheader Bar (Back Button, Title, Share Button)
                  Positioned(
                    top: 10,
                    left: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.96),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
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
                            borderRadius: BorderRadius.circular(20),
                            child: const Padding(
                              padding: EdgeInsets.all(4),
                              child: Icon(
                                Icons.arrow_back_rounded,
                                size: 22,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Live Tracking',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0F172A),
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDCFCE7),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF16A34A),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  'LIVE',
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF16A34A),
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: () {
                              Clipboard.setData(ClipboardData(
                                text: 'https://grozzby.app/orders/${activeOrder.id}/live-tracking',
                              ));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Live tracking link for #${activeOrder.orderNumber} copied!'),
                                  duration: const Duration(seconds: 1),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: const Padding(
                              padding: EdgeInsets.all(4),
                              child: Icon(
                                Icons.share_outlined,
                                size: 20,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 4. White Bottom Sliding Card (Exact Match to Screenshot)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x18000000),
                            blurRadius: 18,
                            offset: Offset(0, -6),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Grab Handle
                          Center(
                            child: GestureDetector(
                              onTap: () => setState(() => _isExpanded = !_isExpanded),
                              child: Container(
                                width: 42,
                                height: 4.5,
                                margin: const EdgeInsets.only(top: 10, bottom: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFCBD5E1),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // ETA & Distance Row
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Left: Arriving Today, Time, Window
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Arriving Today',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF64748B),
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        const Text(
                                          '12:45 PM',
                                          style: TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.w900,
                                            color: Color(0xFF0F172A),
                                            letterSpacing: -0.5,
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                        const Text(
                                          'Before 1:00 PM',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w800,
                                            color: Color(0xFF16A34A),
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                      ],
                                    ),

                                    // Right: Time Remaining, Distance, Refresh
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        const Text(
                                          '8 mins away',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w900,
                                            color: Color(0xFF2563EB),
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        const Text(
                                          '2.4 km remaining',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF64748B),
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        InkWell(
                                          onTap: _refreshTracking,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                'Updated ${DateFormat('hh:mm:ss a').format(_lastUpdated).toLowerCase() == DateFormat('hh:mm:ss a').format(DateTime.now()).toLowerCase() ? 'just now' : 'recently'}',
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  color: Color(0xFF94A3B8),
                                                  fontFamily: 'Inter',
                                                ),
                                              ),
                                              const SizedBox(width: 3),
                                              const Icon(Icons.refresh_rounded, size: 12, color: Color(0xFF94A3B8)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 12),

                                // 6-Segment Green Progress Indicator
                                Row(
                                  children: List.generate(6, (index) {
                                    final isFilled = index <= 3; // 4 green, 2 gray
                                    return Expanded(
                                      child: Container(
                                        height: 4,
                                        margin: EdgeInsets.only(right: index == 5 ? 0 : 5),
                                        decoration: BoxDecoration(
                                          color: isFilled ? const Color(0xFF16A34A) : const Color(0xFFE2E8F0),
                                          borderRadius: BorderRadius.circular(2),
                                        ),
                                      ),
                                    );
                                  }),
                                ),

                                const SizedBox(height: 8),

                                const Text(
                                  'Driver is on the way to your location',
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    color: Color(0xFF475569),
                                    fontFamily: 'Inter',
                                  ),
                                ),

                                const SizedBox(height: 14),

                                // Courier Driver Profile Card
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF8FAFC),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: const Color(0xFFE2E8F0)),
                                  ),
                                  child: Row(
                                    children: [
                                      // Driver Photo with Verified Tick
                                      Stack(
                                        alignment: Alignment.bottomRight,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(24),
                                            child: Container(
                                              width: 48,
                                              height: 48,
                                              color: const Color(0xFFE2E8F0),
                                              child: Image.network(
                                                'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300&auto=format&fit=crop&q=80',
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) => const Icon(
                                                  Icons.person_rounded,
                                                  size: 28,
                                                  color: Color(0xFF64748B),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 14,
                                            height: 14,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF2563EB),
                                              shape: BoxShape.circle,
                                              border: Border.all(color: Colors.white, width: 2),
                                            ),
                                            child: const Icon(Icons.check, size: 8, color: Colors.white),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(width: 12),

                                      // Driver Name, Rating & Vehicle
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  courier.driverName.isNotEmpty ? courier.driverName : 'Marcus Chen',
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w800,
                                                    color: Color(0xFF0F172A),
                                                    fontFamily: 'Inter',
                                                  ),
                                                ),
                                                const SizedBox(width: 4),
                                                const Icon(Icons.verified, size: 14, color: Color(0xFF2563EB)),
                                              ],
                                            ),
                                            const SizedBox(height: 2),
                                            Row(
                                              children: [
                                                const Icon(Icons.star_rounded, size: 14, color: Color(0xFFF59E0B)),
                                                const SizedBox(width: 2),
                                                Text(
                                                  '${courier.driverRating > 0 ? courier.driverRating : 4.9}',
                                                  style: const TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w800,
                                                    color: Color(0xFF0F172A),
                                                    fontFamily: 'Inter',
                                                  ),
                                                ),
                                                const SizedBox(width: 3),
                                                Text(
                                                  '(${courier.totalDeliveries > 0 ? NumberFormat('#,###').format(courier.totalDeliveries) : '1,240'} deliveries)',
                                                  style: const TextStyle(
                                                    fontSize: 10.5,
                                                    color: Color(0xFF64748B),
                                                    fontFamily: 'Inter',
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              courier.vehicleInfo.isNotEmpty ? courier.vehicleInfo : 'Electric Vehicle • Speaks English',
                                              style: const TextStyle(
                                                fontSize: 10.5,
                                                color: Color(0xFF64748B),
                                                fontFamily: 'Inter',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Actions: Chat & Call Buttons
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text('Opening live chat with driver ${courier.driverName.isNotEmpty ? courier.driverName : "Marcus"}...'),
                                                  duration: const Duration(seconds: 1),
                                                  behavior: SnackBarBehavior.floating,
                                                ),
                                              );
                                            },
                                            borderRadius: BorderRadius.circular(20),
                                            child: Container(
                                              width: 38,
                                              height: 38,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                                border: Border.all(color: const Color(0xFFE2E8F0)),
                                              ),
                                              child: const Icon(Icons.chat_bubble_outline_rounded, color: Color(0xFF334155), size: 18),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          InkWell(
                                            onTap: () {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text('Calling driver ${courier.driverName.isNotEmpty ? courier.driverName : "Marcus"} (${courier.driverPhone.isNotEmpty ? courier.driverPhone : "+1-415-555-0198"})...'),
                                                  duration: const Duration(seconds: 1),
                                                  behavior: SnackBarBehavior.floating,
                                                ),
                                              );
                                            },
                                            borderRadius: BorderRadius.circular(20),
                                            child: Container(
                                              width: 38,
                                              height: 38,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                                border: Border.all(color: const Color(0xFFE2E8F0)),
                                              ),
                                              child: const Icon(Icons.phone_outlined, color: Color(0xFF334155), size: 18),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 12),

                                // Contact Support Button (Solid Vibrant Blue)
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () => context.push('/support'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF0052CC),
                                      foregroundColor: Colors.white,
                                      elevation: 2,
                                      shadowColor: const Color(0xFF0052CC).withValues(alpha: 0.35),
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text(
                                      'Contact Support',
                                      style: TextStyle(
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 10),

                                // Security Footer Strip
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.lock_outline_rounded, size: 12, color: Color(0xFF16A34A)),
                                    SizedBox(width: 3),
                                    Text(
                                      'Secure Delivery',
                                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF16A34A), fontFamily: 'Inter'),
                                    ),
                                    SizedBox(width: 6),
                                    Text('•', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 10)),
                                    SizedBox(width: 6),
                                    Icon(Icons.gps_fixed_rounded, size: 12, color: Color(0xFF16A34A)),
                                    SizedBox(width: 3),
                                    Text(
                                      'Live GPS Tracking',
                                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF16A34A), fontFamily: 'Inter'),
                                    ),
                                    SizedBox(width: 6),
                                    Text('•', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 10)),
                                    SizedBox(width: 6),
                                    Icon(Icons.verified_outlined, size: 12, color: Color(0xFF16A34A)),
                                    SizedBox(width: 3),
                                    Text(
                                      'Verified Courier',
                                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF16A34A), fontFamily: 'Inter'),
                                    ),
                                  ],
                                ),

                                // Expandable Chevron to view order items in ₹
                                Center(
                                  child: IconButton(
                                    icon: Icon(
                                      _isExpanded ? Icons.keyboard_arrow_down_rounded : Icons.keyboard_arrow_up_rounded,
                                      color: const Color(0xFF64748B),
                                      size: 24,
                                    ),
                                    onPressed: () => setState(() => _isExpanded = !_isExpanded),
                                  ),
                                ),

                                // Expandable Details (Real Items & ₹ Rates)
                                if (_isExpanded) ...[
                                  const Divider(height: 1, color: Color(0xFFF1F5F9)),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Order #${activeOrder.orderNumber} Items',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w800,
                                          color: Color(0xFF0F172A),
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                      Text(
                                        'Total: ₹${activeOrder.total.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w900,
                                          color: Color(0xFF16A34A),
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  ...activeOrder.items.map((item) => Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 4),
                                        child: Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(6),
                                              child: Container(
                                                width: 32,
                                                height: 32,
                                                color: const Color(0xFFF1F5F9),
                                                child: Image.network(
                                                  item.product.imageUrl,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (c, e, s) => const Icon(Icons.shopping_bag_outlined, size: 16),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                item.product.name,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xFF334155),
                                                  fontFamily: 'Inter',
                                                ),
                                              ),
                                            ),
                                            Text(
                                              '${item.quantity}x  ₹${item.totalPrice.toStringAsFixed(2)}',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                                color: Color(0xFF0F172A),
                                                fontFamily: 'Inter',
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                ],
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
          ],
        ),
      ),
    );
  }
}

/// mapcn.dev & CARTO Positron inspired realistic NYC map painter
class _MapcnTrackingPainter extends CustomPainter {
  final double pulseValue;
  final double progress;
  final String destinationAddress;

  _MapcnTrackingPainter({
    required this.pulseValue,
    required this.progress,
    required this.destinationAddress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 1. Base Map Background
    final bgPaint = Paint()..color = const Color(0xFFF0F4F8);
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), bgPaint);

    // 2. East River Water Body on Right (Organic River Shoreline)
    final waterPaint = Paint()..color = const Color(0xFFBCE3FD);
    final waterPath = Path();
    waterPath.moveTo(w * 0.76, 0);
    waterPath.cubicTo(w * 0.88, h * 0.28, w * 0.58, h * 0.62, w * 0.82, h);
    waterPath.lineTo(w, h);
    waterPath.lineTo(w, 0);
    waterPath.close();
    canvas.drawPath(waterPath, waterPaint);

    // Hudson River snippet on left top
    final hudsonPath = Path();
    hudsonPath.moveTo(0, 0);
    hudsonPath.lineTo(w * 0.08, 0);
    hudsonPath.lineTo(0, h * 0.35);
    hudsonPath.close();
    canvas.drawPath(hudsonPath, waterPaint);

    // 3. Green Parks (Washington Sq, Central Park bottom)
    final parkPaint = Paint()..color = const Color(0xFFD4F7DC);

    // Washington Sq Park
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.18, h * 0.24, w * 0.32, h * 0.055),
        const Radius.circular(6),
      ),
      parkPaint,
    );

    // Union / Gramercy Park
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.44, h * 0.42, w * 0.18, h * 0.04),
        const Radius.circular(5),
      ),
      parkPaint,
    );

    // 4. City Street Grid (Clean White roads with subtle borders)
    final roadBorderPaint = Paint()
      ..color = const Color(0xFFD5DFEA)
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.square;

    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.square;

    // Major Avenues (vertical-ish)
    _drawRoad(canvas, Offset(w * 0.16, 0), Offset(w * 0.16, h * 0.75), roadBorderPaint, roadPaint);
    _drawRoad(canvas, Offset(w * 0.34, 0), Offset(w * 0.34, h * 0.75), roadBorderPaint, roadPaint);
    _drawRoad(canvas, Offset(w * 0.52, 0), Offset(w * 0.52, h * 0.75), roadBorderPaint, roadPaint);
    _drawRoad(canvas, Offset(w * 0.68, 0), Offset(w * 0.68, h * 0.45), roadBorderPaint, roadPaint);

    // Cross Streets (horizontal-ish)
    _drawRoad(canvas, Offset(0, h * 0.12), Offset(w * 0.8, h * 0.12), roadBorderPaint, roadPaint);
    _drawRoad(canvas, Offset(0, h * 0.22), Offset(w * 0.75, h * 0.22), roadBorderPaint, roadPaint);
    _drawRoad(canvas, Offset(0, h * 0.34), Offset(w * 0.65, h * 0.34), roadBorderPaint, roadPaint);
    _drawRoad(canvas, Offset(0, h * 0.46), Offset(w * 0.60, h * 0.46), roadBorderPaint, roadPaint);
    _drawRoad(canvas, Offset(0, h * 0.58), Offset(w * 0.64, h * 0.58), roadBorderPaint, roadPaint);

    // Brooklyn Bridge Line across river
    final bridgePaint = Paint()
      ..color = const Color(0xFFCBD5E1)
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(w * 0.20, h * 0.58), Offset(w * 0.58, h * 0.66), bridgePaint);

    // 5. Geographic Labels & Landmark Icons
    final textPainter = TextPainter(textDirection: ui.TextDirection.ltr);

    void drawLabel(String text, Offset pos, {bool isMajor = false}) {
      textPainter.text = TextSpan(
        text: text,
        style: TextStyle(
          color: isMajor ? const Color(0xFF334155) : const Color(0xFF94A3B8),
          fontSize: isMajor ? 10 : 8.5,
          fontWeight: isMajor ? FontWeight.w800 : FontWeight.w700,
          letterSpacing: 0.6,
          fontFamily: 'Inter',
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, pos);
    }

    drawLabel('TIMES SQUARE', Offset(w * 0.18, h * 0.12), isMajor: true);
    drawLabel('Washington\nSquare Park', Offset(w * 0.24, h * 0.24));
    drawLabel('SOHO', Offset(w * 0.05, h * 0.30), isMajor: true);
    drawLabel('EAST VILLAGE', Offset(w * 0.68, h * 0.28), isMajor: true);
    drawLabel('LOWER\nMANHATTAN', Offset(w * 0.03, h * 0.38));
    drawLabel('WILLIAMSBURG', Offset(w * 0.70, h * 0.50), isMajor: true);
    drawLabel('Brooklyn\nBridge', Offset(w * 0.12, h * 0.51));

    // Highway 495 Shield
    final shieldBg = Paint()..color = const Color(0xFF1E40AF);
    final shieldRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.09, h * 0.09, 26, 16),
      const Radius.circular(4),
    );
    canvas.drawRRect(shieldRect, shieldBg);
    textPainter.text = const TextSpan(
      text: '495',
      style: TextStyle(color: Colors.white, fontSize: 8.5, fontWeight: FontWeight.w900),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(w * 0.09 + 4, h * 0.09 + 2));

    // Empire State Building Icon Landmark
    final empCenter = Offset(w * 0.31, h * 0.16);
    final empPaint = Paint()..color = const Color(0xFF94A3B8);
    canvas.drawRect(Rect.fromCenter(center: empCenter, width: 14, height: 20), empPaint);
    canvas.drawLine(Offset(empCenter.dx, empCenter.dy - 10), Offset(empCenter.dx, empCenter.dy - 18), empPaint..strokeWidth = 2);
    textPainter.text = const TextSpan(
      text: 'Empire State\nBuilding',
      style: TextStyle(color: Color(0xFF64748B), fontSize: 7.5, fontWeight: FontWeight.w700, height: 1.1),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(empCenter.dx + 10, empCenter.dy - 10));

    // 6. Real-Time Delivery Route Polyline
    final pStart = Offset(w * 0.19, h * 0.46); // Lower Manhattan start
    final pTurn1 = Offset(w * 0.20, h * 0.44);
    final pTurn2 = Offset(w * 0.34, h * 0.44);
    final pTurn3 = Offset(w * 0.46, h * 0.31);
    final pTurn4 = Offset(w * 0.58, h * 0.31);
    final pTurn5 = Offset(w * 0.60, h * 0.27);
    final pTurn6 = Offset(w * 0.73, h * 0.19);
    final pDest = Offset(w * 0.72, h * 0.18); // Home Destination

    final routePoints = [pStart, pTurn1, pTurn2, pTurn3, pTurn4, pTurn5, pTurn6, pDest];

    final routePath = Path();
    routePath.moveTo(pStart.dx, pStart.dy);
    for (int i = 1; i < routePoints.length; i++) {
      routePath.lineTo(routePoints[i].dx, routePoints[i].dy);
    }

    // Outer glow for route
    final routeGlow = Paint()
      ..color = const Color(0xFF2563EB).withValues(alpha: 0.25)
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(routePath, routeGlow);

    // Core Solid Vibrant Blue Route
    final routeCore = Paint()
      ..color = const Color(0xFF2563EB)
      ..strokeWidth = 5.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(routePath, routeCore);

    // 7. Destination Marker & Callout Bubble (Top-Right)
    // Red teardrop pin with white home icon
    final pinCenter = pDest;
    final pinPaint = Paint()..color = const Color(0xFFEF4444);
    canvas.drawCircle(pinCenter, 13, pinPaint);
    final pinInner = Paint()..color = Colors.white;
    canvas.drawCircle(pinCenter, 10.5, pinInner);
    canvas.drawCircle(pinCenter, 8.5, pinPaint);

    // White home symbol inside red pin
    final homeIconPainter = TextPainter(
      text: const TextSpan(
        text: '⌂',
        style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
      ),
      textDirection: ui.TextDirection.ltr,
    );
    homeIconPainter.layout();
    homeIconPainter.paint(canvas, Offset(pinCenter.dx - 4.5, pinCenter.dy - 8.5));

    // Callout Bubble attached to Destination Pin (Figma Match)
    final bubbleCenter = Offset(pinCenter.dx - 10, pinCenter.dy - 34);
    final bubbleBg = Paint()..color = Colors.white;
    final bubbleRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: bubbleCenter, width: 140, height: 44),
      const Radius.circular(12),
    );
    // Bubble shadow
    canvas.drawRRect(
      bubbleRect.shift(const Offset(0, 3)),
      Paint()..color = Colors.black.withValues(alpha: 0.12),
    );
    canvas.drawRRect(bubbleRect, bubbleBg);

    // Green circle with white house inside bubble
    final greenCirclePaint = Paint()..color = const Color(0xFF16A34A);
    final greenCirclePos = Offset(bubbleCenter.dx - 48, bubbleCenter.dy);
    canvas.drawCircle(greenCirclePos, 14, greenCirclePaint);

    final greenHousePainter = TextPainter(
      text: const TextSpan(
        text: '⌂',
        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
      ),
      textDirection: ui.TextDirection.ltr,
    );
    greenHousePainter.layout();
    greenHousePainter.paint(canvas, Offset(greenCirclePos.dx - 5.5, greenCirclePos.dy - 10));

    // Bubble Text: "Home", "842 Aurora Blvd"
    textPainter.text = TextSpan(
      text: 'Home\n',
      style: const TextStyle(
        fontSize: 11.5,
        fontWeight: FontWeight.w900,
        color: Color(0xFF0F172A),
        fontFamily: 'Inter',
      ),
      children: [
        TextSpan(
          text: destinationAddress,
          style: const TextStyle(
            fontSize: 9.5,
            fontWeight: FontWeight.w600,
            color: Color(0xFF64748B),
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(bubbleCenter.dx - 26, bubbleCenter.dy - 12));

    // 8. Live Courier Vehicle Moving along Route Path
    // Compute current position along polyline using progress (0.0 to 1.0)
    final vehiclePos = _getPositionAlongPath(routePoints, progress);

    // Pulsing Radar Rings
    final pulse1 = 16 + (pulseValue * 18);
    final pulsePaint1 = Paint()
      ..color = const Color(0xFF2563EB).withValues(alpha: 0.35 * (1.0 - pulseValue))
      ..style = PaintingStyle.fill;
    canvas.drawCircle(vehiclePos, pulse1, pulsePaint1);

    final pulse2 = 12 + (pulseValue * 10);
    final pulsePaint2 = Paint()
      ..color = const Color(0xFF60A5FA).withValues(alpha: 0.45 * (1.0 - pulseValue))
      ..style = PaintingStyle.fill;
    canvas.drawCircle(vehiclePos, pulse2, pulsePaint2);

    // Blue Teardrop Pointer Marker for Delivery Vehicle
    final markerPaint = Paint()..color = const Color(0xFF2563EB);
    canvas.drawCircle(vehiclePos, 19, markerPaint);
    final markerInner = Paint()..color = Colors.white;
    canvas.drawCircle(vehiclePos, 16, markerInner);

    // Black delivery truck icon inside blue marker
    final truckPainter = TextPainter(
      text: const TextSpan(
        text: '🚚',
        style: TextStyle(fontSize: 14),
      ),
      textDirection: ui.TextDirection.ltr,
    );
    truckPainter.layout();
    truckPainter.paint(canvas, Offset(vehiclePos.dx - 8.5, vehiclePos.dy - 9));
  }

  Offset _getPositionAlongPath(List<Offset> points, double t) {
    if (points.isEmpty) return Offset.zero;
    if (points.length == 1) return points.first;

    // Calculate total length
    double totalLen = 0;
    final lengths = <double>[];
    for (int i = 0; i < points.length - 1; i++) {
      final segLen = (points[i + 1] - points[i]).distance;
      lengths.add(segLen);
      totalLen += segLen;
    }

    if (totalLen == 0) return points.first;

    final targetDist = t.clamp(0.0, 1.0) * totalLen;
    double accumulated = 0;

    for (int i = 0; i < lengths.length; i++) {
      if (accumulated + lengths[i] >= targetDist) {
        final segProgress = (targetDist - accumulated) / lengths[i];
        return Offset(
          points[i].dx + (points[i + 1].dx - points[i].dx) * segProgress,
          points[i].dy + (points[i + 1].dy - points[i].dy) * segProgress,
        );
      }
      accumulated += lengths[i];
    }

    return points.last;
  }

  void _drawRoad(Canvas canvas, Offset p1, Offset p2, Paint border, Paint road) {
    canvas.drawLine(p1, p2, border);
    canvas.drawLine(p1, p2, road);
  }

  @override
  bool shouldRepaint(covariant _MapcnTrackingPainter oldDelegate) {
    return oldDelegate.pulseValue != pulseValue ||
        oldDelegate.progress != progress ||
        oldDelegate.destinationAddress != destinationAddress;
  }
}
