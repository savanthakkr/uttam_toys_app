import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:uttam_toys_app/screens/change_password_screen.dart';
import 'package:uttam_toys_app/utils/custom_color.dart';
import 'package:uttam_toys_app/utils/custom_style.dart';
import 'package:uttam_toys_app/utils/dimensions.dart';
import 'package:uttam_toys_app/widgets/appbar_common.dart';

import '../utils/intentutils.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {

  void _onBackPressed() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        onPopInvoked: (didPop) {
          if (didPop) {
            return;
          }
          if (context.mounted) {
            _onBackPressed();
          }
        },
        child: Scaffold(
          backgroundColor: CustomColor.backgroundColor,
          appBar: CommonAppbar(
            title: 'Login & Security',
            leadingOnTap: _onBackPressed,
            hasBottom: true,
          ),
          body: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.widthSize,
              vertical: Dimensions.heightSize
            ),
            children: [
              Card(
                elevation: 0,
                color: CustomColor.whiteColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimensions.radius*0.8),
                  side: BorderSide(color: CustomColor.borderColor,width: 1)
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.widthSize,
                      vertical: Dimensions.heightSize
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 8,
                        child: Column(
                          children: [
                            Text('Password',style: CustomStyle.regularBlackText,),
                            Text('Last Updated on 11-May 2024 at 11:00 AM',style: CustomStyle.hintTextStyle,)
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          IntentUtils.fireIntent(context: context, screen: ChangePasswordScreen(), finishAll: false);
                        },
                        child: Text('Update',style: CustomStyle.smallHeadingTextStyle.copyWith(
                          color: CustomColor.primaryColor
                        ),),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        )
    );
  }
}
