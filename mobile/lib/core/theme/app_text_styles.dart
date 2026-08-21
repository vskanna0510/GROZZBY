import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

abstract final class AppTextStyles {
  static TextStyle get displayBlack30 => GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w900,
        height: 40 / 32,
        letterSpacing: -0.96,
        color: AppColors.warningForeground,
      );

  static TextStyle get titleBold20 => GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        height: 1.0,
        color: AppColors.black,
      );

  static TextStyle get titleSemiBold20 => GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.0,
        color: AppColors.black,
      );

  static TextStyle get titleBlack20 => GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w900,
        height: 28 / 20,
        color: AppColors.warningForeground,
      );

  static TextStyle get bodySemiBold16 => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.0,
        color: AppColors.black,
      );

  static TextStyle get bodyRegular14 => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 20 / 14,
        color: AppColors.neutral500,
      );

  static TextStyle get bodySemiBold14 => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 20 / 14,
        color: AppColors.black,
      );

  static TextStyle get bodyBlack14 => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w900,
        height: 20 / 14,
        color: AppColors.neutral800,
      );

  static TextStyle get labelMedium12 => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.0,
        color: AppColors.mutedForeground,
      );

  static TextStyle get labelBold12 => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        height: 1.0,
        color: AppColors.neutral950,
      );

  static TextStyle get labelSemiBold12 => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 1.0,
        color: AppColors.neutral700,
      );

  static TextStyle get labelRegular12 => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.0,
        color: AppColors.black,
      );

  static TextStyle get labelBold12Inter => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        height: 16 / 12,
        color: AppColors.warningForeground,
      );

  static TextStyle get captionMedium11 => GoogleFonts.poppins(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        height: 1.0,
        color: AppColors.secondary,
      );

  static TextStyle get captionBlack10 => GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w900,
        height: 15 / 10,
        color: AppColors.warningForeground,
      );

  static TextStyle get onboardingTitle => GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w900,
        height: 40 / 32,
        letterSpacing: -0.96,
        color: AppColors.white,
      );

  static TextStyle get onboardingSubtitle => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 20 / 14,
        color: AppColors.subtitleWhite,
      );

  static TextStyle get headingBold24 => GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 32 / 24,
        color: AppColors.neutral900,
      );

  static TextStyle get headingBold20 => GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        height: 28 / 20,
        color: AppColors.neutral900,
      );

  static TextStyle get headingSemiBold18 => GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 24 / 18,
        color: AppColors.neutral900,
      );

  static TextStyle get headingBold18 => GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        height: 24 / 18,
        color: AppColors.neutral900,
      );

  static TextStyle get headingSemiBold16 => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 22 / 16,
        color: AppColors.neutral900,
      );

  static TextStyle get priceBold20 => GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        height: 24 / 20,
        color: AppColors.primaryDark,
      );

  static TextStyle get priceBold16 => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        height: 20 / 16,
        color: AppColors.primaryDark,
      );

  static TextStyle get priceOld12 => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 16 / 12,
        decoration: TextDecoration.lineThrough,
        color: AppColors.neutral400,
      );

  static TextStyle get bodyMedium14 => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 20 / 14,
        color: AppColors.neutral700,
      );

  static TextStyle get bodyRegular13 => GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 18 / 13,
        color: AppColors.neutral600,
      );

  static TextStyle get labelMedium11 => GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        height: 14 / 11,
        color: AppColors.neutral500,
      );

  static TextStyle get captionRegular10 => GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        height: 14 / 10,
        color: AppColors.neutral500,
      );

  static TextStyle get whiteBodySemiBold16 => bodySemiBold16.copyWith(color: AppColors.white);

  // Semantic aliases
  static TextStyle get displayLarge => GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        color: AppColors.neutral900,
      );

  static TextStyle get bodyLarge => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.neutral900,
      );

  static TextStyle get bodyMedium => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.neutral900,
      );

  static TextStyle get caption => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.neutral500,
      );

  static TextStyle get button => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppColors.white,
      );

  // Account Page Specific Typography
  static TextStyle get accountHeroName => GoogleFonts.inter(
        fontSize: 26,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
        color: AppColors.white,
      );

  static TextStyle get accountHeroButton => GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.white,
      );

  static TextStyle get accountSectionTitle => GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
        color: AppColors.neutral900,
      );

  static TextStyle get quickActionTitle => GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: AppColors.neutral900,
      );

  static TextStyle get quickActionSubtitle => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.neutral500,
      );

  static TextStyle get settingRowTitle => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.neutral900,
      );

  static TextStyle get settingRowSubtitle => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.3,
        color: AppColors.neutral500,
      );
}

