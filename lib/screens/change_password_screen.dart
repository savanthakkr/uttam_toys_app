import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  AutovalidateMode _autoValidate = AutovalidateMode.disabled;
  TextEditingController _oldPassController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  TextEditingController _cnfPassController = TextEditingController();
  bool _cnfObscure= false,_isObscure = false,_oldObscure = false;

  void _onBackPressed() {
    Navigator.of(context).pop();
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
              _headingText(title: 'Old Password'),
              _oldPasswordTextField(),
              _headingText(title: 'New Password'),
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
                text: 'Save', onPressed: () {
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

  _oldPasswordTextField() {
    return TextFormField(
      controller: _oldPassController,
      keyboardType: TextInputType.visiblePassword,
      obscureText: _oldObscure,
      cursorColor: CustomColor.primaryColor,
      decoration: InputDecoration(
        border: UIUtils.textInputBorder,
        contentPadding: UIUtils.textinputPadding,
        errorBorder: UIUtils.errorBorder,
        enabledBorder: UIUtils.textInputBorder,
        focusedBorder: UIUtils.textInputBorder,
        errorStyle: CustomStyle.errorTextStyle,
        filled: false,
        hintText: 'New Password',
        hintStyle: CustomStyle.hintTextStyle,
        suffixIcon: InkWell(
          // alignment: Alignment.centerRight,
          child: Icon(_oldObscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            color: CustomColor.hintColor,
            size: Dimensions.iconSizeDefault,),
          // iconSize: Dimensions.iconSizeDefault,
          onTap: (){
            setState(() {
              _oldObscure = !_oldObscure;
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
        hintText: 'New Password',
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
