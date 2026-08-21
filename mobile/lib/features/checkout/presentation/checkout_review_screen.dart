import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../cart/data/cart_provider.dart';
import '../../orders/data/orders_provider.dart';
import '../../profile/data/addresses_provider.dart';
import '../../shop/models/address.dart';
import '../../shop/models/order.dart';
import 'widgets/checkout_top_bar.dart';
import 'widgets/checkout_stepper.dart';
import 'widgets/order_bill_summary.dart';

class CheckoutReviewScreen extends StatelessWidget {
  final DeliveryAddress? address;
  final String? paymentMethod;

  const CheckoutReviewScreen({
    super.key,
    this.address,
    this.paymentMethod,
  });

  String _formatPaymentMethod(String? method) {
    switch (method) {
      case 'upi_gpay':
        return 'Google Pay UPI';
      case 'upi_phonepe':
        return 'PhonePe UPI';
      case 'upi_paytm':
        return 'Paytm UPI';
      case 'wallet':
        return 'Grozzby Wallet (₹450.00)';
      case 'cod':
        return 'Cash on Delivery (COD)';
      default:
        if (method != null && method.startsWith('card_')) {
          return 'Debit / Credit Card (Verified)';
        }
        return 'Google Pay UPI';
    }
  }

  IconData _getPaymentIcon(String? method) {
    switch (method) {
      case 'upi_gpay':
      case 'upi_phonepe':
      case 'upi_paytm':
      case 'upi_custom':
        return Icons.flash_on_rounded;
      case 'wallet':
        return Icons.account_balance_wallet_rounded;
      case 'cod':
        return Icons.local_shipping_outlined;
      default:
        return Icons.credit_card_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final addressesProv = context.watch<AddressesProvider>();
    final selectedAddress = address ?? addressesProv.defaultAddress;
    final items = cart.itemList;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            CheckoutTopBar(
              cartCount: cart.totalItemCount,
              onLocationTap: () => context.push('/profile/addresses'),
            ),

            // Stepper (Review step active)
            const CheckoutStepper(
              currentStep: CheckoutStep.review,
            ),

            // Navigation Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: AppColors.white,
              child: Row(
                children: [
                  InkWell(
                    onTap: () => context.pop(),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(17),
                      ),
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        size: 18,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Review & Place Order',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0F172A),
                          fontFamily: 'Inter',
                        ),
                      ),
                      Text(
                        'Verify all order details before placing',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF64748B),
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Review Content List
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Delivery Address Snapshot Card
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.location_on_outlined, size: 18, color: AppColors.primary),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Delivery Address',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF0F172A),
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEFF6FF),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      selectedAddress.label.toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              InkWell(
                                onTap: () => context.pop(),
                                child: const Text(
                                  'Change',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${selectedAddress.recipientName} • ${selectedAddress.phoneNumber}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1E293B),
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            selectedAddress.fullAddress,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF64748B),
                              fontFamily: 'Inter',
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Payment Method Snapshot Card
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEFF6FF),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  _getPaymentIcon(paymentMethod),
                                  size: 18,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Payment Method',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF64748B),
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                  Text(
                                    _formatPaymentMethod(paymentMethod),
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF0F172A),
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () => context.pop(),
                            child: const Text(
                              'Change',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Delivery Estimate Strip
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FDF4),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFDCFCE7)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.electric_bolt_rounded, size: 20, color: Color(0xFF16A34A)),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Express Delivery in 15–20 Mins',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF16A34A),
                                    fontFamily: 'Inter',
                                  ),
                                ),
                                Text(
                                  'Delivery partner will leave package at doorstep (Contact-free)',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Color(0xFF15803D),
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Items List Preview
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ORDER ITEMS (${items.length})',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF64748B),
                              letterSpacing: 0.5,
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(height: 10),
                          ...items.map(
                            (item) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      item.product.imageUrl,
                                      width: 44,
                                      height: 44,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Container(
                                        width: 44,
                                        height: 44,
                                        color: const Color(0xFFF1F5F9),
                                        child: const Icon(Icons.shopping_bag_outlined, size: 20),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.product.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF0F172A),
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                        Text(
                                          'Qty: ${item.quantity}  •  ${item.product.unit}',
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color: Color(0xFF64748B),
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '₹${item.totalPrice.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF0F172A),
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Bill Summary
                    OrderBillSummary(
                      subtotal: cart.subtotal,
                      deliveryFee: cart.deliveryFee,
                      tax: cart.tax,
                      couponDiscount: cart.discountAmount,
                      appliedPromoCode: cart.appliedPromoCode,
                      total: cart.total,
                    ),
                  ],
                ),
              ),
            ),

            // Fixed Bottom Place Order CTA
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final orderNum = 'GRZ-${(10000 + DateTime.now().millisecondsSinceEpoch % 90000)}';
                      // Create Order Model
                      final order = Order(
                        id: orderNum,
                        orderNumber: orderNum,
                        createdAt: DateTime.now(),
                        status: OrderStatus.confirmed,
                        items: items
                            .map(
                              (e) => OrderItem(
                                product: e.product,
                                quantity: e.quantity,
                                unitPrice: e.product.price,
                              ),
                            )
                            .toList(),
                        subtotal: cart.subtotal,
                        deliveryFee: cart.deliveryFee,
                        discount: cart.discountAmount,
                        total: cart.total,
                        address: selectedAddress,
                        paymentMethod: _formatPaymentMethod(paymentMethod),
                        estimatedDelivery: '15–20 mins',
                        trackingSteps: [
                          TrackingStep(
                            title: 'Order Placed',
                            description: 'Your order has been received',
                            time: 'Just now',
                            isCompleted: true,
                          ),
                          TrackingStep(
                            title: 'Order Confirmed',
                            description: 'Store has accepted your order',
                            time: 'Just now',
                            isCompleted: true,
                            isCurrent: true,
                          ),
                          TrackingStep(
                            title: 'Packing Items',
                            description: 'Fresh groceries are being packed',
                            time: 'In 5 mins',
                            isCompleted: false,
                          ),
                          TrackingStep(
                            title: 'Out for Delivery',
                            description: 'Rider is on the way',
                            time: 'In 12 mins',
                            isCompleted: false,
                          ),
                          TrackingStep(
                            title: 'Delivered',
                            description: 'Enjoy your fresh products!',
                            time: 'In 20 mins',
                            isCompleted: false,
                          ),
                        ],
                      );

                      // Save Order to OrdersProvider
                      context.read<OrdersProvider>().addOrder(order);

                      // Clear Cart
                      cart.clear();

                      // Navigate to Order Success Screen
                      context.go('/order-success', extra: order);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF16A34A),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check_circle_outline_rounded, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Place Order  •  ₹${cart.total.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
