import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:uttam_toys_app/screens/forgot_password/reset_password_screen.dart';
import 'package:uttam_toys_app/utils/intentutils.dart';
import 'package:uttam_toys_app/utils/validation_utils.dart';

import '../../utils/custom_color.dart';
import '../../utils/custom_style.dart';
import '../../utils/dimensions.dart';
import '../../utils/size.dart';
import '../../widgets/appbar_common.dart';
import '../../widgets/primary_button.dart';

class ForgotOtpVerification extends StatefulWidget {
  const ForgotOtpVerification({super.key});

  @override
  State<ForgotOtpVerification> createState() => _ForgotOtpVerificationState();
}

class _ForgotOtpVerificationState extends State<ForgotOtpVerification> {
  TextEditingController _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  AutovalidateMode _autoValidate = AutovalidateMode.disabled;

  void _onBackPressed() {
    // IntentUtils.fireIntent(context, const MobileVerifyScreen());
    Navigator.of(context).pop();
    // return false;
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
          title: 'Verification',
          leadingOnTap: _onBackPressed,
        ),
        body: Form(
          key: _formKey,
          canPop: false,
          child: ListView(
            padding: EdgeInsets.symmetric(
                vertical: Dimensions.heightSize,
                horizontal: Dimensions.widthSize*1.5
            ),
            children: [
              addVerticalSpace(Dimensions.heightSize*2),
              Text(
                'Authentication Required',
                textAlign: TextAlign.start,
                style: CustomStyle.blackMediumTextStyle.copyWith(
                    fontWeight: FontWeight.w600
                ),),
              Text('Lorem ipsum dolor sit amet consectetur. Pretium sit pulvinar maecenas pellentesque quam mauris eu. Lectus ornare pharetra arcu nulla dignissim nisi. Diam eget elementum et vel ipsum lacinia maecenas commodo.',
                textAlign: TextAlign.start,
                style: CustomStyle.regularBlackLightText,),
              addVerticalSpace(Dimensions.marginSize),
              Text('Enter the OTP sent to your mobile number',
                textAlign: TextAlign.center,
                style: CustomStyle.smallHeadingTextStyle,),
              addVerticalSpace(Dimensions.heightSize*0.5),
              _otpField(),
              addVerticalSpace(Dimensions.heightSize),
              InkWell(
                onTap: (){
                  // IntentUtils.fireIntentwithoutFinish(context, SignUpScreen());
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Don’t receive OTP? ',
                      style: CustomStyle.blackSmallestTextStyle,
                      textAlign: TextAlign.center,),
                    Text('RESEND'.toUpperCase(),
                      style: CustomStyle.blackSmallestTextStyle.copyWith(
                          color: CustomColor.primaryColor,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,),
                  ],
                ),
              ),
              addVerticalSpace(Dimensions.heightSize*1.5),
              PrimaryButtonWidget(
                isLoading: _isLoading,
                text: 'Verify', onPressed: () {
                if(_formKey.currentState!.validate())
                {
                  //todo verify otp
                  IntentUtils.fireIntent(context: context, screen: ResetPasswordScreen(), finishAll: true);
                  // loginUser();
                }
                else{
                  setState(() {
                    _autoValidate =
                        AutovalidateMode.onUserInteraction;
                  });
                }
              },),
            ],
          ),
        ),
      ),
    );
  }

  _otpField() {
    return PinCodeTextField(
      cursorColor: CustomColor.primaryColor,
      controller: _otpController,
      appContext: context,
      autovalidateMode: _autoValidate,
      length: 6,
      obscureText: false,
      keyboardType: TextInputType.number,
      textStyle: CustomStyle.numberInputTextStyle,
      animationType: AnimationType.fade,
      pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(Dimensions.radius*0.5),
          selectedColor: CustomColor.primaryColor,
          activeColor: CustomColor.primaryColor,
          inactiveColor: CustomColor.blackColor,
          fieldHeight: 50,
          fieldWidth: 50,
          activeFillColor: Colors.transparent,
          borderWidth: 1,
          inactiveBorderWidth: 1,
          activeBorderWidth: 1,
          fieldOuterPadding: const EdgeInsets.all(0)
      ),
      onChanged: (String value) {
        if(_isLoading)
        {
          setState(() {
            _isLoading = false;
          });
        }
        // if(value.isNotEmpty && value.length == 6){
        // }
      },
      validator: otpValidator,
    );
  }
}
