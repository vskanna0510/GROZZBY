import 'package:flutter/material.dart';
import '../../core/constants/app_assets.dart';
import 'grozzby_asset.dart';

class GrozzbyLogo extends StatelessWidget {
  const GrozzbyLogo({
    super.key,
    this.height = 28,
    this.width,
    this.full = true,
  });

  final double? height;
  final double? width;
  final bool full;

  @override
  Widget build(BuildContext context) {
    return GrozzbyAsset(
      AppAssets.images.grozzbyLogo,
      height: height,
      width: width,
      fit: BoxFit.contain,
    );
  }
}

