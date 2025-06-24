import 'package:flutter/material.dart';
import 'package:runmate_app/shared/themes/app_colors.dart';
import 'package:runmate_app/shared/themes/app_fonts.dart';
import 'package:runmate_app/shared/themes/app_text_height.dart';

// coverage:ignore-file

class AppTextStyle {
  final TextStyle Function(Color) customColor;

  const AppTextStyle(this.customColor);

  TextStyle defaultStyle() {
    return customColor(AppColors.infoBrand);
  }
}

AppTextStyle displayLgSemiBold = AppTextStyle(
  (color) => TextStyle(
    decoration: TextDecoration.none,
    fontFamily: AppFonts.poppinsSemiBold,
    fontWeight: FontWeight.w600,
    color: color,
    fontSize: 36,
    height: AppTextHeight.size36WithLineHeight44,
  ),
);

AppTextStyle displayLgMedium = AppTextStyle(
  (color) => TextStyle(
    decoration: TextDecoration.none,
    fontFamily: AppFonts.poppinsMedium,
    fontWeight: FontWeight.w500,
    color: color,
    fontSize: 36,
    height: AppTextHeight.size36WithLineHeight44,
  ),
);

AppTextStyle displayLgRegular = AppTextStyle(
  (color) => TextStyle(
    decoration: TextDecoration.none,
    fontFamily: AppFonts.poppinsRegular,
    fontWeight: FontWeight.w400,
    color: color,
    fontSize: 36,
    height: AppTextHeight.size36WithLineHeight44,
  ),
);

AppTextStyle displaySmSemiBold = AppTextStyle(
  (color) => TextStyle(
    decoration: TextDecoration.none,
    fontFamily: AppFonts.poppinsSemiBold,
    fontWeight: FontWeight.w600,
    color: color,
    fontSize: 32,
    height: AppTextHeight.size32WithLineHeight40,
  ),
);

AppTextStyle displaySmMedium = AppTextStyle(
  (color) => TextStyle(
    decoration: TextDecoration.none,
    fontFamily: AppFonts.poppinsMedium,
    fontWeight: FontWeight.w500,
    color: color,
    fontSize: 32,
    height: AppTextHeight.size32WithLineHeight40,
  ),
);

AppTextStyle displaySmRegular = AppTextStyle(
  (color) => TextStyle(
    decoration: TextDecoration.none,
    fontFamily: AppFonts.poppinsRegular,
    fontWeight: FontWeight.w400,
    color: color,
    fontSize: 32,
    height: AppTextHeight.size32WithLineHeight40,
  ),
);

AppTextStyle titleLgSemiBold = AppTextStyle(
  (color) => TextStyle(
    decoration: TextDecoration.none,
    fontFamily: AppFonts.poppinsSemiBold,
    fontWeight: FontWeight.w600,
    color: color,
    fontSize: 24,
    height: AppTextHeight.size24WithLineHeight32,
  ),
);

AppTextStyle titleLgMedium = AppTextStyle(
  (color) => TextStyle(
    decoration: TextDecoration.none,
    fontFamily: AppFonts.poppinsMedium,
    fontWeight: FontWeight.w500,
    color: color,
    fontSize: 24,
    height: AppTextHeight.size24WithLineHeight32,
  ),
);

AppTextStyle titleLgRegular = AppTextStyle(
  (color) => TextStyle(
    decoration: TextDecoration.none,
    fontFamily: AppFonts.poppinsRegular,
    fontWeight: FontWeight.w400,
    color: color,
    fontSize: 24,
    height: AppTextHeight.size24WithLineHeight32,
  ),
);

AppTextStyle titleSmSemiBold = AppTextStyle(
  (color) => TextStyle(
    decoration: TextDecoration.none,
    fontFamily: AppFonts.poppinsSemiBold,
    fontWeight: FontWeight.w600,
    color: color,
    fontSize: 20,
    height: AppTextHeight.size20WithLineHeight30,
  ),
);

AppTextStyle titleSmMedium = AppTextStyle(
  (color) => TextStyle(
    decoration: TextDecoration.none,
    fontFamily: AppFonts.poppinsMedium,
    fontWeight: FontWeight.w500,
    color: color,
    fontSize: 20,
    height: AppTextHeight.size20WithLineHeight30,
  ),
);

AppTextStyle titleSmRegular = AppTextStyle(
  (color) => TextStyle(
    decoration: TextDecoration.none,
    fontFamily: AppFonts.poppinsRegular,
    fontWeight: FontWeight.w400,
    color: color,
    fontSize: 20,
    height: AppTextHeight.size20WithLineHeight30,
  ),
);

AppTextStyle subtitleLgSemiBold = AppTextStyle(
  (color) => TextStyle(
    decoration: TextDecoration.none,
    fontFamily: AppFonts.poppinsSemiBold,
    fontWeight: FontWeight.w600,
    color: color,
    fontSize: 16,
    height: AppTextHeight.size16WithLineHeight24,
  ),
);

AppTextStyle subtitleLgMedium = AppTextStyle(
  (color) => TextStyle(
    decoration: TextDecoration.none,
    fontFamily: AppFonts.poppinsMedium,
    fontWeight: FontWeight.w500,
    color: color,
    fontSize: 16,
    height: AppTextHeight.size16WithLineHeight24,
  ),
);

AppTextStyle subtitleLgRegular = AppTextStyle(
  (color) => TextStyle(
    decoration: TextDecoration.none,
    fontFamily: AppFonts.poppinsRegular,
    fontWeight: FontWeight.w400,
    color: color,
    fontSize: 16,
    height: AppTextHeight.size16WithLineHeight24,
  ),
);

AppTextStyle subtitleSmSemiBold = AppTextStyle(
  (color) => TextStyle(
    decoration: TextDecoration.none,
    fontFamily: AppFonts.poppinsSemiBold,
    fontWeight: FontWeight.w600,
    color: color,
    fontSize: 14,
    height: AppTextHeight.size14WithLineHeight20,
  ),
);

AppTextStyle subtitleSmMedium = AppTextStyle(
  (color) => TextStyle(
    decoration: TextDecoration.none,
    fontFamily: AppFonts.poppinsMedium,
    fontWeight: FontWeight.w500,
    color: color,
    fontSize: 14,
    height: AppTextHeight.size14WithLineHeight20,
  ),
);

AppTextStyle subtitleSmRegular = AppTextStyle(
  (color) => TextStyle(
    decoration: TextDecoration.none,
    fontFamily: AppFonts.poppinsRegular,
    fontWeight: FontWeight.w400,
    color: color,
    fontSize: 14,
    height: AppTextHeight.size14WithLineHeight20,
  ),
);

AppTextStyle bodyLgSemiBold = AppTextStyle(
  (color) => TextStyle(
    decoration: TextDecoration.none,
    fontFamily: AppFonts.poppinsSemiBold,
    fontWeight: FontWeight.w600,
    color: color,
    fontSize: 12,
    height: AppTextHeight.size12WithLineHeight16,
  ),
);

AppTextStyle bodyLgMedium = AppTextStyle(
  (color) => TextStyle(
    decoration: TextDecoration.none,
    fontFamily: AppFonts.poppinsMedium,
    fontWeight: FontWeight.w500,
    color: color,
    fontSize: 12,
    height: AppTextHeight.size12WithLineHeight16,
  ),
);

AppTextStyle bodyLgRegular = AppTextStyle(
  (color) => TextStyle(
    decoration: TextDecoration.none,
    fontFamily: AppFonts.poppinsRegular,
    fontWeight: FontWeight.w400,
    color: color,
    fontSize: 12,
    height: AppTextHeight.size12WithLineHeight16,
  ),
);

AppTextStyle bodySmSemiBold = AppTextStyle(
  (color) => TextStyle(
    decoration: TextDecoration.none,
    fontFamily: AppFonts.poppinsSemiBold,
    fontWeight: FontWeight.w600,
    color: color,
    fontSize: 10,
    height: AppTextHeight.size10WithLineHeight16,
  ),
);

AppTextStyle bodySmMedium = AppTextStyle(
  (color) => TextStyle(
    decoration: TextDecoration.none,
    fontFamily: AppFonts.poppinsMedium,
    fontWeight: FontWeight.w500,
    color: color,
    fontSize: 10,
    height: AppTextHeight.size10WithLineHeight16,
  ),
);

AppTextStyle bodySmRegular = AppTextStyle(
  (color) => TextStyle(
    decoration: TextDecoration.none,
    fontFamily: AppFonts.poppinsRegular,
    fontWeight: FontWeight.w400,
    color: color,
    fontSize: 10,
    height: AppTextHeight.size10WithLineHeight16,
  ),
);
