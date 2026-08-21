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
import 'auth_controller.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_password.text != _confirm.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }
    final auth = context.read<AuthController>();
    auth.clearError();
    final session = await auth.register(
      name: _name.text.trim(),
      email: _email.text.trim(),
      phone: _phone.text.trim().isEmpty ? null : _phone.text.trim(),
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
            AppSpacing.screenHorizontal,
            56,
            AppSpacing.screenHorizontal,
            24,
          ),
          child: Column(
            children: [
              const GrozzbyLogo(height: 74),
              const SizedBox(height: 52),
              Text('Create Account', style: AppTextStyles.titleBold20),
              const SizedBox(height: 8),
              Text(
                'Create a new account to get started and enjoy seamless access to our features.',
                textAlign: TextAlign.center,
                style: AppTextStyles.labelMedium12,
              ),
              const SizedBox(height: 26),
              GrozzbyTextField(
                controller: _name,
                hint: 'Name',
                leadingIcon: AppAssets.icons.profile,
              ),
              const SizedBox(height: 18),
              GrozzbyTextField(
                controller: _email,
                hint: 'Email address',
                leadingIcon: AppAssets.icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 18),
              GrozzbyTextField(
                controller: _phone,
                hint: 'Phone (optional)',
                leadingIcon: AppAssets.icons.phone,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 18),
              GrozzbyTextField(
                controller: _password,
                hint: 'Password',
                leadingIcon: AppAssets.icons.password,
                obscureText: _obscurePassword,
                trailing: IconButton(
                  icon: GrozzbyAsset(AppAssets.icons.visibility, width: 24, height: 24),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
              const SizedBox(height: 18),
              GrozzbyTextField(
                controller: _confirm,
                hint: 'Confirm Password',
                leadingIcon: AppAssets.icons.password,
                obscureText: _obscureConfirm,
                trailing: IconButton(
                  icon: GrozzbyAsset(AppAssets.icons.visibility, width: 24, height: 24),
                  onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                ),
              ),
              if (auth.errorMessage != null) ...[
                const SizedBox(height: 12),
                Text(auth.errorMessage!, style: AppTextStyles.labelRegular12.copyWith(color: AppColors.accentRed)),
              ],
              const SizedBox(height: 18),
              GrozzbyPrimaryButton(
                label: 'Create Account',
                isLoading: auth.isLoading,
                onPressed: _submit,
              ),
              const SizedBox(height: 34),
              AuthLink(
                prefix: 'Already have an account? ',
                linkText: 'Sign in here',
                onTap: () => context.go('/sign-in'),
              ),
              const SizedBox(height: 29),
              SocialLoginSection(onSocialTap: _socialTap),
              const SizedBox(height: 26),
              const TermsFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
