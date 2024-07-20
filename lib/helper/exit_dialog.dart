import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uttam_toys/utils/size.dart';
import '../utils/custom_color.dart';
import '../utils/custom_style.dart';
import '../utils/dimensions.dart';
import '../widgets/primary_button.dart';

class ExitDialog extends StatelessWidget {
  final String exitText,msg;
  final VoidCallback onPressed,onCancel;

  const ExitDialog({
    super.key,
    required this.onPressed,
    required this.onCancel,
    required this.msg,
    this.exitText = 'YES'
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius*0.5)
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: Dimensions.heightSize,
          horizontal: Dimensions.widthSize
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              msg,
              textAlign: TextAlign.center,
              style: CustomStyle.regularBlackText,
            ),
            // Text(
            //   subtitle,
            //   style: CustomStyle.inputTextStyle,
            // ),
            addVerticalSpace(Dimensions.heightSize),
            Row(
              mainAxisAlignment: mainCenter,
              children: [
                PrimaryButtonWidget(
                  smallButton: true,
                  radius: Dimensions.radius*2,
                  width: 100,
                  onPressed: onCancel,
                  text: 'NO',
                ),
                PrimaryButtonWidget(
                  width: 100,
                  backgroundColor: CustomColor.errorColor,
                  textColor: CustomColor.whiteColor,
                  radius: Dimensions.radius*2,
                  smallButton: true,
                  onPressed: onPressed,
                  text: exitText,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
