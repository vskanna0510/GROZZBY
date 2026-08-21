import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/grozzby_bottom_nav_bar.dart';

class NotificationPreferencesScreen extends StatefulWidget {
  const NotificationPreferencesScreen({super.key});

  @override
  State<NotificationPreferencesScreen> createState() => _NotificationPreferencesScreenState();
}

class _NotificationPreferencesScreenState extends State<NotificationPreferencesScreen> {
  // Shopping Updates
  bool _orderUpdates = true;
  bool _newArrivals = true;
  bool _backInStock = false;

  // Offers
  bool _promotionsOffers = true;

  // Security
  bool _accountActivity = true;

  // Channels
  bool _emailChannel = true;
  bool _smsChannel = true;
  bool _pushChannel = true;

  // Focus Mode
  bool _focusModeEnabled = false;

  void _showToast(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

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
            // 1. Top Header Bar matching Figma & Uploaded Screenshot
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                    'Notification Settings',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF191C1D),
                      letterSpacing: -0.3,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.notifications_active_rounded,
                    size: 20,
                    color: Color(0xFF505050),
                  ),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Heading & Subtitle
                    const Text(
                      'Preferences',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF191C1D),
                        letterSpacing: -0.5,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Choose how you want to be notified about your orders, personalized deals, and the latest drops at Aura Shop.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF505050),
                        height: 1.5,
                        fontFamily: 'Inter',
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Card 1: Shopping Updates (White Card)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
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
                          Row(
                            children: const [
                              Icon(Icons.shopping_basket_outlined, size: 20, color: Color(0xFF00288E)),
                              SizedBox(width: 10),
                              Text(
                                'Shopping Updates',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF191C1D),
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildSwitchItem(
                            title: 'Order Updates',
                            subtitle: 'Real-time tracking, shipping status, and delivery confirmations.',
                            value: _orderUpdates,
                            onChanged: (val) {
                              setState(() => _orderUpdates = val);
                              _showToast(val ? 'Order updates enabled' : 'Order updates disabled');
                            },
                          ),
                          const Divider(height: 24, color: Color(0xFFF1F5F9)),
                          _buildSwitchItem(
                            title: 'New Arrivals',
                            subtitle: 'Be the first to know when we launch new collections and limited items.',
                            value: _newArrivals,
                            onChanged: (val) {
                              setState(() => _newArrivals = val);
                              _showToast(val ? 'New arrivals notifications enabled' : 'New arrivals notifications disabled');
                            },
                          ),
                          const Divider(height: 24, color: Color(0xFFF1F5F9)),
                          _buildSwitchItem(
                            title: 'Back in Stock',
                            subtitle: 'Get notified when items in your wishlist are available again.',
                            value: _backInStock,
                            onChanged: (val) {
                              setState(() => _backInStock = val);
                              _showToast(val ? 'Back in stock alerts enabled' : 'Back in stock alerts disabled');
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Card 2: Offers (Soft Light Blue Card)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFCBDAEF),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFB9CEEC)),
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
                          Row(
                            children: const [
                              Icon(Icons.local_offer_rounded, size: 20, color: Color(0xFF00288E)),
                              SizedBox(width: 10),
                              Text(
                                'Offers',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF191C1D),
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildSwitchItem(
                            title: 'Promotions & Offers',
                            subtitle: 'Personalized discounts, flash sales, and seasonal coupons.',
                            value: _promotionsOffers,
                            onChanged: (val) {
                              setState(() => _promotionsOffers = val);
                              _showToast(val ? 'Promotions & offers enabled' : 'Promotions & offers disabled');
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Card 3: Security (White Card)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
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
                          Row(
                            children: const [
                              Icon(Icons.shield_outlined, size: 20, color: Color(0xFF00288E)),
                              SizedBox(width: 10),
                              Text(
                                'Security',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF191C1D),
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildSwitchItem(
                            title: 'Account Activity',
                            subtitle: 'Alerts for new logins, password changes, and security updates.',
                            value: _accountActivity,
                            onChanged: (val) {
                              setState(() => _accountActivity = val);
                              _showToast(val ? 'Security activity alerts enabled' : 'Security activity alerts disabled');
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Card 4: How we reach you (Light Gray / Neutral Card)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F3F5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'How we reach you',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF191C1D),
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Enable multi-channel notifications to never miss an important update.',
                            style: TextStyle(
                              fontSize: 13.5,
                              color: Color(0xFF505050),
                              height: 1.45,
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              _buildChannelPill(
                                icon: Icons.mail_outline_rounded,
                                label: 'Email',
                                isActive: _emailChannel,
                                onTap: () {
                                  setState(() => _emailChannel = !_emailChannel);
                                  _showToast(_emailChannel ? 'Email channel activated' : 'Email channel paused');
                                },
                              ),
                              const SizedBox(width: 10),
                              _buildChannelPill(
                                icon: Icons.chat_bubble_outline_rounded,
                                label: 'SMS',
                                isActive: _smsChannel,
                                onTap: () {
                                  setState(() => _smsChannel = !_smsChannel);
                                  _showToast(_smsChannel ? 'SMS alerts activated' : 'SMS alerts paused');
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          _buildChannelPill(
                            icon: Icons.notifications_active_rounded,
                            label: _pushChannel ? 'Push Active' : 'Push Inactive',
                            isActive: _pushChannel,
                            isPrimary: true,
                            onTap: () {
                              setState(() => _pushChannel = !_pushChannel);
                              _showToast(_pushChannel ? 'Push notifications active' : 'Push notifications paused');
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Card 5: Focus Mode is available (Gradient Glass / Hero Card)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFFEBE7DD),
                            Color(0xFFE4EDF9),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Bell with Z badge / icon
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.8),
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.notifications_paused_rounded,
                                size: 28,
                                color: Color(0xFF191C1D),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'Focus Mode is\navailable',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF191C1D),
                              height: 1.25,
                              letterSpacing: -0.3,
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'Mute all non-essential notifications with one tap during your busy hours.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF505050),
                                height: 1.5,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          ElevatedButton(
                            onPressed: () {
                              setState(() => _focusModeEnabled = !_focusModeEnabled);
                              _showToast(_focusModeEnabled ? 'Focus Mode active (Smart Mute enabled)' : 'Focus Mode disabled');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _focusModeEnabled ? const Color(0xFF006C4B) : const Color(0xFF191C1D),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            child: Text(
                              _focusModeEnabled ? '✓ Smart Mute Active' : 'Enable Smart Mute',
                              style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Inter',
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

  Widget _buildSwitchItem({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
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
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12.5,
                  color: Color(0xFF505050),
                  height: 1.4,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: Colors.white,
          activeTrackColor: const Color(0xFF00288E),
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: const Color(0xFF94A3B8),
        ),
      ],
    );
  }

  Widget _buildChannelPill({
    required IconData icon,
    required String label,
    required bool isActive,
    bool isPrimary = false,
    required VoidCallback onTap,
  }) {
    final bgColor = isPrimary
        ? (isActive ? const Color(0xFF00288E) : const Color(0xFF94A3B8))
        : (isActive ? Colors.white : const Color(0xFFE2E8F0));
    final textColor = isPrimary
        ? Colors.white
        : (isActive ? const Color(0xFF191C1D) : const Color(0xFF64748B));
    final iconColor = isPrimary
        ? Colors.white
        : (isActive ? const Color(0xFF00288E) : const Color(0xFF64748B));

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(20),
            border: isPrimary ? null : Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: isPrimary
                ? [
                    BoxShadow(
                      color: const Color(0xFF00288E).withValues(alpha: 0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: iconColor),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
