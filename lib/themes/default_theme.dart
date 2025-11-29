import 'package:flutter/material.dart';
import 'package:jiwa_bakti/themes/theme_options.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:sizer/sizer.dart';

class DefaultTheme extends AppTheme {
  DefaultTheme()
      : super(
          id: "default_theme",
          description: "Default Theme",
          data: ThemeData.light().copyWith(
            dialogTheme: DialogThemeData(
              backgroundColor: const Color(0xFFFFFFFF),
              titleTextStyle: TextStyle(color: Colors.black, fontSize: 16.sp),
              contentTextStyle: TextStyle(color: Colors.black, fontSize: 10.sp),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF6D0000).withOpacity(0.75),
                textStyle: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500
                ),
              )
            ),
          ),
          options: ThemeOptions(
            primaryColor: const Color(0xFFE5332C),
            primaryColorLight: const Color(0xFFF9D6D4),
            primaryColorUnselect: const Color(0xFFF49791),
            secondaryColor: const Color(0xFF9A9A9A),
            secondaryColorLight: const Color(0xFFCCCCCC),
            whiteBackground: const Color(0xFFFFFFFF),
            textColor: const Color(0xFF000000),
            textColorOnPrimary: const Color(0xFFFFFFFF),
            textColorOnSecondary: const Color(0xFFFFFFFF),
            backgroundColor: const Color(0xFFFFFFFF),
            secondaryBackgroundColor: const Color(0xFFF6F6F6),
            successColor: const Color(0xFF198754),
            warningColor: const Color(0xFFE1B845),
            errorColor: const Color(0xFFDB5B53),
            iconColor: const Color(0xFF6F6F6F),
            iconColorSelected: const Color(0xFFE5332C),
            textTitleSize1: 22.sp,
            textTitleSize2: 18.sp,
            textSize1: 15.sp,
            textSize2: 13.sp,
            textSize3: 11.sp,
            textSize4: 10.sp,
            textSize5: 8.5.sp,
            appBarTextSize: 16.sp,
            textTitleSize1Tablet: 18.sp,
            textTitleSize2Tablet: 14.sp,
            textSize1Tablet: 12.sp,
            textSize2Tablet: 10.sp,
            textSize3Tablet: 8.sp,
            textSize4Tablet: 6.sp,
            textSize5Tablet: 5.sp,
            appBarTextSizeTablet: 14.sp,
            textFormBorderSize: 4.sp,
            imageUploaderWidth3: 30.w,
            imageUploaderWidth4: 22.w,
            textFormSpaceBetween: 2.h,
            horizontal: 3.w,
            vertical: 1.h,
          ),
        );
}
