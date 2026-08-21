import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class OnboardingPageIndicator extends StatelessWidget {
  const OnboardingPageIndicator({super.key, required this.currentIndex});

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        final active = index == currentIndex;
        return Container(
          margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
          width: active ? 28 : 8,
          height: 6,
          decoration: BoxDecoration(
            color: active ? AppColors.warning : AppColors.ringOverlay,
            borderRadius: BorderRadius.circular(999),
          ),
        );
      }),
    );
  }
}
