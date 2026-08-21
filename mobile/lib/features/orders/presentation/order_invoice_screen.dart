import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../shared/widgets/grozzby_app_top_bar.dart';
import '../../../shared/widgets/grozzby_bottom_nav_bar.dart';
import '../../../shared/widgets/grozzby_logo.dart';
import '../../shop/data/shop_data.dart';
import '../../shop/models/order.dart';
import '../data/orders_provider.dart';

class OrderInvoiceScreen extends StatelessWidget {
  final Order? order;
  final String? orderId;

  const OrderInvoiceScreen({
    super.key,
    this.order,
    this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    final ordersProvider = context.watch<OrdersProvider>();
    final activeOrder = order ??
        (orderId != null ? ordersProvider.getOrderById(orderId!) : null) ??
        (ordersProvider.orders.isNotEmpty
            ? ordersProvider.orders.first
            : ShopData.sampleOrders.first);

    final dateFormat = DateFormat('MMM dd, yyyy');
    final formattedDate = dateFormat.format(activeOrder.createdAt);

    final invoiceNum = activeOrder.invoiceNumber.isNotEmpty
        ? activeOrder.invoiceNumber
        : 'INV-${activeOrder.orderNumber}';

    final savedAmount = activeOrder.discount > 0
        ? activeOrder.discount
        : ((activeOrder.subtotal - activeOrder.total) > 0
            ? (activeOrder.subtotal - activeOrder.total)
            : 0.0);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      bottomNavigationBar: GrozzbyBottomNavBar(
        currentIndex: 3, // Cart / Orders section
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

            // 2. Subheader Bar (Back Button, Title, Share Button)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: Colors.white,
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
                  const SizedBox(width: 12),
                  const Text(
                    'Invoice',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                      fontFamily: 'Inter',
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      Clipboard.setData(ClipboardData(
                        text: 'https://grozzby.app/invoice/$invoiceNum',
                      ));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Invoice link for $invoiceNum copied!'),
                          duration: const Duration(seconds: 1),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: const Padding(
                      padding: EdgeInsets.all(6),
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

            // 3. Scrollable Invoice Paper
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Invoice Card Container
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Large Grozzby Brand Logo
                          const GrozzbyLogo(height: 38),
                          const SizedBox(height: 16),

                          // Invoice Number, Date & Paid Pill
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Invoice #$invoiceNum',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF0F172A),
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    formattedDate,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF64748B),
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF0FDF4),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'Paid',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF16A34A),
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 22),

                          // Bill To Section
                          const Text(
                            'Bill To',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0F172A),
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            activeOrder.address.recipientName.isNotEmpty
                                ? activeOrder.address.recipientName
                                : 'Julian Thorne',
                            style: const TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0F172A),
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            activeOrder.address.streetAddress.isNotEmpty
                                ? '${activeOrder.address.streetAddress}${activeOrder.address.apartment.isNotEmpty ? ', ${activeOrder.address.apartment}' : ''}'
                                : '842 Aurora Blvd, Suite 4',
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: Color(0xFF64748B),
                              fontFamily: 'Inter',
                              height: 1.35,
                            ),
                          ),
                          Text(
                            activeOrder.address.city.isNotEmpty
                                ? '${activeOrder.address.city}, CA ${activeOrder.address.postalCode}, USA'
                                : 'San Francisco, CA 94110, USA',
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: Color(0xFF64748B),
                              fontFamily: 'Inter',
                              height: 1.35,
                            ),
                          ),
                          Text(
                            activeOrder.address.phoneNumber.isNotEmpty
                                ? activeOrder.address.phoneNumber
                                : '+1 (415) 555-0198',
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: Color(0xFF64748B),
                              fontFamily: 'Inter',
                              height: 1.35,
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Order Summary Section
                          const Text(
                            'Order Summary',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0F172A),
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Table Column Headers: ITEM | QTY | PRICE
                          const Row(
                            children: [
                              Expanded(
                                flex: 6,
                                child: Text(
                                  'ITEM',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF94A3B8),
                                    letterSpacing: 0.5,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  'QTY',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF94A3B8),
                                    letterSpacing: 0.5,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  'PRICE',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF94A3B8),
                                    letterSpacing: 0.5,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          // Dynamic Item Rows
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: activeOrder.items.length,
                            separatorBuilder: (_, _) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final item = activeOrder.items[index];
                              final productName = item.product.name;
                              final brand = item.product.brand;

                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Product Brand & Name
                                  Expanded(
                                    flex: 6,
                                    child: _buildItemNameRichText(brand, productName),
                                  ),
                                  // Quantity
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      '${item.quantity}',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF0F172A),
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ),
                                  // Price in ₹
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      '₹${item.totalPrice.toStringAsFixed(2)}',
                                      textAlign: TextAlign.right,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF0F172A),
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),

                          const SizedBox(height: 16),
                          const Divider(height: 1, color: Color(0xFFF1F5F9)),
                          const SizedBox(height: 16),

                          // Price Breakdown in ₹
                          _buildSummaryLine(
                            'Subtotal (${activeOrder.items.length} items)',
                            '₹${activeOrder.subtotal.toStringAsFixed(2)}',
                          ),
                          if (activeOrder.discount > 0) ...[
                            const SizedBox(height: 8),
                            _buildSummaryLine(
                              'Discount',
                              '- ₹${activeOrder.discount.toStringAsFixed(2)}',
                              isGreen: true,
                            ),
                          ],
                          const SizedBox(height: 8),
                          _buildSummaryLine(
                            'Shipping',
                            activeOrder.deliveryFee == 0
                                ? 'FREE'
                                : '₹${activeOrder.deliveryFee.toStringAsFixed(2)}',
                            isGreen: activeOrder.deliveryFee == 0,
                          ),
                          const SizedBox(height: 8),
                          _buildSummaryLine(
                            'Tax',
                            '₹${activeOrder.tax.toStringAsFixed(2)}',
                          ),

                          const SizedBox(height: 20),

                          // Total Paid Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Total Paid',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF0F172A),
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                  if (savedAmount > 0) ...[
                                    const SizedBox(height: 3),
                                    Text(
                                      'You saved ₹${savedAmount.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF16A34A),
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              Text(
                                '₹${activeOrder.total.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF0F172A),
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // Download Invoice Button (Vibrant Blue)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Downloading $invoiceNum.pdf...'),
                                    duration: const Duration(seconds: 2),
                                    behavior: SnackBarBehavior.floating,
                                    action: SnackBarAction(
                                      label: 'OPEN',
                                      textColor: Colors.white,
                                      onPressed: () {},
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.download_rounded, size: 20, color: Colors.white),
                              label: const Text(
                                'Download Invoice',
                                style: TextStyle(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  fontFamily: 'Inter',
                                ),
                              ),
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
                            ),
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

  Widget _buildItemNameRichText(String brand, String name) {
    if (brand.isNotEmpty && name.toLowerCase().startsWith(brand.toLowerCase())) {
      final remainder = name.substring(brand.length).trim();
      return RichText(
        text: TextSpan(
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF0F172A),
            fontFamily: 'Inter',
          ),
          children: [
            TextSpan(
              text: brand.toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            const TextSpan(text: ' '),
            TextSpan(
              text: remainder,
              style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF334155)),
            ),
          ],
        ),
      );
    } else if (brand.isNotEmpty) {
      return RichText(
        text: TextSpan(
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF0F172A),
            fontFamily: 'Inter',
          ),
          children: [
            TextSpan(
              text: brand.toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            const TextSpan(text: ' '),
            TextSpan(
              text: name,
              style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF334155)),
            ),
          ],
        ),
      );
    }

    return Text(
      name,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: Color(0xFF0F172A),
        fontFamily: 'Inter',
      ),
    );
  }

  Widget _buildSummaryLine(String label, String value, {bool isGreen = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF64748B),
            fontWeight: FontWeight.w500,
            fontFamily: 'Inter',
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: isGreen ? const Color(0xFF16A34A) : const Color(0xFF0F172A),
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }
}
