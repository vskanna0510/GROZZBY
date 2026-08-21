import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/grozzby_asset.dart';
import '../../../shared/widgets/grozzby_primary_button.dart';
import '../../../shared/widgets/grozzby_text_field.dart';
import '../../../shared/widgets/social_login_section.dart';
import '../../../shared/widgets/terms_footer.dart';

/// Splash intro replicating Figma prototype node 2:221 (8.34s recording).
///
/// Figma geometry (428x926 frame):
/// - Bag graphic rests in a 261x292 box, horizontally centered, center y=371.
/// - Start state: the same graphic zoomed to 2644x2958 (10.13x) with its
///   center offset (+0.5, -214) - the viewport lands inside the bag's solid
///   blue body, so the screen opens fully blue.
/// - Smart animate zooms out continuously to the resting bag.
/// - The GROZZBY wordmark dissolves into a 262x59 slot at y=536 (center
///   y=565.5), then travels up to the sign-in header while the form
///   dissolves in.
///
/// Timeline:
/// 1. 0.0-2.0s  dark hold
/// 2. 2.0-2.8s  full blue -> continuous zoom-out (scale 10.13 -> 1)
/// 3. 2.8-3.0s  bag rests centered (no map yet)
/// 4. 3.0-3.7s  India map fades/scales into the bag ("bag add map")
/// 5. 4.0-4.6s  bag dissolves out, wordmark dissolves in at its slot
/// 6. 4.6-5.6s  wordmark holds
/// 7. 5.6-6.6s  wordmark travels up to the header
/// 8. 6.0-8.3s  sign-in form fades/slides in, then navigate
class SplashAnimationScreen extends StatefulWidget {
  const SplashAnimationScreen({
    super.key,
    required this.onFinished,
  });

  final Future<String> Function() onFinished;

  @override
  State<SplashAnimationScreen> createState() => _SplashAnimationScreenState();
}

class _SplashAnimationScreenState extends State<SplashAnimationScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _master;
  final _identifier = TextEditingController();
  final _password = TextEditingController();

  static const _durationMs = 8341.0;

  /// The designer's easing curve, extracted from the file's Figma keyframes
  /// (cubic-bezier(0.5, 0, 0.5, 1)).
  static const _figmaEase = Cubic(0.5, 0, 0.5, 1);

  // Figma reference frame (node 2:88 / 2:221).
  static const _figmaW = 428.0;
  static const _figmaH = 926.0;

  // Bag graphic resting box (node 2:95).
  static const _bagRestW = 261.0;
  static const _bagRestH = 292.0;
  static const _bagRestCenterY = 371.0;

  // Zoomed start state (node 2:96): 2644x2958 centered at (+0.5, -214).
  static const _zoomScale = 2958.0 / 292.0; // = 10.13
  static const _zoomOffsetX = 0.5;
  static const _zoomOffsetY = -214.0;

  // Wordmark slot (node 2:94): 262x59 at y=536 -> center y=565.5.
  static const _wordmarkSlotCenterY = 565.5;
  static const _wordmarkHeight = 50.0;

  @override
  void initState() {
    super.initState();
    _master = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 8341),
    )..forward();

    _master.addStatusListener((status) async {
      if (status != AnimationStatus.completed || !mounted) return;
      final route = await widget.onFinished();
      if (mounted) context.go(route);
    });
  }

  double _t(double seconds) => seconds / (_durationMs / 1000);

  double _interval(double startSec, double endSec) {
    final v = _master.value;
    final start = _t(startSec);
    final end = _t(endSec);
    if (start >= end) return v >= start ? 1 : 0;
    if (v <= start) return 0;
    if (v >= end) return 1;
    return (v - start) / (end - start);
  }

  double _curve(double startSec, double endSec, Curve curve) {
    return curve.transform(_interval(startSec, endSec));
  }

  static double _lerp(double a, double b, double t) => a + (b - a) * t;

  @override
  void dispose() {
    _master.dispose();
    _identifier.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _master,
      builder: (context, _) {
        final size = MediaQuery.sizeOf(context);
        final safeTop = MediaQuery.paddingOf(context).top;
        final fx = size.width / _figmaW;
        final fy = size.height / _figmaH;

        // Timeline in seconds of the 8.341s prototype recording.
        final darkHold = 1 - _curve(1.8, 2.1, Curves.easeOut);
        final zoom = _curve(2.0, 2.8, _figmaEase);
        final blueBackdrop = 1 - _curve(2.0, 2.3, Curves.easeIn);
        // India map "drops into" the bag after the zoom settles (t≈3.0–3.7s).
        final mapIn = _curve(3.0, 3.7, _figmaEase);
        final bagOut = _curve(4.0, 4.6, Curves.easeIn);
        final wordmarkIn = _curve(4.0, 4.6, Curves.easeOut);
        final travel = _curve(5.6, 6.6, _figmaEase);
        final formIn = _curve(6.0, 8.3, Curves.easeOutCubic);

        // Bag geometry: interpolate scale and child-center offset together,
        // exactly like Figma smart animate.
        final scale = _lerp(_zoomScale, 1.0, zoom);
        final bagW = _bagRestW * fx * scale;
        final bagH = _bagRestH * fx * scale;
        final bagCenterX = size.width / 2 + _zoomOffsetX * fx * (1 - zoom);
        final bagCenterY =
            _bagRestCenterY * fy + _zoomOffsetY * fx * (1 - zoom);
        final bagOpacity = (1 - bagOut).clamp(0.0, 1.0);
        final showBag = _master.value >= _t(1.8) && bagOpacity > 0;

        // Wordmark: dissolves in at its Figma slot, then travels up to the
        // sign-in header (same spacing as SignInScreen: 24 pad + 40 spacer).
        final wordmarkH = _wordmarkHeight * fx;
        final slotCenterY = _wordmarkSlotCenterY * fy;
        final headerCenterY = safeTop + 24 + 40 + wordmarkH / 2;
        final wordmarkCenterY = _lerp(slotCenterY, headerCenterY, travel);

        return Scaffold(
          backgroundColor: AppColors.white,
          body: Stack(
            fit: StackFit.expand,
            clipBehavior: Clip.hardEdge,
            children: [
              const ColoredBox(color: AppColors.white),

              // Blue safety backdrop while the zoomed bag fills the viewport.
              if (blueBackdrop > 0 && bagOpacity > 0)
                ColoredBox(
                  color: AppColors.secondary.withValues(alpha: blueBackdrop),
                ),

              // Zooming bag: empty bag first, then India map crossfades in
              // (the "bag add map" beat from the Figma prototype recording).
              if (showBag)
                Positioned(
                  left: bagCenterX - bagW / 2,
                  top: bagCenterY - bagH / 2,
                  width: bagW,
                  height: bagH,
                  child: Opacity(
                    opacity: bagOpacity,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Opacity(
                          opacity: (1 - mapIn).clamp(0.0, 1.0),
                          child: GrozzbyAsset(
                            AppAssets.images.splashGraphic,
                            fit: BoxFit.contain,
                          ),
                        ),
                        if (mapIn > 0)
                          Opacity(
                            opacity: mapIn,
                            child: Transform.scale(
                              scale: 0.88 + mapIn * 0.12,
                              child: GrozzbyAsset(
                                AppAssets.images.splashBagWithMap,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

              // Dark hold covers everything at the start.
              if (darkHold > 0)
                ColoredBox(
                  color: AppColors.splashDark.withValues(alpha: darkHold),
                ),

              // Sign-in form with an empty placeholder where the wordmark
              // lands, matching SignInScreen's layout for a seamless handoff.
              if (formIn > 0)
                SafeArea(
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.screenHorizontalAlt,
                      24,
                      AppSpacing.screenHorizontal,
                      24,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        SizedBox(height: wordmarkH),
                        const SizedBox(height: 43),
                        Opacity(
                          opacity: formIn,
                          child: Transform.translate(
                            offset: Offset(0, 36 * (1 - formIn)),
                            child: _SplashSignInPreview(
                              identifier: _identifier,
                              password: _password,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // GROZZBY wordmark: dissolves in at its slot, travels to header.
              if (wordmarkIn > 0)
                Positioned(
                  left: 0,
                  right: 0,
                  top: wordmarkCenterY - wordmarkH / 2,
                  height: wordmarkH,
                  child: Center(
                    child: Opacity(
                      opacity: wordmarkIn,
                      child: GrozzbyAsset(
                        AppAssets.images.logoFull,
                        height: wordmarkH,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _SplashSignInPreview extends StatelessWidget {
  const _SplashSignInPreview({
    required this.identifier,
    required this.password,
  });

  final TextEditingController identifier;
  final TextEditingController password;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Sign in to  Continue ', style: AppTextStyles.titleBold20),
        const SizedBox(height: 24),
        GrozzbyTextField(
          controller: identifier,
          hint: 'Email  or Phone number',
          leadingIcon: AppAssets.icons.profile,
        ),
        const SizedBox(height: 18),
        GrozzbyTextField(
          controller: password,
          hint: 'Password',
          leadingIcon: AppAssets.icons.password,
          obscureText: true,
          trailing: GrozzbyAsset(AppAssets.icons.visibility, width: 24, height: 24),
        ),
        const SizedBox(height: 18),
        GrozzbyPrimaryButton(
          label: 'Sign in',
          fontSize: 20,
          onPressed: () {},
        ),
        const SizedBox(height: 34),
        RichText(
          text: TextSpan(
            style: AppTextStyles.labelBold12.copyWith(color: const Color(0xFF707070)),
            children: [
              const TextSpan(text: 'Don’t have an account ? '),
              TextSpan(
                text: 'Register',
                style: AppTextStyles.labelBold12.copyWith(color: AppColors.link),
              ),
            ],
          ),
        ),
        const SizedBox(height: 26),
        const SocialLoginSection(showBorder: true),
        const SizedBox(height: 26),
        const TermsFooter(),
      ],
    );
  }
}

class AppSession {
  AppSession(this._prefs);

  final SharedPreferences _prefs;
  static const _onboardingKey = 'onboarding_completed';

  bool get onboardingCompleted => _prefs.getBool(_onboardingKey) ?? false;

  Future<void> setOnboardingCompleted() async {
    await _prefs.setBool(_onboardingKey, true);
  }
}
