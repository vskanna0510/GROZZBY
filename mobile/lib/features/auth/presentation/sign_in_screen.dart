import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/grozzby_asset.dart';
import '../../../shared/widgets/grozzby_logo.dart';
import '../../../shared/widgets/grozzby_primary_button.dart';
import '../../../shared/widgets/grozzby_text_field.dart';
import '../../../shared/widgets/social_login_section.dart';
import '../../../shared/widgets/terms_footer.dart';
import '../../auth/presentation/auth_controller.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _identifier = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _identifier.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final auth = context.read<AuthController>();
    auth.clearError();
    final session = await auth.login(
      identifier: _identifier.text.trim(),
      password: _password.text,
    );
    if (!mounted || session == null) return;
    context.go('/otp');
  }

  void _socialTap(String provider) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$provider sign-in coming soon')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenHorizontalAlt,
            24,
            AppSpacing.screenHorizontal,
            24,
          ),
          child: Column(
            children: [
              const SizedBox(height: 40),
              const GrozzbyLogo(height: 50),
              const SizedBox(height: 43),
              Text('Sign in to  Continue ', style: AppTextStyles.titleBold20),
              const SizedBox(height: 24),
              GrozzbyTextField(
                controller: _identifier,
                hint: 'Email  or Phone number',
                leadingIcon: AppAssets.icons.profile,
              ),
              const SizedBox(height: 18),
              GrozzbyTextField(
                controller: _password,
                hint: 'Password',
                leadingIcon: AppAssets.icons.password,
                obscureText: _obscure,
                trailing: IconButton(
                  icon: GrozzbyAsset(AppAssets.icons.visibility, width: 24, height: 24),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
              if (auth.errorMessage != null) ...[
                const SizedBox(height: 12),
                Text(auth.errorMessage!, style: AppTextStyles.labelRegular12.copyWith(color: AppColors.accentRed)),
              ],
              const SizedBox(height: 18),
              GrozzbyPrimaryButton(
                label: 'Sign in',
                fontSize: 20,
                isLoading: auth.isLoading,
                onPressed: _submit,
              ),
              const SizedBox(height: 34),
              GestureDetector(
                onTap: () => context.go('/create-account'),
                child: RichText(
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
              ),
              const SizedBox(height: 26),
              SocialLoginSection(showBorder: true, onSocialTap: _socialTap),
              const SizedBox(height: 26),
              const TermsFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
