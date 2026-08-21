import 'package:flutter/material.dart';
import '../../core/constants/app_assets.dart';
import '../../core/theme/app_text_styles.dart';
import 'grozzby_asset.dart';

/// Figma node 1:222 — blue arc with yellow dot (45.04 × 38.64).
class OtpLoadingIndicator extends StatefulWidget {
  const OtpLoadingIndicator({
    super.key,
    this.size = 45.04,
    this.animate = true,
  });

  final double size;
  final bool animate;

  static const _aspectRatio = 38.6406 / 45.0431;

  @override
  State<OtpLoadingIndicator> createState() => _OtpLoadingIndicatorState();
}

class _OtpLoadingIndicatorState extends State<OtpLoadingIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    _syncAnimation();
  }

  @override
  void didUpdateWidget(covariant OtpLoadingIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animate != widget.animate) {
      _syncAnimation();
    }
  }

  void _syncAnimation() {
    if (widget.animate) {
      _controller ??= AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1200),
      )..repeat();
    } else {
      _controller?.stop();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = widget.size * OtpLoadingIndicator._aspectRatio;
    final graphic = GrozzbyAsset(
      AppAssets.images.otpProgress,
      width: widget.size,
      height: height,
    );

    if (!widget.animate || _controller == null) {
      return graphic;
    }

    return RotationTransition(
      turns: _controller!,
      child: graphic,
    );
  }
}

/// Figma node 1:225 — "Accepted" label + blue check badge (12×12).
class OtpAcceptedRow extends StatelessWidget {
  const OtpAcceptedRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Accepted ', style: AppTextStyles.captionMedium11),
        GrozzbyAsset(
          AppAssets.images.otpAcceptedBadge,
          width: 12,
          height: 12,
        ),
      ],
    );
  }
}
