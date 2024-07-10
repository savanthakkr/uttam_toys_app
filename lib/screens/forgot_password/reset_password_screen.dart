import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uttam_toys_app/screens/forgot_password/forgot_password.dart';

import '../../helper/password_tips_dialouge.dart';
import '../../utils/custom_color.dart';
import '../../utils/custom_style.dart';
import '../../utils/dimensions.dart';
import '../../utils/intentutils.dart';
import '../../utils/size.dart';
import '../../utils/size.dart';
import '../../utils/ui_utils.dart';
import '../../utils/validation_utils.dart';
import '../../widgets/appbar_common.dart';
import '../../widgets/primary_button.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  AutovalidateMode _autoValidate = AutovalidateMode.disabled;
  TextEditingController _passController = TextEditingController();
  TextEditingController _cnfPassController = TextEditingController();
  bool _cnfObscure= false,_isObscure = true;

  void _onBackPressed() {
    IntentUtils.fireIntent(context: context, screen: ForgotPassword(), finishAll: true);
    // Navigator.of(context).pop();
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
          title: 'Password Change',
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
              Text('Lorem ipsum dolor sit amet consectetur. Pretium sit',
                textAlign: TextAlign.start,
                style: CustomStyle.regularBlackLightText,),
              addVerticalSpace(Dimensions.marginSize),
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
              addVerticalSpace(Dimensions.heightSize*1.5),
              PrimaryButtonWidget(
                isLoading: _isLoading,
                text: 'Save changes & sign in', onPressed: () {
                if(_formKey.currentState!.validate())
                {
                  //todo verify otp
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

  void showPassDialog() {
    showDialog(context: context,
      builder: (context) {
        return PasswordTipsDialog();
      },);
  }
}
