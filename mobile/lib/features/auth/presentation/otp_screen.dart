import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/grozzby_logo.dart';
import '../../../shared/widgets/grozzby_primary_button.dart';
import '../../../shared/widgets/otp_loading_indicator.dart';
import '../../../shared/widgets/otp_segment_toggle.dart';
import '../../../shared/widgets/terms_footer.dart';
import 'auth_controller.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _pinController = TextEditingController();

  static const _contentWidth = 358.0;
  static const _buttonWidth = 311.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<AuthController>().resetOtpState();
    });
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  String _maskedContact(AuthController auth) {
    final session = auth.pendingSession;
    if (session == null) return '';
    return auth.otpChannel == 'phone'
        ? session.maskedPhone
        : session.maskedEmail;
  }

  Future<void> _verify(String code) async {
    if (code.length != 6) return;
    final auth = context.read<AuthController>();
    if (auth.otpVerifying || auth.otpAccepted) return;
    auth.clearError();
    final user = await auth.verifyOtp(code);
    if (!mounted) return;
    if (user != null) {
      await Future.delayed(const Duration(milliseconds: 600));
      if (!mounted) return;
      context.go('/welcome');
    }
  }

  Future<void> _onContinue(AuthController auth) async {
    if (auth.otpAccepted) {
      if (!mounted) return;
      context.go('/welcome');
      return;
    }
    await _verify(_pinController.text);
  }

  Future<void> _onChannelChanged(String channel) async {
    final auth = context.read<AuthController>();
    if (auth.otpVerifying || auth.otpAccepted) return;
    auth.setOtpChannel(channel);
    await auth.resendOtp();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Verification code sent via $channel')),
    );
  }

  Widget _buildOtpBody(AuthController auth) {
    if (auth.otpVerifying) {
      return const OtpLoadingIndicator(animate: true);
    }

    if (auth.otpAccepted) {
      return const Column(
        children: [
          OtpLoadingIndicator(animate: false),
          SizedBox(height: AppSpacing.s9),
          OtpAcceptedRow(),
        ],
      );
    }

    final defaultPinTheme = PinTheme(
      width: 45,
      height: 50,
      textStyle: AppTextStyles.titleBold20,
      decoration: BoxDecoration(
        color: AppColors.input,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
    );

    return Pinput(
      controller: _pinController,
      length: 6,
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: defaultPinTheme.copyWith(
        decoration: defaultPinTheme.decoration!.copyWith(
          border: Border.all(color: AppColors.secondary, width: 2),
        ),
      ),
      onCompleted: _verify,
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    final session = auth.pendingSession;
    if (session == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.go('/sign-in');
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final channelLabel = auth.otpChannel == 'email' ? 'Email' : 'Phone';
    final canEdit = !auth.otpVerifying && !auth.otpAccepted;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenHorizontal,
            10,
            AppSpacing.s7,
            24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 114),
              const GrozzbyLogo(height: 66),
              const SizedBox(height: AppSpacing.s12),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: _contentWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Enter Verification Code',
                        style: AppTextStyles.titleBlack20,
                      ),
                      const SizedBox(height: AppSpacing.s1),
                      Text(
                        'Enter the 6-digit we code sent to $channelLabel ${_maskedContact(auth)}',
                        style: AppTextStyles.bodyRegular14,
                      ),
                      const SizedBox(height: AppSpacing.s9),
                      IgnorePointer(
                        ignoring: !canEdit,
                        child: Opacity(
                          opacity: canEdit ? 1 : 0.55,
                          child: OtpSegmentToggle(
                            selected: auth.otpChannel,
                            onChanged: _onChannelChanged,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.s9),
                      Center(child: _buildOtpBody(auth)),
                      if (auth.errorMessage != null) ...[
                        const SizedBox(height: AppSpacing.s3),
                        Text(
                          auth.errorMessage!,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.labelRegular12.copyWith(
                            color: AppColors.accentRed,
                          ),
                        ),
                      ],
                      const SizedBox(height: AppSpacing.s16),
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: _buttonWidth,
                          child: GrozzbyPrimaryButton(
                            label: 'Continue',
                            isLoading: auth.isLoading && !auth.otpAccepted,
                            onPressed: () => _onContinue(auth),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.s4),
                      const TermsFooter(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
