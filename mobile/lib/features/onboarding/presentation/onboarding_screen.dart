import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_assets.dart';
import '../../../shared/widgets/grozzby_asset.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/onboarding_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _index = 0;

  static final _pages = [
    _OnboardingData(
      bg: AppColors.onboardingDark,
      title: 'Premium Shopping, Redefined',
      subtitle: "Thousands of curated products from the world's best brands.",
      heroIcon: AppAssets.images.onboardingBag,
      heroInner: AppColors.warning,
      badgeTop: _BadgeData.whiteIcon(AppAssets.images.onboardingStar),
      badgeBottom: _BadgeData.whiteIcon(AppAssets.images.onboardingHeart),
      skipTextColor: AppColors.warningForeground,
    ),
    _OnboardingData(
      bg: AppColors.accentSky,
      title: 'Fast Delivery, Every Time',
      subtitle: 'Same-day and next-day delivery. Track your order in real time.',
      heroIcon: AppAssets.images.onboardingTruck,
      heroInner: AppColors.secondary,
      badgeTop: _BadgeData.text('2-hr', AppColors.warning, AppColors.warningForeground),
      badgeBottom: _BadgeData.text('FREE', AppColors.chart4, AppColors.white),
      skipTextColor: AppColors.secondary,
    ),
    _OnboardingData(
      bg: AppColors.chart5,
      title: 'Deals That Actually Matter',
      subtitle: 'Flash sales, loyalty rewards, exclusive member prices — daily.',
      heroIcon: AppAssets.images.onboardingTag,
      heroInner: AppColors.chart4,
      badgeTop: _BadgeData.text('-40%', AppColors.warning, AppColors.warningForeground),
      badgeBottom: _BadgeData.text('FLASH', AppColors.accentRed, AppColors.white),
      skipTextColor: AppColors.chart4,
      isLast: true,
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_index < 2) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final page = _pages[_index];
    return Scaffold(
      backgroundColor: page.bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 20, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: GrozzbyAsset(AppAssets.images.onboardingLogo, height: 32),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.go('/sign-in'),
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.cardOverlay,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.xl),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    ),
                    child: Text(
                      'Skip',
                      style: AppTextStyles.bodySemiBold14.copyWith(color: page.skipTextColor),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: 3,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (context, index) {
                  final data = _pages[index];
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s8),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minHeight: constraints.maxHeight),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: _HeroIllustration(data: data),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                data.title,
                                textAlign: TextAlign.center,
                                style: AppTextStyles.onboardingTitle,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                data.subtitle,
                                textAlign: TextAlign.center,
                                style: AppTextStyles.onboardingSubtitle,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: Column(
                children: [
                  OnboardingPageIndicator(currentIndex: _index),
                  const SizedBox(height: 20),
                  if (!page.isLast)
                    _YellowButton(label: 'Next →', onPressed: _next)
                  else ...[
                    _YellowButton(
                      label: 'Create Account →',
                      onPressed: () => context.go('/create-account'),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: () => context.go('/sign-in'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        side: const BorderSide(color: AppColors.white, width: 1.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.xl2),
                        ),
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Sign In to Existing Account',
                          style: AppTextStyles.bodySemiBold14.copyWith(color: AppColors.white),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroIllustration extends StatelessWidget {
  const _HeroIllustration({required this.data});
  final _OnboardingData data;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 204,
      height: 244,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 12,
            top: 12,
            child: Container(
              width: 192,
              height: 192,
              decoration: BoxDecoration(
                color: AppColors.popoverOverlay,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: Center(
                child: Container(
                  width: 144,
                  height: 144,
                  decoration: BoxDecoration(
                    color: data.heroInner,
                    borderRadius: BorderRadius.circular(AppRadius.xl4_3),
                  ),
                  child: Center(
                    child: GrozzbyAsset(data.heroIcon, width: 60, height: 60),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: data.badgeTop is _WhiteIconBadge ? 4 : 0,
            child: _BadgeWidget(data: data.badgeTop),
          ),
          Positioned(
            bottom: 4,
            left: 0,
            child: _BadgeWidget(data: data.badgeBottom),
          ),
        ],
      ),
    );
  }
}

class _BadgeWidget extends StatelessWidget {
  const _BadgeWidget({required this.data});
  final _BadgeData data;

  @override
  Widget build(BuildContext context) {
    if (data is _WhiteIconBadge) {
      final d = data as _WhiteIconBadge;
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.xl2),
          boxShadow: const [
            BoxShadow(color: Color(0x1A000000), offset: Offset(0, 8), blurRadius: 10, spreadRadius: -6),
            BoxShadow(color: Color(0x1A000000), offset: Offset(0, 20), blurRadius: 25, spreadRadius: -5),
          ],
        ),
        child: Center(child: GrozzbyAsset(d.icon, width: 20, height: 20)),
      );
    }
    final d = data as _TextBadge;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: d.bg,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: const [
          BoxShadow(color: Color(0x1A000000), offset: Offset(0, 8), blurRadius: 10, spreadRadius: -6),
          BoxShadow(color: Color(0x1A000000), offset: Offset(0, 20), blurRadius: 25, spreadRadius: -5),
        ],
      ),
      child: Text(d.text, style: AppTextStyles.captionBlack10.copyWith(color: d.fg)),
    );
  }
}

class _YellowButton extends StatelessWidget {
  const _YellowButton({required this.label, required this.onPressed});
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.warning,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.xl2)),
        ),
        child: Text(label, style: AppTextStyles.bodyBlack14),
      ),
    );
  }
}

class _OnboardingData {
  const _OnboardingData({
    required this.bg,
    required this.title,
    required this.subtitle,
    required this.heroIcon,
    required this.heroInner,
    required this.badgeTop,
    required this.badgeBottom,
    required this.skipTextColor,
    this.isLast = false,
  });

  final Color bg;
  final String title;
  final String subtitle;
  final String heroIcon;
  final Color heroInner;
  final _BadgeData badgeTop;
  final _BadgeData badgeBottom;
  final Color skipTextColor;
  final bool isLast;
}

sealed class _BadgeData {
  const _BadgeData();
  const factory _BadgeData.whiteIcon(String icon) = _WhiteIconBadge;
  const factory _BadgeData.text(String text, Color bg, Color fg) = _TextBadge;
}

class _WhiteIconBadge extends _BadgeData {
  const _WhiteIconBadge(this.icon);
  final String icon;
}

class _TextBadge extends _BadgeData {
  const _TextBadge(this.text, this.bg, this.fg);
  final String text;
  final Color bg;
  final Color fg;
}
