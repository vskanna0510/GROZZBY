import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class AccountSecurityScreen extends StatefulWidget {
  const AccountSecurityScreen({super.key});

  @override
  State<AccountSecurityScreen> createState() => _AccountSecurityScreenState();
}

class _AccountSecurityScreenState extends State<AccountSecurityScreen> {
  final List<Map<String, dynamic>> _devices = [
    {
      'name': 'Samsung Galaxy S24 Ultra',
      'location': 'New York, USA',
      'activity': 'Active now',
      'icon': Icons.phone_android_rounded,
      'isCurrent': true,
    },
    {
      'name': 'MacBook Pro 16" (Chrome 122)',
      'location': 'New York, USA',
      'activity': '2 hours ago',
      'icon': Icons.laptop_mac_rounded,
      'isCurrent': false,
    },
    {
      'name': 'iPad Pro 11" (Grozzby iOS)',
      'location': 'New York, USA',
      'activity': '3 days ago',
      'icon': Icons.tablet_mac_rounded,
      'isCurrent': false,
    },
  ];

  void _revokeSession(int index) {
    final dev = _devices[index];
    setState(() {
      _devices.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Revoked session for ${dev['name']}'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _revokeAllOtherSessions() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Sign Out All Other Devices?', style: AppTextStyles.headingBold18),
        content: Text(
          'You will remain signed in on this current device. All other active sessions will be terminated immediately.',
          style: AppTextStyles.bodyRegular14.copyWith(color: AppColors.neutral700),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: AppTextStyles.bodySemiBold14.copyWith(color: AppColors.neutral600)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _devices.removeWhere((d) => !(d['isCurrent'] as bool));
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All other sessions signed out successfully.'),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text('Sign Out All', style: AppTextStyles.bodySemiBold14.copyWith(color: Colors.white)),
          ),
        ],
      ),
    );
  }

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
          'Security & Verification',
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
            // Verification Badge Banner
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF065F46), Color(0xFF047857)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF047857).withValues(alpha: 0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.verified_user_rounded, color: Colors.white, size: 26),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Text(
                              'Identity Verified',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(width: 6),
                            Icon(Icons.check_circle_rounded, color: Color(0xFF34D399), size: 16),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Level 2 Verified • Full purchasing & order protection active.',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Credentials & 2FA Section
            Text('Account Credentials', style: AppTextStyles.accountSectionTitle),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.neutral200),
              ),
              child: Column(
                children: [
                  _buildCredentialRow(
                    title: 'Password',
                    subtitle: '•••••••• (Last changed 45 days ago)',
                    actionText: 'Change',
                    onAction: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Password change modal opened')),
                      );
                    },
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16, color: AppColors.neutral100),
                  _buildCredentialRow(
                    title: 'Two-Factor Auth (2FA)',
                    subtitle: 'Active via Authenticator App',
                    actionText: 'Manage',
                    onAction: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('2FA settings opened')),
                      );
                    },
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16, color: AppColors.neutral100),
                  _buildCredentialRow(
                    title: 'Recovery Email',
                    subtitle: 'j***g@example.com (Verified)',
                    actionText: 'Update',
                    onAction: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Active Device Sessions Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Active Device Sessions', style: AppTextStyles.accountSectionTitle),
                if (_devices.length > 1)
                  TextButton(
                    onPressed: _revokeAllOtherSessions,
                    child: Text(
                      'Sign Out All',
                      style: AppTextStyles.bodySemiBold14.copyWith(color: AppColors.danger, fontSize: 13),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),

            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.neutral200),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _devices.length,
                separatorBuilder: (_, __) => const Divider(height: 1, indent: 68, color: AppColors.neutral100),
                itemBuilder: (context, index) {
                  final device = _devices[index];
                  final isCurrent = device['isCurrent'] as bool;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: isCurrent ? AppColors.settingEmeraldBg : AppColors.neutral100,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            device['icon'] as IconData,
                            color: isCurrent ? AppColors.settingEmerald : AppColors.neutral700,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      device['name'] as String,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyles.bodySemiBold14,
                                    ),
                                  ),
                                  if (isCurrent) ...[
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFDCFCE7),
                                        borderRadius: BorderRadius.circular(999),
                                      ),
                                      child: const Text(
                                        'This device',
                                        style: TextStyle(
                                          fontSize: 9.5,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF047857),
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${device['location']} • ${device['activity']}',
                                style: AppTextStyles.caption,
                              ),
                            ],
                          ),
                        ),
                        if (!isCurrent)
                          TextButton(
                            onPressed: () => _revokeSession(index),
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.danger,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text('Revoke', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCredentialRow({
    required String title,
    required String subtitle,
    required String actionText,
    required VoidCallback onAction,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
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
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(actionText, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
          ),
        ],
      ),
    );
  }
}
