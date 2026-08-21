import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../auth/presentation/auth_controller.dart';

class SwitchAccountScreen extends StatefulWidget {
  const SwitchAccountScreen({super.key});

  @override
  State<SwitchAccountScreen> createState() => _SwitchAccountScreenState();
}

class _SwitchAccountScreenState extends State<SwitchAccountScreen> {
  int _activeAccountIndex = 0;

  final List<Map<String, dynamic>> _accounts = [
    {
      'name': 'Jonathan Sterling',
      'email': 'jonathan.sterling@example.com',
      'initials': 'JS',
      'type': 'Personal',
      'color': Color(0xFF0A2540),
    },
    {
      'name': 'Sterling Family Pantry',
      'email': 'family.sterling@example.com',
      'initials': 'SF',
      'type': 'Family Shared',
      'color': Color(0xFF059669),
    },
    {
      'name': 'Sterling Enterprise Pro',
      'email': 'pro.sterling@grozzby.biz',
      'initials': 'SE',
      'type': 'Business',
      'color': Color(0xFF7C3AED),
    },
  ];

  void _handleSelectAccount(int index) {
    if (index == _activeAccountIndex) {
      Navigator.of(context).pop();
      return;
    }

    setState(() => _activeAccountIndex = index);
    final account = _accounts[index];

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Switched to ${account['name']}'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    final currentName = auth.user?.name ?? _accounts[0]['name'];
    final currentEmail = auth.user?.email ?? _accounts[0]['email'];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: AppColors.neutral900),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Switch Account',
          style: AppTextStyles.headingBold18.copyWith(color: AppColors.neutral900),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Account',
              style: AppTextStyles.accountSectionTitle,
            ),
            const SizedBox(height: 6),
            Text(
              'Switch between your personal, family, and business profiles seamlessly.',
              style: AppTextStyles.caption.copyWith(fontSize: 13),
            ),
            const SizedBox(height: 18),

            // Accounts List
            Expanded(
              child: ListView.separated(
                itemCount: _accounts.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final acc = _accounts[index];
                  final isActive = _activeAccountIndex == index;

                  return Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isActive ? AppColors.primary : AppColors.neutral200,
                        width: isActive ? 2 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isActive
                              ? AppColors.primary.withValues(alpha: 0.08)
                              : AppColors.black.withValues(alpha: 0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _handleSelectAccount(index),
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              // Avatar circle
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: acc['color'] as Color,
                                ),
                                child: Center(
                                  child: Text(
                                    acc['initials'] as String,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),

                              // Account details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            index == 0 ? currentName : acc['name'] as String,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: AppTextStyles.bodySemiBold14.copyWith(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: AppColors.neutral100,
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            acc['type'] as String,
                                            style: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.neutral700,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      index == 0 ? currentEmail : acc['email'] as String,
                                      style: AppTextStyles.caption.copyWith(color: AppColors.neutral500),
                                    ),
                                  ],
                                ),
                              ),

                              // Checkmark indicator
                              if (isActive)
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.check_rounded, color: Colors.white, size: 16),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Add Account Button
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.neutral200, style: BorderStyle.solid),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Add account dialog')),
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add_circle_outline_rounded, color: AppColors.primary, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Add Another Account',
                          style: AppTextStyles.bodySemiBold14.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
