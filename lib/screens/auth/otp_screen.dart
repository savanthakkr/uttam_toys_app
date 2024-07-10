import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:uttam_toys_app/utils/custom_style.dart';
import 'package:uttam_toys_app/utils/dimensions.dart';
import 'package:uttam_toys_app/utils/intentutils.dart';
import 'package:uttam_toys_app/widgets/primary_button.dart';

import '../../utils/assets.dart';
import '../../utils/custom_color.dart';
import '../../utils/size.dart';
import '../bottom/user_bottom_bar.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
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
        body: Form(
          key: _formKey,
          canPop: false,
          child: ListView(
            padding: EdgeInsets.symmetric(
              vertical: Dimensions.heightSize,
              horizontal: Dimensions.widthSize
            ),
            children: [
              SvgPicture.asset(Assets.otpIllustration,
                height: MediaQuery.of(context).size.height*0.4,),
              addVerticalSpace(Dimensions.marginSize),
              Text(
                  'Enter the OTP sent to your mobile number',
                  style: CustomStyle.blackMediumTextStyle,
                  textAlign: TextAlign.center,
              ),
              addVerticalSpace(Dimensions.marginSize),
              _otpField(),
              addVerticalSpace(Dimensions.heightSize*0.5),
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
                  // loginUser();
                  IntentUtils.fireIntent(context: context, screen: UserBottomBar(), finishAll: true);
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
    );
  }
}
