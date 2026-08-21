import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/grozzby_app_top_bar.dart';
import '../../../shared/widgets/grozzby_bottom_nav_bar.dart';

class PrivacySecurityScreen extends StatefulWidget {
  const PrivacySecurityScreen({super.key});

  @override
  State<PrivacySecurityScreen> createState() => _PrivacySecurityScreenState();
}

class _PrivacySecurityScreenState extends State<PrivacySecurityScreen> {
  bool _twoFactorEnabled = true;
  bool _biometricEnabled = true;
  bool _activeSessionsEnabled = true;
  bool _personalizationEnabled = true;
  bool _thirdPartySharingEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      bottomNavigationBar: GrozzbyBottomNavBar(
        currentIndex: 4, // Profile tab
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
            // Top App Bar
            const GrozzbyAppTopBar(),

            // Header Navigation (Back button, Title, Right icon)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: const BoxDecoration(
                color: Color(0xFFF8F9FA),
                border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go('/profile');
                      }
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.arrow_back_rounded,
                        size: 22,
                        color: Color(0xFF191C1D),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Privacy & Security',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF191C1D),
                      fontFamily: 'Inter',
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.lock_outline_rounded,
                        size: 18,
                        color: Color(0xFF191C1D),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable Main Content matching Figma Node 277:4435
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Hero Card / Brand Moment
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD0E1FB),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: const BoxDecoration(
                              color: Color(0xFF334155),
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.lock_rounded,
                                size: 24,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'Your Security, Guaranteed',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF191C1D),
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Manage your data and safety settings in\none place.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF504533),
                              height: 1.4,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // 2. Section 1: SECURITY
                    _buildSectionHeader(
                      icon: Icons.shield_outlined,
                      iconColor: const Color(0xFF006C4B),
                      title: 'SECURITY',
                    ),
                    const SizedBox(height: 10),

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Change Password
                          _buildActionRow(
                            title: 'Change Password',
                            subtitle: 'Last changed 3 months ago',
                            onTap: () => _showChangePasswordDialog(context),
                          ),
                          const Divider(height: 1, color: Color(0xFFEDEEEF)),
                          // Two-Factor Authentication
                          _buildSwitchRow(
                            title: 'Two-Factor Authentication',
                            subtitle: 'Secure your account with SMS or email',
                            value: _twoFactorEnabled,
                            onChanged: (val) {
                              setState(() => _twoFactorEnabled = val);
                              _showToast(val ? '2FA enabled' : '2FA disabled');
                            },
                          ),
                          const Divider(height: 1, color: Color(0xFFEDEEEF)),
                          // Biometric Login
                          _buildSwitchRow(
                            title: 'Biometric Login',
                            subtitle: 'Use Face ID or Fingerprint',
                            value: _biometricEnabled,
                            onChanged: (val) {
                              setState(() => _biometricEnabled = val);
                              _showToast(val ? 'Biometrics enabled' : 'Biometrics disabled');
                            },
                          ),
                          const Divider(height: 1, color: Color(0xFFEDEEEF)),
                          // Active Sessions
                          _buildSwitchRow(
                            title: 'Active Sessions',
                            subtitle: 'Use Face ID or Fingerprint',
                            value: _activeSessionsEnabled,
                            onChanged: (val) {
                              setState(() => _activeSessionsEnabled = val);
                              _showToast(val ? 'Active session monitoring enabled' : 'Session monitoring disabled');
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // 3. Section 2: DATA & PRIVACY
                    _buildSectionHeader(
                      icon: Icons.visibility_outlined,
                      iconColor: const Color(0xFF00288E),
                      title: 'DATA & PRIVACY',
                    ),
                    const SizedBox(height: 10),

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Personalization
                          _buildSwitchRow(
                            title: 'Personalization',
                            subtitle: 'Tailored product recommendations',
                            value: _personalizationEnabled,
                            onChanged: (val) {
                              setState(() => _personalizationEnabled = val);
                              _showToast(val ? 'Personalization enabled' : 'Personalization disabled');
                            },
                          ),
                          const Divider(height: 1, color: Color(0xFFEDEEEF)),
                          // Third-Party Sharing
                          _buildSwitchRow(
                            title: 'Third-Party Sharing',
                            subtitle: 'Share data with advertising partners',
                            value: _thirdPartySharingEnabled,
                            onChanged: (val) {
                              setState(() => _thirdPartySharingEnabled = val);
                              _showToast(val ? 'Third-party sharing enabled' : 'Third-party sharing disabled');
                            },
                          ),
                          const Divider(height: 1, color: Color(0xFFEDEEEF)),
                          // Request Data Export
                          _buildActionRow(
                            title: 'Request Data Export',
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Data export initiated. A download link will be emailed to you.'),
                                  backgroundColor: Color(0xFF00288E),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                          ),
                          const Divider(height: 1, color: Color(0xFFEDEEEF)),
                          // Delete Account
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => _showDeleteAccountDialog(context),
                              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                child: Row(
                                  children: const [
                                    Text(
                                      'Delete Account',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFFBA1A1A),
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // 4. Section 3: LEGAL
                    _buildSectionHeader(
                      icon: Icons.gavel_rounded,
                      iconColor: const Color(0xFF504533),
                      title: 'LEGAL',
                    ),
                    const SizedBox(height: 10),

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildActionRow(
                            title: 'Privacy Policy',
                            onTap: () => _showLegalModal(context, 'Privacy Policy', 'Grozzby is committed to protecting your personal data. We utilize TLS 1.3 encryption, secure tokenization for payments, and strict access controls.'),
                          ),
                          const Divider(height: 1, color: Color(0xFFEDEEEF)),
                          _buildActionRow(
                            title: 'Terms of Service',
                            onTap: () => _showLegalModal(context, 'Terms of Service', 'By using the Grozzby app, you agree to our fair terms of grocery fulfillment, transparent delivery windows, and refund guarantees.'),
                          ),
                          const Divider(height: 1, color: Color(0xFFEDEEEF)),
                          _buildActionRow(
                            title: 'Cookie Policy',
                            onTap: () => _showLegalModal(context, 'Cookie Policy', 'We use essential cookies and tokens to keep your cart synchronized and remember your delivery preferences securely.'),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // 5. Trust Badge Footer
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 64,
                            height: 4,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE1E3E4),
                              borderRadius: BorderRadius.circular(9999),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.shield_rounded,
                                size: 16,
                                color: Color(0xFF006C4B),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Aura Shop Encrypted Security',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF505050).withValues(alpha: 0.8),
                                  fontFamily: 'Inter',
                                ),
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

  Widget _buildSectionHeader({
    required IconData icon,
    required Color iconColor,
    required String title,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: iconColor),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF505050),
              letterSpacing: 0.8,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionRow({
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF191C1D),
                        fontFamily: 'Inter',
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF505050),
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: Color(0xFF94A3B8),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchRow({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF191C1D),
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF505050),
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            activeTrackColor: const Color(0xFF00288E),
            activeThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFF9E9E9E),
            inactiveThumbColor: Colors.white,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final currentPassController = TextEditingController();
    final newPassController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Change Password',
          style: TextStyle(fontWeight: FontWeight.w700, fontFamily: 'Inter'),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPassController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Current Password',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: newPassController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Password updated successfully!'),
                  backgroundColor: Color(0xFF16A34A),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00288E),
              foregroundColor: Colors.white,
            ),
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Delete Account?',
          style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFFBA1A1A), fontFamily: 'Inter'),
        ),
        content: const Text(
          'This action cannot be undone. All your order history, delivery addresses, and personal preferences will be permanently erased.',
          style: TextStyle(fontSize: 13, height: 1.45, color: Color(0xFF475569)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Account deletion request submitted.'),
                  backgroundColor: Color(0xFFBA1A1A),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFBA1A1A),
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete Permanently'),
          ),
        ],
      ),
    );
  }

  void _showLegalModal(BuildContext context, String title, String body) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w700, fontFamily: 'Inter'),
        ),
        content: Text(
          body,
          style: const TextStyle(fontSize: 13, height: 1.5, color: Color(0xFF475569)),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00288E),
              foregroundColor: Colors.white,
            ),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
