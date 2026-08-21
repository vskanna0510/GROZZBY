import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../cart/data/cart_provider.dart';
import 'widgets/checkout_top_bar.dart';
import 'widgets/credit_card_preview.dart';

class AddNewCardScreen extends StatefulWidget {
  const AddNewCardScreen({super.key});

  @override
  State<AddNewCardScreen> createState() => _AddNewCardScreenState();
}

class _AddNewCardScreenState extends State<AddNewCardScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardHolderController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  String _cardBrand = 'VISA';
  bool _saveCard = true;

  @override
  void initState() {
    super.initState();
    _cardNumberController.addListener(_updateCardBrand);
  }

  void _updateCardBrand() {
    final text = _cardNumberController.text.replaceAll(' ', '');
    setState(() {
      if (text.startsWith('4')) {
        _cardBrand = 'VISA';
      } else if (text.startsWith('51') || text.startsWith('52') || text.startsWith('53') || text.startsWith('54') || text.startsWith('55')) {
        _cardBrand = 'MASTERCARD';
      } else if (text.startsWith('60') || text.startsWith('65')) {
        _cardBrand = 'RUPAY';
      } else {
        _cardBrand = 'VISA';
      }
    });
  }

  @override
  void dispose() {
    _cardNumberController.removeListener(_updateCardBrand);
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  void _submitCard() {
    if (_formKey.currentState!.validate()) {
      final rawNumber = _cardNumberController.text.replaceAll(' ', '');
      final last4 = rawNumber.length >= 4 ? rawNumber.substring(rawNumber.length - 4) : '4242';

      final newCard = {
        'id': 'card_${DateTime.now().millisecondsSinceEpoch}',
        'brand': '$_cardBrand Card',
        'last4': last4,
        'expiry': _expiryController.text.trim(),
        'logo': _cardBrand,
        'holder': _cardHolderController.text.trim(),
      };

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Card ending in $last4 added successfully!'),
          backgroundColor: const Color(0xFF16A34A),
        ),
      );

      context.pop(newCard);
    }
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
                        'Add New Card',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0F172A),
                          fontFamily: 'Inter',
                        ),
                      ),
                      Text(
                        'Enter card details securely',
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

            // Form & Interactive Card Preview
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Interactive Card Preview
                      CreditCardPreview(
                        cardNumber: _cardNumberController.text,
                        cardHolder: _cardHolderController.text,
                        expiryDate: _expiryController.text,
                        cardBrand: _cardBrand,
                      ),
                      const SizedBox(height: 16),

                      // Card Details Container
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Card Number
                            _buildFieldLabel('CARD NUMBER'),
                            const SizedBox(height: 6),
                            _buildInputContainer(
                              child: TextFormField(
                                controller: _cardNumberController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(16),
                                  _CardNumberInputFormatter(),
                                ],
                                onChanged: (_) => setState(() {}),
                                validator: (v) => v != null && v.replaceAll(' ', '').length == 16
                                    ? null
                                    : 'Enter valid 16-digit card number',
                                decoration: const InputDecoration(
                                  hintText: '1234  5678  9012  3456',
                                  hintStyle: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                                ),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),

                            // Cardholder Name
                            _buildFieldLabel('CARDHOLDER NAME'),
                            const SizedBox(height: 6),
                            _buildInputContainer(
                              child: TextFormField(
                                controller: _cardHolderController,
                                textCapitalization: TextCapitalization.characters,
                                onChanged: (_) => setState(() {}),
                                validator: (v) => v != null && v.trim().isNotEmpty
                                    ? null
                                    : 'Enter cardholder name',
                                decoration: const InputDecoration(
                                  hintText: 'e.g. SUGU MARAN',
                                  hintStyle: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                                ),
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                              ),
                            ),
                            const SizedBox(height: 14),

                            // Expiry & CVV Row
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildFieldLabel('EXPIRY DATE'),
                                      const SizedBox(height: 6),
                                      _buildInputContainer(
                                        child: TextFormField(
                                          controller: _expiryController,
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.digitsOnly,
                                            LengthLimitingTextInputFormatter(4),
                                            _CardExpiryInputFormatter(),
                                          ],
                                          onChanged: (_) => setState(() {}),
                                          validator: (v) => v != null && v.contains('/') && v.length == 5
                                              ? null
                                              : 'MM/YY',
                                          decoration: const InputDecoration(
                                            hintText: 'MM/YY',
                                            hintStyle: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                                            border: InputBorder.none,
                                            isDense: true,
                                            contentPadding: EdgeInsets.symmetric(vertical: 12),
                                          ),
                                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildFieldLabel('CVV / CVC'),
                                      const SizedBox(height: 6),
                                      _buildInputContainer(
                                        child: TextFormField(
                                          controller: _cvvController,
                                          keyboardType: TextInputType.number,
                                          obscureText: true,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.digitsOnly,
                                            LengthLimitingTextInputFormatter(4),
                                          ],
                                          validator: (v) => v != null && v.length >= 3 ? null : '3-4 digits',
                                          decoration: const InputDecoration(
                                            hintText: '•••',
                                            hintStyle: TextStyle(fontSize: 14, color: Color(0xFF94A3B8)),
                                            border: InputBorder.none,
                                            isDense: true,
                                            contentPadding: EdgeInsets.symmetric(vertical: 12),
                                          ),
                                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Save Card Switch
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.shield_outlined, size: 16, color: Color(0xFF16A34A)),
                                    SizedBox(width: 8),
                                    Text(
                                      'Save card for faster checkouts',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF1E293B),
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ],
                                ),
                                Switch(
                                  value: _saveCard,
                                  activeThumbColor: AppColors.primary,
                                  onChanged: (v) => setState(() => _saveCard = v),
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
            ),

            // Fixed Bottom CTA
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
                    onPressed: _submitCard,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Add Card & Proceed',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                      ),
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

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w800,
        color: Color(0xFF64748B),
        letterSpacing: 0.5,
        fontFamily: 'Inter',
      ),
    );
  }

  Widget _buildInputContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: child,
    );
  }
}

class _CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text.replaceAll(' ', '');
    if (newValue.selection.baseOffset == 0) return newValue;

    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write('  ');
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}

class _CardExpiryInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text.replaceAll('/', '');
    if (newValue.selection.baseOffset == 0) return newValue;

    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex == 2 && nonZeroIndex != text.length) {
        buffer.write('/');
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}
