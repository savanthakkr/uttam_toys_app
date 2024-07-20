import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:uttam_toys/utils/dimensions.dart';
import 'package:uttam_toys/utils/size.dart';

import '../utils/custom_color.dart';
import '../utils/custom_style.dart';

class PasswordTipsDialog extends StatelessWidget {

  PasswordTipsDialog({Key? key}) : super(key: key) {}

  dialogContent(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: Dimensions.heightSize,
        horizontal: Dimensions.widthSize
      ),
        child: Column(
          crossAxisAlignment: crossStart,
          mainAxisSize: mainMin,
          children: [
            Text(
              'Secure password tips',
              style: CustomStyle.blackMediumTextStyle,
              textAlign: TextAlign.center,
            ),
            _pointView('At least 6 characters long but 8 or more is better'),
            _pointView('Must include one upper & lower case'),
            _pointView('Must include at least one number'),
            _pointView('Must include atl least one special characters'),
            _pointView('Not a name or anything which is easy to guess'),
          ],
        )
    );
  }

  _pointView(String text)
  {
    return Row(
      crossAxisAlignment: crossCenter,
      children: [
        Icon(
          Icons.circle,
          color: Colors.black,
          size: 7,
        ),
        addHorizontalSpace(Dimensions.widthSize*0.2),
        Expanded(
          child: Text(
            text,
            maxLines: 2,
            style: CustomStyle.blackSmallestTextStyle,
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.center,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0.0,
      backgroundColor: Colors.white,
      child: dialogContent(context),
    );
  }
}