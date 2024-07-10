import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'custom_color.dart';
import 'dimensions.dart';

class CustomStyle {
  //auth screens
  static var largeBlackStyle = GoogleFonts.poppins(
    color: Colors.black,
    fontSize: Dimensions.largeTextSize,
    fontWeight: FontWeight.w700,
  );

  static var regularBlackLightText = GoogleFonts.poppins(
    color: CustomColor.blackColor,
    fontSize: Dimensions.regularTextSize,
    fontWeight: FontWeight.w400,
  );

  static var regularBlackText = GoogleFonts.poppins(
    color: CustomColor.blackColor,
    fontSize: Dimensions.regularTextSize,
    fontWeight: FontWeight.w500,
  );

  static var appbarTextTitleWhite = GoogleFonts.poppins(
    color: CustomColor.whiteColor,
    fontSize: Dimensions.mediumTextSize,
    fontWeight: FontWeight.w500,
  );

  static var appbarTextTitleDark = GoogleFonts.poppins(
    color: CustomColor.blackColor,
    fontSize: Dimensions.mediumTextSize,
    fontWeight: FontWeight.w600,
  );

  static var primarySemiBoldText = GoogleFonts.poppins(
    color: CustomColor.primaryColor,
    fontSize: Dimensions.mediumTextSize,
    fontWeight: FontWeight.w500,
  );

  static var primaryRegularBoldText = GoogleFonts.poppins(
    color: CustomColor.primaryColor,
    fontSize: Dimensions.regularTextSize,
    fontWeight: FontWeight.w500,
  );

  static var blackMediumTextStyle = GoogleFonts.poppins(
    color: CustomColor.blackColor,
    fontSize: Dimensions.mediumTextSize,
    fontWeight: FontWeight.w500,
  );

  static var buttonWhiteTextStyle = GoogleFonts.poppins(
    color: CustomColor.whiteColor,
    fontSize: Dimensions.mediumTextSize,
    fontWeight: FontWeight.w600,
  );

  static var smallHeadingTextStyle = GoogleFonts.poppins(
    color: CustomColor.blackColor,
    fontSize: Dimensions.smallestTextSize,
    fontWeight: FontWeight.w500,
  );

  static var numberInputTextStyle = GoogleFonts.inter(
    color: CustomColor.blackColor,
    fontSize: Dimensions.smallTextSize,
    fontWeight: FontWeight.w500,
  );

  static var hintTextStyle = GoogleFonts.poppins(
    color: CustomColor.hintColor,
    fontSize: Dimensions.smallestTextSize,
    fontWeight: FontWeight.w400,
  );

  static var errorTextStyle = GoogleFonts.poppins(
    color: CustomColor.errorColor,
    fontSize: Dimensions.smallestTextSize,
    fontWeight: FontWeight.w400,
  );

  static var inputTextStyle = GoogleFonts.poppins(
    color: CustomColor.blackColor,
    fontSize: Dimensions.smallTextSize,
    fontWeight: FontWeight.w500,
  );

  static var blackSmallestTextStyle = GoogleFonts.poppins(
    color: CustomColor.blackColor,
    fontSize: Dimensions.smallestTextSize,
    fontWeight: FontWeight.w400,
  );

  static var cancelledTextStyle = GoogleFonts.poppins(
    color: CustomColor.hintColor,
    fontSize: Dimensions.smallestTextSize,
    fontWeight: FontWeight.w400,
    decoration: TextDecoration.lineThrough,
    decorationColor: CustomColor.hintColor
  );

}
