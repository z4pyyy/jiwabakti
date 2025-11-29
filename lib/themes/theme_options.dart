import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

class ThemeOptions implements AppThemeOptions {
  final Color primaryColor;
  final Color primaryColorLight;
  final Color primaryColorUnselect;
  final Color secondaryColor;
  final Color secondaryColorLight;
  final Color textColor;
  final Color textColorOnPrimary;
  final Color textColorOnSecondary;
  final Color backgroundColor;
  final Color secondaryBackgroundColor;
  final Color successColor;
  final Color warningColor;
  final Color errorColor;
  final Color iconColor;
  final Color iconColorSelected;
  final Color whiteBackground;

  final double textTitleSize1;
  final double textTitleSize2;
  final double textSize1;
  final double textSize2;
  final double textSize3;
  final double textSize4;
  final double textSize5;
  final double appBarTextSize;

  final double textTitleSize1Tablet;
  final double textTitleSize2Tablet;
  final double textSize1Tablet;
  final double textSize2Tablet;
  final double textSize3Tablet;
  final double textSize4Tablet;
  final double textSize5Tablet;
  final double appBarTextSizeTablet;

  final double textFormBorderSize;
  final double imageUploaderWidth3;
  final double imageUploaderWidth4;
  final double textFormSpaceBetween;

  final double horizontal;
  final double vertical;

  ThemeOptions({
    required this.primaryColor,
    required this.primaryColorLight,
    required this.primaryColorUnselect,
    required this.secondaryColor,
    required this.secondaryColorLight,
    required this.textColor,
    required this.textColorOnPrimary,
    required this.textColorOnSecondary,
    required this.backgroundColor,
    required this.secondaryBackgroundColor,
    required this.successColor,
    required this.warningColor,
    required this.errorColor,
    required this.iconColor,
    required this.iconColorSelected,
    required this.whiteBackground,
    required this.textTitleSize1,
    required this.textTitleSize2,
    required this.textSize1,
    required this.textSize2,
    required this.textSize3,
    required this.textSize4,
    required this.textSize5,
    required this.appBarTextSize,
    required this.textTitleSize1Tablet,
    required this.textTitleSize2Tablet,
    required this.textSize1Tablet,
    required this.textSize2Tablet,
    required this.textSize3Tablet,
    required this.textSize4Tablet,
    required this.textSize5Tablet,
    required this.appBarTextSizeTablet,
    required this.textFormBorderSize,
    required this.imageUploaderWidth3,
    required this.imageUploaderWidth4,
    required this.textFormSpaceBetween,
    required this.horizontal,
    required this.vertical,
  });
}
