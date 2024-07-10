import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uttam_toys_app/screens/auth/login_screen.dart';
import 'package:uttam_toys_app/screens/forgot_password/forgot_otp_verification.dart';
import 'package:uttam_toys_app/utils/dimensions.dart';
import 'package:uttam_toys_app/utils/intentutils.dart';
import 'package:uttam_toys_app/utils/validation_utils.dart';

import '../../utils/custom_color.dart';
import '../../utils/custom_style.dart';
import '../../utils/size.dart';
import '../../utils/ui_utils.dart';
import '../../widgets/appbar_common.dart';
import '../../widgets/primary_button.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  AutovalidateMode _autoValidate = AutovalidateMode.disabled;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  void _onBackPressed() {
    Navigator.of(context).pop();
    // IntentUtils.fireIntent(context: context, screen: LoginScreen(), finishAll: true);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        if (context.mounted) {
          _onBackPressed();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CommonAppbar(
          title: 'Forgot Password',
          leadingOnTap: _onBackPressed,
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(
                horizontal: Dimensions.widthSize,
                vertical: Dimensions.heightSize
            ),
            children: [
              addVerticalSpace(Dimensions.heightSize*2),
              Text(
                'Password assistance',
                textAlign: TextAlign.start,
                style: CustomStyle.blackMediumTextStyle.copyWith(
                  fontWeight: FontWeight.w600
                ),),
              Text('Lorem ipsum dolor sit amet consectetur. Nulla eleifend duis fames tellus.',
                textAlign: TextAlign.start,
                style: CustomStyle.regularBlackLightText,),
              addVerticalSpace(Dimensions.marginSize),
              Text('Email or Mobile number',style: CustomStyle.smallHeadingTextStyle,),
              addVerticalSpace(Dimensions.heightSize*0.5),
              _emailTextField(),
              addVerticalSpace(Dimensions.marginSize),
              PrimaryButtonWidget(
                isLoading: _isLoading,
                text: 'Continue', onPressed: () {
                if(_formKey.currentState!.validate())
                {
                  IntentUtils.fireIntent(context: context, screen: ForgotOtpVerification(), finishAll: false);
                }
                else{
                  setState(() {
                    _autoValidate =
                        AutovalidateMode.onUserInteraction;
                  });
                }
              },)
              .marginSymmetric(
                horizontal: Dimensions.marginSize,
                vertical: 0
              ),
              addVerticalSpace(Dimensions.heightSize),
            ],
          ),
        ),
      ),
    );
  }

  _emailTextField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.text,
      cursorColor: CustomColor.primaryColor,
      decoration: InputDecoration(
          border: UIUtils.textInputBorder,
          contentPadding: UIUtils.textinputPadding,
          errorBorder: UIUtils.errorBorder,
          enabledBorder: UIUtils.textInputBorder,
          focusedBorder: UIUtils.textInputBorder,
          errorStyle: CustomStyle.errorTextStyle,
          filled: false,
          hintText: 'Enter your Email/Mobile number',
          hintStyle: CustomStyle.hintTextStyle
      ),
      style: CustomStyle.inputTextStyle,
      textAlign: TextAlign.start,
      autovalidateMode: _autoValidate,
      validator: emailOrPhoneValidator,
    );
  }
}
