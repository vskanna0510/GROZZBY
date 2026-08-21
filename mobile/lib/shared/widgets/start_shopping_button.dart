import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/constants/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_text_styles.dart';
import 'grozzby_asset.dart';

/// Figma node 1:145 — Start Shopping pill button with static yellow circle
/// and a small bag icon that rolls inside it.
class StartShoppingButton extends StatefulWidget {
  const StartShoppingButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  State<StartShoppingButton> createState() => _StartShoppingButtonState();
}

class _StartShoppingButtonState extends State<StartShoppingButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  static const _keyframeEnd = 0.53798;
  static const _rollAngle = 6.264;
  static const _bagWidth = 27.0;
  static const _bagHeight = 30.0;
  static const _maxTranslate = 6.0;
  static const _figmaEase = Cubic(0.5, 0, 0.5, 1);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 50,
      child: Material(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: widget.onPressed,
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              // Static yellow circle — Figma left 15, top 5, 40×40
              Positioned(
                left: 15,
                top: 5,
                child: GrozzbyAsset(
                  AppAssets.images.shopButtonCircle,
                  width: 40,
                  height: 40,
                ),
              ),
              // Animated bag centered inside the yellow circle
              Positioned(
                left: 15,
                top: 5,
                width: 40,
                height: 40,
                child: ClipOval(
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      final k =
                          (_controller.value / _keyframeEnd).clamp(0.0, 1.0);
                      final eased = _figmaEase.transform(k);
                      final rotate = eased * _rollAngle;
                      final translateX =
                          (_maxTranslate * eased).clamp(0.0, _maxTranslate);
                      return Transform.translate(
                        offset: Offset(translateX, 0),
                        child: Transform.rotate(
                          angle: rotate,
                          alignment: Alignment.center,
                          child: child,
                        ),
                      );
                    },
                    child: Center(
                      child: SizedBox(
                        width: _bagWidth,
                        height: _bagHeight,
                        child: GrozzbyAsset(
                          AppAssets.images.shopBagRoll,
                          width: _bagWidth,
                          height: _bagHeight,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Label — Figma left 152, top 13 (center of 300px button)
              Positioned(
                left: 0,
                right: 0,
                top: 13,
                child: Text(
                  'Start Shopping ',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.whiteBodySemiBold16.copyWith(
                    height: 1.2,
                  ),
                ),
              ),
              // Chevrons — Figma left 255, top 19
              Positioned(
                left: 255,
                top: 19,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(3, (i) {
                    return Transform.rotate(
                      angle: math.pi,
                      child: Padding(
                        padding: EdgeInsets.only(left: i == 0 ? 0 : 2),
                        child: GrozzbyAsset(
                          AppAssets.images.chevron,
                          width: 10,
                          height: 13,
                          color: AppColors.white,
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
