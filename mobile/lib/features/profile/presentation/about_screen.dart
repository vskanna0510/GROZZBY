import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/grozzby_app_top_bar.dart';
import '../../../shared/widgets/grozzby_bottom_nav_bar.dart';
import '../../../shared/widgets/grozzby_logo.dart';

class AboutGrozzbyScreen extends StatelessWidget {
  const AboutGrozzbyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: GrozzbyBottomNavBar(
        currentIndex: 4, // Profile/Account tab
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

            // Header Navigation (Back Button, Title)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
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
                        color: Color(0xFF374151),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'About Grozzby',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF374151),
                      fontFamily: 'Inter',
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),

            // Scrollable Main Content matching Figma Node 277:5289
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 48),
                child: Column(
                  children: [
                    // 1. Logo & Identity Section
                    Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 12),
                          SizedBox(
                            width: 128,
                            height: 128,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Layer 1: Rotated primary background
                                Transform.rotate(
                                  angle: 0.1047, // 6 degrees
                                  child: Container(
                                    width: 110,
                                    height: 110,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF00288E).withValues(alpha: 0.10),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                ),
                                // Layer 2: Rotated light blue background
                                Transform.rotate(
                                  angle: -0.0523, // -3 degrees
                                  child: Container(
                                    width: 110,
                                    height: 110,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFD0E1FB).withValues(alpha: 0.35),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                ),
                                // Layer 3: Foreground white card with Grozzby logo
                                Container(
                                  width: 114,
                                  height: 114,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: const Color(0xFFC4C5D5), width: 1),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.06),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: GrozzbyLogo(height: 42),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Grozzy',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF00288E),
                              fontFamily: 'Inter',
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Version 2.4.1',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF444653),
                              fontFamily: 'Inter',
                              letterSpacing: 0.7,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // 2. Company Mission Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(26),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFC4C5D5)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Redefining Service Standards',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF00288E),
                              fontFamily: 'Inter',
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Grozzy is a professional, enterprise grade platform dedicated to seamless service delivery and high precision retail perations. Our mission is to bridge the gap between corporate efficiency and user-centric accessibility, providing a stable and secure ecosystem for modern commerce.',
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF444653),
                              height: 1.75,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // 3. Stats / Highlight Card: 100% Secure Enterprise Grade
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E40AF),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF1E40AF).withValues(alpha: 0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.18),
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.verified_user_rounded,
                                color: Colors.white,
                                size: 26,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            '100% Secure',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'ENTERPRISE GRADE',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withValues(alpha: 0.85),
                              letterSpacing: 1.3,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // 4. Legal & Information Section Card
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFC4C5D5)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Section Header
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                            decoration: const BoxDecoration(
                              border: Border(bottom: BorderSide(color: Color(0xFFE0E3E5))),
                            ),
                            child: const Text(
                              'LEGAL & INFORMATION',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF444653),
                                letterSpacing: 0.8,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                          // Row 1: Terms of Service
                          _buildLegalRow(
                            context: context,
                            icon: Icons.gavel_rounded,
                            title: 'Terms of Service',
                            onTap: () => _showTermsDialog(context),
                          ),
                          const Divider(height: 1, color: Color(0xFFE0E3E5)),
                          // Row 2: Privacy Policy
                          _buildLegalRow(
                            context: context,
                            icon: Icons.shield_rounded,
                            title: 'Privacy Policy',
                            onTap: () => context.push('/profile/privacy-security'),
                          ),
                          const Divider(height: 1, color: Color(0xFFE0E3E5)),
                          // Row 3: Open Source Licenses
                          _buildLegalRow(
                            context: context,
                            icon: Icons.folder_open_rounded,
                            title: 'Open Source Licenses',
                            onTap: () => _showLicensesDialog(context),
                          ),
                          const Divider(height: 1, color: Color(0xFFE0E3E5)),
                          // Row 4: Rate the App
                          _buildLegalRow(
                            context: context,
                            icon: Icons.star_border_rounded,
                            title: 'Rate the App',
                            onTap: () => _showRateDialog(context),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // 5. Enterprise Atrium Imagery Card
                    Container(
                      width: double.infinity,
                      height: 230,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFC4C5D5)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Background Image with Fallback
                          Image.network(
                            'https://images.unsplash.com/photo-1497366216548-37526070297c?w=1000&auto=format&fit=crop&q=80',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: const Color(0xFF0F172A),
                                child: const Center(
                                  child: Icon(Icons.apartment_rounded, size: 64, color: Colors.white24),
                                ),
                              );
                            },
                          ),
                          // Dark Blue Gradient Overlay
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  const Color(0xFF00288E).withValues(alpha: 0.45),
                                  const Color(0xFF00288E).withValues(alpha: 0.88),
                                ],
                              ),
                            ),
                          ),
                          // Text Overlay
                          Padding(
                            padding: const EdgeInsets.all(22),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                'Building the future of\nintegrated enterprise\ncommerce.',
                                style: TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  height: 1.35,
                                  fontFamily: 'Inter',
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withValues(alpha: 0.5),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // 6. Social Media & Copyright Footer
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(top: 24),
                      decoration: const BoxDecoration(
                        border: Border(top: BorderSide(color: Color(0xFFE0E3E5))),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildSocialButton(
                                icon: Icons.alternate_email_rounded,
                                label: 'Twitter / X',
                                onTap: () => _openSocial(context, 'X / Twitter'),
                              ),
                              const SizedBox(width: 20),
                              _buildSocialButton(
                                icon: Icons.camera_alt_outlined,
                                label: 'Instagram',
                                onTap: () => _openSocial(context, 'Instagram'),
                              ),
                              const SizedBox(width: 20),
                              _buildSocialButton(
                                icon: Icons.business_center_outlined,
                                label: 'LinkedIn',
                                onTap: () => _openSocial(context, 'LinkedIn'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            '© 2026 Grozzy Inc. All rights reserved.',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF757684),
                              fontFamily: 'Inter',
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

  Widget _buildLegalRow({
    required BuildContext context,
    required IconData icon,
    required String title,
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
              Icon(icon, size: 20, color: const Color(0xFF00288E)),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF191C1E),
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: Color(0xFF94A3B8),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFE6E8EA),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              icon,
              size: 22,
              color: const Color(0xFF00288E),
            ),
          ),
        ),
      ),
    );
  }

  void _openSocial(BuildContext context, String platform) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening Grozzby official $platform page...'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Terms of Service',
          style: TextStyle(fontWeight: FontWeight.w700, fontFamily: 'Inter'),
        ),
        content: const SingleChildScrollView(
          child: Text(
            'Welcome to Grozzby. By accessing or using our hyper-local delivery services, marketplace, and application, you agree to be bound by these terms.\n\n1. Use of Service: You agree to provide accurate delivery and payment details.\n2. Delivery Guarantee: Orders are dispatched via nearest fulfillment hubs for optimal speed.\n3. Satisfaction & Quality: 100% refund guarantee on damaged or unsealed fresh produce reported within 24 hours of delivery.\n4. Account Security: You are responsible for safeguarding your login credentials.',
            style: TextStyle(fontSize: 13, height: 1.5, color: Color(0xFF475569)),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00288E),
              foregroundColor: Colors.white,
            ),
            child: const Text('I Understand'),
          ),
        ],
      ),
    );
  }

  void _showLicensesDialog(BuildContext context) {
    showLicensePage(
      context: context,
      applicationName: 'Grozzby',
      applicationVersion: '2.4.1',
      applicationLegalese: '© 2026 Grozzby Inc. All rights reserved.',
    );
  }

  void _showRateDialog(BuildContext context) {
    int rating = 5;
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Text(
              'Enjoying Grozzby?',
              style: TextStyle(fontWeight: FontWeight.w700, fontFamily: 'Inter'),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Tap a star to rate your grocery delivery experience on the App Store.',
                  style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        index < rating ? Icons.star_rounded : Icons.star_border_rounded,
                        size: 32,
                        color: const Color(0xFFF59E0B),
                      ),
                      onPressed: () {
                        setModalState(() {
                          rating = index + 1;
                        });
                      },
                    );
                  }),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Maybe Later'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Thank you for rating Grozzby $rating stars! 🌟'),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: const Color(0xFF16A34A),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00288E),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Submit Rating'),
              ),
            ],
          );
        },
      ),
    );
  }
}
