import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class PaymentSecurityScreen extends StatefulWidget {
  const PaymentSecurityScreen({super.key});

  @override
  State<PaymentSecurityScreen> createState() => _PaymentSecurityScreenState();
}

class _PaymentSecurityScreenState extends State<PaymentSecurityScreen> {
  bool _biometricEnabled = true;
  bool _pinForCheckout = false;
  bool _oneClickBuy = true;
  int _selectedDefaultCard = 0;

  final List<Map<String, dynamic>> _cards = [
    {
      'type': 'Visa',
      'number': '•••• •••• •••• 4242',
      'holder': 'JONATHAN STERLING',
      'expiry': '12/28',
      'colors': [Color(0xFF0A2540), Color(0xFF1E3A8A)],
      'isDefault': true,
    },
    {
      'type': 'Mastercard',
      'number': '•••• •••• •••• 8821',
      'holder': 'JONATHAN STERLING',
      'expiry': '09/27',
      'colors': [Color(0xFF1F2937), Color(0xFF374151)],
      'isDefault': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.neutral900),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Payments & Security',
          style: AppTextStyles.headingBold18.copyWith(color: AppColors.neutral900),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1: Saved Payment Methods
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Saved Cards',
                  style: AppTextStyles.accountSectionTitle,
                ),
                TextButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Add card flow initiated')),
                    );
                  },
                  icon: const Icon(Icons.add_rounded, size: 16, color: AppColors.primary),
                  label: Text(
                    'Add Card',
                    style: AppTextStyles.bodySemiBold14.copyWith(color: AppColors.primary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Visual Credit Cards Carousel / List
            SizedBox(
              height: 190,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: _cards.length,
                separatorBuilder: (_, __) => const SizedBox(width: 14),
                itemBuilder: (context, index) {
                  final card = _cards[index];
                  final isDefault = _selectedDefaultCard == index;

                  return GestureDetector(
                    onTap: () => setState(() => _selectedDefaultCard = index),
                    child: Container(
                      width: 290,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: card['colors'] as List<Color>,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: (card['colors'] as List<Color>)[0].withValues(alpha: 0.35),
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                card['type'] as String,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 18,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              if (isDefault)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.25),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: const Text(
                                    'Default',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          Text(
                            card['number'] as String,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              letterSpacing: 2,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'CARD HOLDER',
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.6),
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    card['holder'] as String,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'EXPIRES',
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.6),
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    card['expiry'] as String,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 28),

            // Section 2: UPI & Wallets
            Text('Digital Wallets & UPI', style: AppTextStyles.accountSectionTitle),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.neutral200),
              ),
              child: Column(
                children: [
                  _buildWalletTile(
                    title: 'Google Pay',
                    subtitle: 'jonathan.sterling@okaxis',
                    icon: Icons.account_balance_wallet_rounded,
                    iconBg: const Color(0xFFEFF6FF),
                    iconColor: const Color(0xFF2563EB),
                    statusText: 'Connected',
                    isConnected: true,
                  ),
                  const Divider(height: 1, indent: 68, color: AppColors.neutral100),
                  _buildWalletTile(
                    title: 'Apple Pay',
                    subtitle: 'Linked via Apple Wallet',
                    icon: Icons.phone_iphone_rounded,
                    iconBg: const Color(0xFFF1F5F9),
                    iconColor: const Color(0xFF0F172A),
                    statusText: 'Connected',
                    isConnected: true,
                  ),
                  const Divider(height: 1, indent: 68, color: AppColors.neutral100),
                  _buildWalletTile(
                    title: 'PayPal',
                    subtitle: 'Fast global checkout',
                    icon: Icons.payment_rounded,
                    iconBg: const Color(0xFFF0FDF4),
                    iconColor: const Color(0xFF16A34A),
                    statusText: 'Link',
                    isConnected: false,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Section 3: Security Switches
            Text('Security Controls', style: AppTextStyles.accountSectionTitle),
            const SizedBox(height: 12),
            Material(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: AppColors.neutral200),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    value: _biometricEnabled,
                    onChanged: (val) => setState(() => _biometricEnabled = val),
                    activeTrackColor: AppColors.primary,
                    title: Text('Biometric Authentication', style: AppTextStyles.bodySemiBold14),
                    subtitle: Text('Require Face ID / Fingerprint to open payments', style: AppTextStyles.caption),
                    secondary: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.settingEmeraldBg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.fingerprint_rounded, color: AppColors.settingEmerald, size: 20),
                    ),
                  ),
                  const Divider(height: 1, indent: 68, color: AppColors.neutral100),
                  SwitchListTile(
                    value: _pinForCheckout,
                    onChanged: (val) => setState(() => _pinForCheckout = val),
                    activeTrackColor: AppColors.primary,
                    title: Text('PIN Protection', style: AppTextStyles.bodySemiBold14),
                    subtitle: Text('Ask for 4-digit PIN for orders above \$100', style: AppTextStyles.caption),
                    secondary: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.settingIndigoBg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.pin_rounded, color: AppColors.settingIndigo, size: 20),
                    ),
                  ),
                  const Divider(height: 1, indent: 68, color: AppColors.neutral100),
                  SwitchListTile(
                    value: _oneClickBuy,
                    onChanged: (val) => setState(() => _oneClickBuy = val),
                    activeTrackColor: AppColors.primary,
                    title: Text('1-Click Express Checkout', style: AppTextStyles.bodySemiBold14),
                    subtitle: Text('Automatically use default card and address', style: AppTextStyles.caption),
                    secondary: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.settingOrangeBg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.flash_on_rounded, color: AppColors.settingOrange, size: 20),
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

  Widget _buildWalletTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String statusText,
    required bool isConnected,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.bodySemiBold14),
                const SizedBox(height: 2),
                Text(subtitle, style: AppTextStyles.caption),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isConnected ? const Color(0xFFDCFCE7) : AppColors.neutral100,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              statusText,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: isConnected ? const Color(0xFF047857) : AppColors.neutral700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
