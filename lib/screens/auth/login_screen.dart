import 'dart:ui';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uttam_toys_app/apis/api_manager.dart';
import 'package:uttam_toys_app/models/login_model.dart';
import 'package:uttam_toys_app/screens/bottom/user_bottom_bar.dart';
import 'package:uttam_toys_app/screens/forgot_password/forgot_password.dart';
import 'package:uttam_toys_app/screens/auth/sign_up_screen.dart';
import 'package:uttam_toys_app/utils/connection_utils.dart';
import 'package:uttam_toys_app/utils/intentutils.dart';
import 'package:uttam_toys_app/utils/prefs.dart';
import 'package:uttam_toys_app/utils/ui_utils.dart';
import 'package:uttam_toys_app/utils/validation_utils.dart';

import '../../utils/assets.dart';
import '../../utils/custom_color.dart';
import '../../utils/custom_style.dart';
import '../../utils/dimensions.dart';
import '../../utils/size.dart';
import '../../widgets/primary_button.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _mobileLogin= false,_isObscure = true;
  // String _regType = 'Individual';
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  AutovalidateMode _autoValidate = AutovalidateMode.disabled;
  CountryCode code = CountryCode(code: "IN");
  final _formKey = GlobalKey<FormState>();
  bool _isLoading=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.widthSize,
            vertical: Dimensions.heightSize
          ),
          children: [
            SvgPicture.asset(_mobileLogin ? Assets.mobileIllustration : Assets.emailIllustration,
              height: MediaQuery.of(context).size.height*0.4,),
            addVerticalSpace(Dimensions.heightSize),
            Container(
              height: 50.0,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1.0),
                color: CustomColor.whiteColor,
              ),
              child:  Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: (){
                        if(_mobileLogin) {
                          setState(() {
                            _mobileLogin = false;
                            _autoValidate = AutovalidateMode.disabled;
                          });
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: Dimensions.widthSize*0.2,
                            vertical: Dimensions.heightSize*0.2),
                        decoration: BoxDecoration(
                            color: _mobileLogin ? Colors.transparent : CustomColor.primaryColor,
                            borderRadius: BorderRadius.circular(Dimensions.radius*0.5)
                        ),
                        child: Center(
                          child: Text(
                            "Email Address",
                            textAlign: TextAlign.center,
                            style: _mobileLogin ? CustomStyle.blackMediumTextStyle : CustomStyle.buttonWhiteTextStyle,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: (){
                        if(!_mobileLogin) {
                          setState(() {
                            _mobileLogin = true;
                            _autoValidate = AutovalidateMode.disabled;
                          });
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: Dimensions.widthSize*0.2,
                            vertical: Dimensions.heightSize*0.2),
                        decoration: BoxDecoration(
                            color: _mobileLogin ? CustomColor.primaryColor : Colors.transparent,
                            borderRadius: BorderRadius.circular(Dimensions.radius*0.5)
                        ),
                        child: Center(
                          child: Text(
                            "Mobile Number",
                            textAlign: TextAlign.center,
                            style: _mobileLogin ? CustomStyle.buttonWhiteTextStyle : CustomStyle.blackMediumTextStyle,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            addVerticalSpace(Dimensions.heightSize*1.5),
            if (_mobileLogin) Column(
              crossAxisAlignment: crossStart,
              children: [
                Text('Phone Number',style: CustomStyle.smallHeadingTextStyle,),
                addVerticalSpace(Dimensions.heightSize*0.8),
                Container(
                  // margin: EdgeInsets.only(left: 5.0,right: 5.0),
                  // height: 60.0,
                  padding: EdgeInsets.zero,
                  color: Colors.transparent,
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: crossStretch,
                      children: [
                        _countryPicker(),
                        addHorizontalSpace(Dimensions.widthSize),
                        Expanded(
                          flex: 7,
                          child: _phoneTextField(),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )
            else Column(
              crossAxisAlignment: crossStretch,
              children: [
                Text('Email Address',style: CustomStyle.smallHeadingTextStyle,),
                addVerticalSpace(Dimensions.heightSize*0.8),
                _emailTextField(),
                addVerticalSpace(Dimensions.heightSize),
                Text('Password',style: CustomStyle.smallHeadingTextStyle,),
                addVerticalSpace(Dimensions.heightSize*0.8),
                _passwordTextField(),
                addVerticalSpace(Dimensions.heightSize*0.2),
                InkWell(
                    onTap: (){
                      IntentUtils.fireIntent(context: context, screen: ForgotPassword(), finishAll: false);
                    },
                    child: Text('Forgot Password?',
                      textAlign: TextAlign.end,
                      style: CustomStyle.inputTextStyle.copyWith(color: CustomColor.primaryColor),)),
              ],
            ),
            addVerticalSpace(Dimensions.heightSize*1.2),
            _mobileLogin ? PrimaryButtonWidget(
              isLoading: _isLoading,
              text: 'Get OTP', onPressed: () {
              if(_formKey.currentState!.validate())
              {
                MobileLoginUser();
                // IntentUtils.fireIntent(context: context, screen: OtpScreen(), finishAll: false);
              }
              else{
                setState(() {
                  _autoValidate =
                      AutovalidateMode.onUserInteraction;
                });
              }
            },)
            :
            PrimaryButtonWidget(
              isLoading: _isLoading,
              text: 'Sign In', onPressed: () {
              if(_formKey.currentState!.validate())
              {
                LoginUser();
                // IntentUtils.fireIntent(context: context, screen: UserBottomBar(), finishAll: true);
              }
              else{
                setState(() {
                  _autoValidate =
                      AutovalidateMode.onUserInteraction;
                });
              }
            },),
            addVerticalSpace(Dimensions.heightSize),
            Row(
              mainAxisAlignment: mainCenter,
              mainAxisSize: mainMin,
              children: [
                _iconButton(
                    svgIcon: Assets.googleSvg,
                    onPressed: (){
                      //todo google login
                    }
                ),
                addHorizontalSpace(Dimensions.widthSize*1.5),
                _iconButton(
                    svgIcon: Assets.appleSvg,
                    onPressed: (){
                      //todo google login
                    }
                )
              ],
            ),
            addVerticalSpace(Dimensions.heightSize*1.5),
            InkWell(
              onTap: (){
                IntentUtils.fireIntent(context: context,screen: const SignUpScreen(),finishAll: false);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Don’t have an account? ',
                    style: CustomStyle.blackSmallestTextStyle,
                    textAlign: TextAlign.center,),
                  Text('Sign up'.toUpperCase(),
                    style: CustomStyle.blackSmallestTextStyle.copyWith(
                        color: CustomColor.primaryColor,
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _countryPicker(){
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: CustomColor.blackColor,width: 1),
        borderRadius: BorderRadius.circular(Dimensions.radius*0.5),
      ),
      child: CountryCodePicker(
        onChanged: (value) {
          code = value;
          setState(() {

          });
        },
        onInit: (value) {
          code = value!;
        },
        textStyle: CustomStyle.numberInputTextStyle,
        padding: const EdgeInsets.all(0),
        showFlag: true,
        initialSelection: '+91',
        // favorite: ['+91'],
        showCountryOnly: false,
        showOnlyCountryWhenClosed: false,
        showFlagMain: false,
        alignLeft: false,
      ),
    );
  }

  _phoneTextField() {
    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      cursorColor: CustomColor.primaryColor,
      decoration: InputDecoration(
        border: UIUtils.textInputBorder,
        contentPadding: UIUtils.textinputPadding,
        errorBorder: UIUtils.errorBorder,
        enabledBorder: UIUtils.textInputBorder,
        focusedBorder: UIUtils.textInputBorder,
        errorStyle: CustomStyle.errorTextStyle,
        filled: false,
        hintText: 'Enter your mobile number',
        hintStyle: CustomStyle.hintTextStyle,
        counterText: '',
        // fillColor: CustomColor.editTextColor,
      ),
      style: CustomStyle.inputTextStyle,
      textAlign: TextAlign.start,
      autovalidateMode: _autoValidate,
      validator: phoneValidator,
    );
  }

  _emailTextField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      cursorColor: CustomColor.primaryColor,
      decoration: InputDecoration(
        border: UIUtils.textInputBorder,
        contentPadding: UIUtils.textinputPadding,
        errorBorder: UIUtils.errorBorder,
        enabledBorder: UIUtils.textInputBorder,
        focusedBorder: UIUtils.textInputBorder,
        errorStyle: CustomStyle.errorTextStyle,
        filled: false,
        hintText: 'Enter your email address',
        hintStyle: CustomStyle.hintTextStyle
      ),
      style: CustomStyle.inputTextStyle,
      textAlign: TextAlign.start,
      autovalidateMode: _autoValidate,
      validator: emailValidator,
    );
  }

  _passwordTextField() {
    return TextFormField(
      controller: _passController,
      keyboardType: TextInputType.visiblePassword,
      obscureText: _isObscure,
      cursorColor: CustomColor.primaryColor,
      decoration: InputDecoration(
        border: UIUtils.textInputBorder,
        contentPadding: UIUtils.textinputPadding,
        errorBorder: UIUtils.errorBorder,
        enabledBorder: UIUtils.textInputBorder,
        focusedBorder: UIUtils.textInputBorder,
        errorStyle: CustomStyle.errorTextStyle,
        filled: false,
        hintText: 'Enter your password',
        hintStyle: CustomStyle.hintTextStyle,
        suffixIcon: InkWell(
          // alignment: Alignment.centerRight,
          child: Icon(_isObscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            color: CustomColor.hintColor,
            size: Dimensions.iconSizeDefault,),
          // iconSize: Dimensions.iconSizeDefault,
          onTap: (){
            setState(() {
              _isObscure = !_isObscure;
            });
          },
        ),
      ),
      style: CustomStyle.inputTextStyle,
      textAlign: TextAlign.start,
      autovalidateMode: _autoValidate,
      validator: passwordValidator,
    );
  }

  _iconButton({required String svgIcon,required GestureTapCallback onPressed})
  {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 35,
        width: 35,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: CustomColor.primaryColor,
        ),
        padding: const EdgeInsets.all(5.0),
        child: SvgPicture.asset(svgIcon),
      ),
    );
  }

  void LoginUser() {
    ConnectionUtils.checkConnection().then((intenet) async {
      if (intenet) {
        setState(() {
          _isLoading = true;
        });
        try{
          final LoginModel resultModel = await ApiManager.LoginUser(
            _emailController.text.trim(),
            _passController.text.trim(),
          );

          if(resultModel.error == false) {
            setState(() {
              _isLoading = false;
            });

            SharedPreferences mPref = await SharedPreferences.getInstance();
            mPref.setBool(Prefs.isLogin, true);
            mPref.setString(Prefs.ID, resultModel.userId.toString());

            IntentUtils.fireIntentwithAnimations(context, UserBottomBar(), true);

          } else{
            setState(() {
              _isLoading = false;
            });
            UIUtils.bottomToast(context: context, text: resultModel.message, isError: true);
          }
        }
        on Exception catch(_,e){
          setState(() {
            _isLoading = false;
          });
          print(e.toString());
          UIUtils.bottomToast(context: context, text: e.toString(), isError: true);
        }
      }
      else {
        // No-Internet Case
        UIUtils.bottomToast(context: context, text: "Please check your internet connection", isError: true);
      }
    });
  }

  void MobileLoginUser() {
    ConnectionUtils.checkConnection().then((intenet) async {
      if (intenet) {
        setState(() {
          _isLoading = true;
        });
        try{
          final LoginModel resultModel = await ApiManager.MobileLoginUser(
              _phoneController.text.trim()
          );

          if(resultModel.error == false) {
            setState(() {
              _isLoading = false;
            });

            SharedPreferences mPref = await SharedPreferences.getInstance();
            mPref.setBool(Prefs.isLogin, true);
            mPref.setString(Prefs.ID, resultModel.userId.toString());

            IntentUtils.fireIntentwithAnimations(context, UserBottomBar(), true);

          } else{
            setState(() {
              _isLoading = false;
            });
            UIUtils.bottomToast(context: context, text: resultModel.message, isError: true);
          }
        }
        on Exception catch(_,e){
          setState(() {
            _isLoading = false;
          });
          print(e.toString());
          UIUtils.bottomToast(context: context, text: e.toString(), isError: true);
        }
      }
      else {
        // No-Internet Case
        UIUtils.bottomToast(context: context, text: "Please check your internet connection", isError: true);
      }
    });
  }
}
