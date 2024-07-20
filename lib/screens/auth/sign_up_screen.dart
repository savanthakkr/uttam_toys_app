import 'dart:ui';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uttam_toys/apis/api_manager.dart';
import 'package:uttam_toys/helper/password_tips_dialouge.dart';
import 'package:uttam_toys/models/ragister_model.dart';
import 'package:uttam_toys/screens/auth/login_screen.dart';
import 'package:uttam_toys/screens/bottom/user_bottom_bar.dart';
import 'package:uttam_toys/utils/connection_utils.dart';
import 'package:uttam_toys/utils/intentutils.dart';
import 'package:uttam_toys/utils/prefs.dart';
import 'package:uttam_toys/utils/ui_utils.dart';
import 'package:uttam_toys/utils/validation_utils.dart';
import 'package:uttam_toys/widgets/appbar_common.dart';

import '../../utils/assets.dart';
import '../../utils/custom_color.dart';
import '../../utils/custom_style.dart';
import '../../utils/dimensions.dart';
import '../../utils/size.dart';
import '../../widgets/primary_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _cnfObscure= false,_isObscure = true;
  // String _regType = 'Individual';
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  TextEditingController _cnfPassController = TextEditingController();
  AutovalidateMode _autoValidate = AutovalidateMode.disabled;
  CountryCode code = CountryCode(code: "IN");
  final _formKey = GlobalKey<FormState>();
  bool _isLoading=false;

  void _onBackPressed() {
    // IntentUtils.fireIntent(context, const MobileVerifyScreen());
    Navigator.of(context).pop();
    // Navigator.pop(context);
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
          title: 'Create your account',
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
              _headingText(title: 'Full name'),
              _nameTextField(),
              addVerticalSpace(Dimensions.heightSize),
              _headingText(title: 'Email address'),
              _emailTextField(),
              addVerticalSpace(Dimensions.heightSize),
              _headingText(title: 'Phone Number'),
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
              ),
              addVerticalSpace(Dimensions.heightSize),
              _headingText(title: 'Password'),
              _passwordTextField(),
              addVerticalSpace(Dimensions.heightSize),
              _headingText(title: 'Confirm Password'),
              _cnfPasswordTextField(),
              addVerticalSpace(Dimensions.heightSize*0.3),
              InkWell(
                  onTap: (){
                    showPassDialog();
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: CustomColor.blackColor,
                        size: Dimensions.iconSizeSmall,
                      ),
                      addHorizontalSpace(Dimensions.widthSize*0.5),
                      Text('Secure password tips',
                        textAlign: TextAlign.end,
                        style: CustomStyle.blackSmallestTextStyle),
                    ],
                  )),
              addVerticalSpace(Dimensions.marginSize),
              PrimaryButtonWidget(
                isLoading: _isLoading,
                text: 'Sign Up', onPressed: () {
                if(_formKey.currentState!.validate())
                {
                  registerUser();
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
                  IntentUtils.fireIntent(context: context, screen: LoginScreen(), finishAll: true);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account? ',
                      style: CustomStyle.blackSmallestTextStyle,
                      textAlign: TextAlign.center,),
                    Text('Sign in'.toUpperCase(),
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
      ),
    );
  }

  _headingText({required String title})
  {
    return Column(
      crossAxisAlignment: crossStart,
      children: [
        Text(title,style: CustomStyle.smallHeadingTextStyle,),
        addVerticalSpace(Dimensions.heightSize*0.5)
      ],
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

  _nameTextField() {
    return TextFormField(
      controller: _nameController,
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
        hintText: 'Enter your full name',
        hintStyle: CustomStyle.hintTextStyle,
        counterText: '',
        // fillColor: CustomColor.editTextColor,
      ),
      style: CustomStyle.inputTextStyle,
      textAlign: TextAlign.start,
      autovalidateMode: _autoValidate,
      validator: nameValidator,
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
      style: CustomStyle.numberInputTextStyle,
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

  _cnfPasswordTextField() {
    return TextFormField(
      controller: _cnfPassController,
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
        hintText: 'Re-enter your password',
        hintStyle: CustomStyle.hintTextStyle,
        suffixIcon: InkWell(
          // alignment: Alignment.centerRight,
          child: Icon(_cnfObscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            color: CustomColor.hintColor,
            size: Dimensions.iconSizeDefault,),
          // iconSize: Dimensions.iconSizeDefault,
          onTap: (){
            setState(() {
              _cnfObscure = !_cnfObscure;
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
        child: SvgPicture.asset(svgIcon,),
      ),
    );
  }

  void showPassDialog() {
    showDialog(context: context,
      builder: (context) {
      return PasswordTipsDialog();
    },);
  }

  void registerUser() {
    ConnectionUtils.checkConnection().then((intenet) async {
      if (intenet) {
        setState(() {
          _isLoading = true;
        });
        try{
          final RegisterModel resultModel = await ApiManager.CreateUser(
            _nameController.text.trim(),
            _emailController.text.trim(),
            _phoneController.text.trim(),
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
}
