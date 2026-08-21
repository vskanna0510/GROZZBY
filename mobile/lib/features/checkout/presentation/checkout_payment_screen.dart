import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../cart/data/cart_provider.dart';
import '../../shop/models/address.dart';
import 'widgets/checkout_top_bar.dart';
import 'widgets/checkout_stepper.dart';
import 'widgets/payment_method_tile.dart';

class CheckoutPaymentScreen extends StatefulWidget {
  final DeliveryAddress? address;

  const CheckoutPaymentScreen({super.key, this.address});

  @override
  State<CheckoutPaymentScreen> createState() => _CheckoutPaymentScreenState();
}

class _CheckoutPaymentScreenState extends State<CheckoutPaymentScreen> {
  String _selectedPaymentMethod = 'upi_gpay';
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _upiIdController = TextEditingController();

  final List<Map<String, String>> _savedCards = [
    {
      'id': 'card_1',
      'brand': 'HDFC Visa Debit Card',
      'last4': '4242',
      'expiry': '08/28',
      'logo': 'VISA',
    },
    {
      'id': 'card_2',
      'brand': 'ICICI Mastercard Credit Card',
      'last4': '8821',
      'expiry': '11/27',
      'logo': 'MASTERCARD',
    },
  ];

  @override
  void dispose() {
    _cvvController.dispose();
    _upiIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

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

            // Stepper (Payment active)
            const CheckoutStepper(
              currentStep: CheckoutStep.payment,
            ),

            // Navigation Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: AppColors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
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
                            'Payment Method',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0F172A),
                              fontFamily: 'Inter',
                            ),
                          ),
                          Text(
                            'Choose your preferred payment mode',
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
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFFDCFCE7)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.lock_outline_rounded, size: 12, color: Color(0xFF16A34A)),
                        SizedBox(width: 4),
                        Text(
                          '100% Secure',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF16A34A),
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Payment Options List
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // UPI Section
                    _buildSectionTitle('UPI / INSTANT PAYMENT'),
                    PaymentMethodTile(
                      title: 'Google Pay',
                      subtitle: 'Instant payment via Google Pay UPI',
                      leading: _buildIconBox(Icons.account_balance_wallet_rounded, const Color(0xFF4285F4)),
                      isSelected: _selectedPaymentMethod == 'upi_gpay',
                      onSelect: () => setState(() => _selectedPaymentMethod = 'upi_gpay'),
                    ),
                    PaymentMethodTile(
                      title: 'PhonePe UPI',
                      subtitle: 'Fast checkout with PhonePe',
                      leading: _buildIconBox(Icons.flash_on_rounded, const Color(0xFF5F259F)),
                      isSelected: _selectedPaymentMethod == 'upi_phonepe',
                      onSelect: () => setState(() => _selectedPaymentMethod = 'upi_phonepe'),
                    ),
                    PaymentMethodTile(
                      title: 'Paytm UPI',
                      subtitle: 'Pay directly via Paytm balance or UPI',
                      leading: _buildIconBox(Icons.payments_rounded, const Color(0xFF00B9F1)),
                      isSelected: _selectedPaymentMethod == 'upi_paytm',
                      onSelect: () => setState(() => _selectedPaymentMethod = 'upi_paytm'),
                    ),
                    PaymentMethodTile(
                      title: 'Add Other UPI ID',
                      subtitle: 'e.g. yourname@oksbi / user@upi',
                      leading: _buildIconBox(Icons.alternate_email_rounded, const Color(0xFF1E293B)),
                      isSelected: _selectedPaymentMethod == 'upi_custom',
                      onSelect: () => setState(() => _selectedPaymentMethod = 'upi_custom'),
                      extraContent: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFCBD5E1)),
                        ),
                        child: TextField(
                          controller: _upiIdController,
                          decoration: const InputDecoration(
                            hintText: 'Enter UPI ID (e.g. name@okaxis)',
                            hintStyle: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 10),
                          ),
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Saved Cards Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSectionTitle('SAVED CREDIT & DEBIT CARDS'),
                        InkWell(
                          onTap: () async {
                            final newCard = await context.push<Map<String, String>>('/checkout/payment/add-card');
                            if (newCard != null) {
                              setState(() {
                                _savedCards.add(newCard);
                                _selectedPaymentMethod = newCard['id']!;
                              });
                            }
                          },
                          child: const Text(
                            '+ Add New Card',
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
                    ..._savedCards.map((card) {
                      final cardId = card['id']!;
                      final isSelected = _selectedPaymentMethod == cardId;
                      return PaymentMethodTile(
                        title: card['brand']!,
                        subtitle: '•••• •••• •••• ${card['last4']} | Exp: ${card['expiry']}',
                        leading: _buildIconBox(Icons.credit_card_rounded, AppColors.primary),
                        isSelected: isSelected,
                        onSelect: () => setState(() => _selectedPaymentMethod = cardId),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            card['logo']!,
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              color: AppColors.primary,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                        extraContent: isSelected
                            ? Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 38,
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: const Color(0xFFCBD5E1)),
                                      ),
                                      child: TextField(
                                        controller: _cvvController,
                                        keyboardType: TextInputType.number,
                                        maxLength: 4,
                                        obscureText: true,
                                        decoration: const InputDecoration(
                                          hintText: 'Enter CVV',
                                          hintStyle: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                                          border: InputBorder.none,
                                          counterText: '',
                                          isDense: true,
                                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    '3 or 4 digits behind card',
                                    style: TextStyle(fontSize: 10, color: Color(0xFF64748B)),
                                  ),
                                ],
                              )
                            : null,
                      );
                    }),

                    const SizedBox(height: 16),

                    // Wallets & Other Section
                    _buildSectionTitle('WALLETS & NET BANKING'),
                    PaymentMethodTile(
                      title: 'Grozzby Wallet',
                      subtitle: '₹450.00 balance available',
                      leading: _buildIconBox(Icons.account_balance_wallet_outlined, const Color(0xFF16A34A)),
                      isSelected: _selectedPaymentMethod == 'wallet',
                      onSelect: () => setState(() => _selectedPaymentMethod = 'wallet'),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          '₹450.00',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF16A34A),
                          ),
                        ),
                      ),
                    ),
                    PaymentMethodTile(
                      title: 'Cash on Delivery (COD)',
                      subtitle: 'Pay with cash or UPI at delivery doorstep',
                      leading: _buildIconBox(Icons.local_shipping_outlined, const Color(0xFF64748B)),
                      isSelected: _selectedPaymentMethod == 'cod',
                      onSelect: () => setState(() => _selectedPaymentMethod = 'cod'),
                    ),
                  ],
                ),
              ),
            ),

            // Fixed Bottom Proceed Button
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
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Total Payable',
                          style: TextStyle(
                            fontSize: 10,
                            color: Color(0xFF64748B),
                            fontFamily: 'Inter',
                          ),
                        ),
                        Text(
                          '₹${cart.total.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to Review Screen with selected payment & address
                          context.push(
                            '/checkout/review',
                            extra: {
                              'address': widget.address,
                              'paymentMethod': _selectedPaymentMethod,
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Proceed to Review',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Inter',
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward_rounded, size: 18),
                          ],
                        ),
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: Color(0xFF64748B),
          letterSpacing: 0.6,
          fontFamily: 'Inter',
        ),
      ),
    );
  }

  Widget _buildIconBox(IconData icon, Color color) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, size: 20, color: color),
    );
  }
}
