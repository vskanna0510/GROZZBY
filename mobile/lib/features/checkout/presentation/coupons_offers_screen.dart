import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../cart/data/cart_provider.dart';
import 'widgets/checkout_top_bar.dart';

class CouponsOffersScreen extends StatefulWidget {
  const CouponsOffersScreen({super.key});

  @override
  State<CouponsOffersScreen> createState() => _CouponsOffersScreenState();
}

class _CouponsOffersScreenState extends State<CouponsOffersScreen> {
  final TextEditingController _codeController = TextEditingController();

  final List<Map<String, dynamic>> _coupons = [
    {
      'code': 'NEWUSER15',
      'tag': 'FEATURED OFFER',
      'title': 'Save ₹100 on your first order',
      'expiry': 'Expiry: 31 Dec 2024',
      'terms': 'T&C Apply',
      'discount': 100.0,
      'isFeatured': true,
      'status': 'apply',
    },
    {
      'code': 'FREESHIP',
      'tag': null,
      'title': 'Free delivery on orders above ₹500',
      'expiry': 'Valid till 15 Nov 2024',
      'terms': 'T&C Apply',
      'discount': 40.0,
      'isFeatured': false,
      'status': 'collect',
    },
    {
      'code': 'GROZZY20',
      'tag': null,
      'title': '20% off on first grocery order',
      'expiry': 'Valid till 25 Dec 2024',
      'terms': 'T&C Apply',
      'discount': 60.0,
      'isFeatured': false,
      'status': 'collect',
    },
    {
      'code': 'FESTIVE50',
      'tag': null,
      'title': 'Flat ₹50 off on electronics',
      'expiry': 'Limited time offer',
      'terms': 'T&C Apply',
      'discount': 50.0,
      'isFeatured': false,
      'status': 'claimed',
    },
    {
      'code': 'VISAPAY',
      'tag': null,
      'title': '10% Cashback on Visa Credit Cards',
      'expiry': 'Minimum order ₹1000',
      'terms': 'Details',
      'discount': 100.0,
      'isFeatured': false,
      'status': 'collect',
    },
  ];

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _applyCoupon(String code, double discount) {
    final cart = context.read<CartProvider>();
    cart.applyCoupon(code, discount);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Coupon "$code" applied! ₹${discount.toStringAsFixed(0)} saved'),
        backgroundColor: const Color(0xFF10B981),
      ),
    );
    context.pop();
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: AppColors.white,
              child: Row(
                children: [
                  InkWell(
                    onTap: () => context.pop(),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.arrow_back_rounded, size: 18, color: Color(0xFF1E293B)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Coupons & Offers',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFE2E8F0)),

            // Coupon Form & List
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16),
                children: [
                  // Enter Coupon Code Box
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ENTER COUPON CODE',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF64748B),
                            letterSpacing: 0.5,
                            fontFamily: 'Inter',
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8FAFC),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: const Color(0xFFCBD5E1)),
                                ),
                                child: TextField(
                                  controller: _codeController,
                                  textCapitalization: TextCapitalization.characters,
                                  decoration: const InputDecoration(
                                    hintText: 'E.G. SAVE50',
                                    hintStyle: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () {
                                final val = _codeController.text.trim();
                                if (val.isNotEmpty) {
                                  _applyCoupon(val, 50.0);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2563EB),
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              child: const Text('Apply', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Available Coupons Section
                  const Text(
                    'Available Coupons',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 12),

                  ..._coupons.map((coupon) {
                    final isFeatured = coupon['isFeatured'] == true;
                    final status = coupon['status'] as String;

                    if (isFeatured) {
                      // Featured Blue Card (NEWUSER15)
                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2563EB),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(color: const Color(0xFF2563EB).withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4)),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    coupon['tag'],
                                    style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800),
                                  ),
                                ),
                                const Icon(Icons.confirmation_num_outlined, color: Colors.white, size: 22),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              coupon['code'],
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              coupon['title'],
                              style: const TextStyle(fontSize: 13, color: Color(0xFFE2E8F0)),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(coupon['expiry'], style: const TextStyle(fontSize: 11, color: Color(0xFFCBD5E1))),
                                    const SizedBox(width: 8),
                                    Text(coupon['terms'], style: const TextStyle(fontSize: 11, color: Colors.white, decoration: TextDecoration.underline)),
                                  ],
                                ),
                                ElevatedButton(
                                  onPressed: () => _applyCoupon(coupon['code'], coupon['discount']),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    elevation: 0,
                                  ),
                                  child: const Text('Apply', style: TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.w800, fontSize: 12)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }

                    // Standard Outline Coupon Cards
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12),
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
                                  const Icon(Icons.local_offer_outlined, size: 16, color: Color(0xFF2563EB)),
                                  const SizedBox(width: 6),
                                  Text(
                                    coupon['code'],
                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                                  ),
                                ],
                              ),
                              if (status == 'apply')
                                ElevatedButton(
                                  onPressed: () => _applyCoupon(coupon['code'], coupon['discount']),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF2563EB),
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                    elevation: 0,
                                  ),
                                  child: const Text('Apply', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                                )
                              else if (status == 'collect')
                                OutlinedButton(
                                  onPressed: () => _applyCoupon(coupon['code'], coupon['discount']),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Color(0xFF2563EB)),
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                  ),
                                  child: const Text('Collect', style: TextStyle(color: Color(0xFF2563EB), fontSize: 11, fontWeight: FontWeight.w700)),
                                )
                              else
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text('Claimed', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11, fontWeight: FontWeight.w700)),
                                ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            coupon['title'],
                            style: const TextStyle(fontSize: 12, color: Color(0xFF475569)),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text(coupon['expiry'], style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
                              const SizedBox(width: 8),
                              Text(coupon['terms'], style: const TextStyle(fontSize: 10, color: Color(0xFF2563EB))),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
