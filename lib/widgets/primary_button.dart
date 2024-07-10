import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/custom_color.dart';
import '../utils/dimensions.dart';

class PrimaryButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color? borderColor;
  final Color textColor;
  final double width;
  final double radius;
  final bool isLoading;
  final bool smallButton;
  final double elevation;

  const PrimaryButtonWidget({
    Key? key,
    required this.text,
    required this.onPressed,
    this.width = 0,
    this.backgroundColor = CustomColor.primaryColor,
    this.textColor = CustomColor.whiteColor,
    this.borderColor,
    this.radius = 30,
    this.isLoading = false,
    this.smallButton = false,
    this.elevation = 1
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 45,
      child: InkWell(
        onTap: onPressed,
        child: Card(
          elevation: elevation,
          color: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(radius),
            ),
            side: borderColor!=null ? BorderSide(
              width: 1,
              color: borderColor!,
            ) : BorderSide.none,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: Dimensions.heightSize*0.6,
              horizontal: Dimensions.widthSize*1.5
            ),
            child: Center(
              child: isLoading ? CircularProgressIndicator(
                color: backgroundColor == CustomColor.primaryColor? CustomColor.whiteColor : CustomColor.primaryColor,
              )
                  : Text(
                text,
                textAlign: TextAlign.center,
                style: smallButton ? GoogleFonts.poppins(
                  color: textColor,
                  fontSize: Dimensions.smallestTextSize,
                  fontWeight: FontWeight.w500,
                ) :
                GoogleFonts.poppins(
                  color: textColor,
                  fontSize: Dimensions.mediumTextSize,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
