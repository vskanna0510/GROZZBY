import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_assets.dart';
import '../../../shared/widgets/grozzby_asset.dart';
import '../../../shared/widgets/start_shopping_button.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  void _onStartShopping(BuildContext context) {
    context.go('/home');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 19),
          child: Column(
            children: [
              const Spacer(flex: 3),
              Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  GrozzbyAsset(
                    AppAssets.images.welcomeCircle,
                    width: 236,
                    height: 236,
                  ),
                  GrozzbyAsset(
                    AppAssets.images.checkmark,
                    width: 127,
                    height: 127,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Welcome to the Grozzby family!',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodySemiBold16.copyWith(
                      height: 1.5,
                      leadingDistribution: TextLeadingDistribution.even,
                    ),
                  ),
                  const SizedBox(height: 9),
                  Text(
                    'Shop everything you need—from everyday essentials to the latest products—all in one place, delivered right to your doorstep.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.labelRegular12.copyWith(
                      height: 1.5,
                      leadingDistribution: TextLeadingDistribution.even,
                    ),
                  ),
                  const SizedBox(height: 6),
                  StartShoppingButton(
                    onPressed: () => _onStartShopping(context),
                  ),
                ],
              ),
              const Spacer(flex: 2),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
