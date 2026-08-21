import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class TermsFooter extends StatelessWidget {
  const TermsFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: AppTextStyles.labelSemiBold12.copyWith(color: AppColors.neutral700),
        children: [
          const TextSpan(text: 'by continuing you agree to our '),
          TextSpan(
            text: 'terms and privacy policy',
            style: AppTextStyles.labelSemiBold12.copyWith(color: AppColors.link),
            recognizer: TapGestureRecognizer()..onTap = () {},
          ),
        ],
      ),
    );
  }
}

class AuthLink extends StatelessWidget {
  const AuthLink({
    super.key,
    required this.prefix,
    required this.linkText,
    required this.onTap,
  });

  final String prefix;
  final String linkText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: AppTextStyles.labelBold12.copyWith(color: const Color(0xFF707070)),
          children: [
            TextSpan(text: prefix),
            TextSpan(
              text: linkText,
              style: AppTextStyles.labelBold12.copyWith(color: AppColors.link),
            ),
          ],
        ),
      ),
    );
  }
}
