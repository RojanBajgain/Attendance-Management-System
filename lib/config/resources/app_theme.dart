import 'package:ams/config/resources/colors.dart';
import 'package:ams/config/resources/dimens.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AppTheme {
  static final lightTheme = ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: Colors.white,
      cardColor: AppColors.cardGrey,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.black,
      ),
      iconTheme: const IconThemeData(color: AppColors.black),
      textTheme: TextTheme(
        bodyLarge: GoogleFonts.poppins(
          textStyle: TextStyle(
            fontSize: AppDimens.large.sp,
            color: Colors.black,
          ),
        ),
        bodyMedium: GoogleFonts.poppins(
          textStyle: TextStyle(
            fontSize: AppDimens.medium.sp,
            color: Colors.black,
          ),
        ),
        bodySmall: GoogleFonts.poppins(
          textStyle: TextStyle(
            fontSize: AppDimens.normal.sp,
            color: Colors.black,
          ),
        ),
        titleLarge: GoogleFonts.poppins(
          textStyle: TextStyle(
            fontSize: AppDimens.large.sp,
            color: Colors.black,
          ),
        ),
        titleMedium: GoogleFonts.poppins(
          textStyle: TextStyle(
            fontSize: AppDimens.small.sp,
            color: Colors.black,
          ),
        ),
        labelSmall: GoogleFonts.poppins(
          textStyle: TextStyle(
            fontSize: AppDimens.mini.sp,
            color: Colors.black,
          ),
        ),
      ));

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.tertiary,
    scaffoldBackgroundColor: const Color(0xff121212),
    cardColor: AppColors.green,
    iconTheme: const IconThemeData(color: AppColors.white),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.black,
      foregroundColor: AppColors.white,
    ),
    textTheme: TextTheme(
      bodyLarge: GoogleFonts.poppins(
        textStyle: TextStyle(
          fontSize: AppDimens.large.sp,
          color: Colors.white,
        ),
      ),
      bodyMedium: GoogleFonts.poppins(
        textStyle: TextStyle(
          fontSize: AppDimens.medium.sp,
          color: Colors.white,
        ),
      ),
      bodySmall: GoogleFonts.poppins(
        textStyle: TextStyle(
          fontSize: AppDimens.normal.sp,
          color: Colors.white,
        ),
      ),
      titleLarge: GoogleFonts.poppins(
        textStyle: TextStyle(
          fontSize: AppDimens.large.sp,
          color: Colors.white,
        ),
      ),
      titleMedium: GoogleFonts.poppins(
        textStyle: TextStyle(
          fontSize: AppDimens.small.sp,
          color: Colors.white,
        ),
      ),
      labelSmall: GoogleFonts.poppins(
        textStyle: TextStyle(
          fontSize: AppDimens.mini.sp,
          color: Colors.white,
        ),
      ),
    ),
  );
}
