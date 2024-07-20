import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:uttam_toys/utils/custom_color.dart';
import 'package:uttam_toys/widgets/appbar_common.dart';

import '../utils/assets.dart';
import '../utils/custom_style.dart';
import '../utils/dimensions.dart';
import '../utils/size.dart';
import '../utils/ui_utils.dart';
import '../utils/validation_utils.dart';
import '../widgets/primary_button.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  AutovalidateMode _autoValidate = AutovalidateMode.disabled;
  final _formKey = GlobalKey<FormState>();

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
            title: 'Personal Information',
            hasBottom: true,
            leadingOnTap: _onBackPressed,
          ),
          body: ListView(
            padding: EdgeInsets.symmetric(
                vertical: Dimensions.heightSize,
                horizontal: Dimensions.widthSize
            ),
            children: [
              addVerticalSpace(Dimensions.heightSize),
              _profileView(),
              addVerticalSpace(Dimensions.heightSize*1.5),
              _headingText(title: 'Full name'),
              _nameTextField(),
              addVerticalSpace(Dimensions.heightSize),
              _headingText(title: 'Email address'),
              _emailTextField(),
              addVerticalSpace(Dimensions.heightSize),
              _headingText(title: 'Phone Number'),
              _phoneTextField(),
              addVerticalSpace(Dimensions.heightSize*1.5),
              PrimaryButtonWidget(
                // isLoading: _isLoading,
                text: 'Save',
                onPressed: () {
                  if(_formKey.currentState!.validate())
                  {
                    // loginUser();
                  }
                  else{
                    setState(() {
                      _autoValidate =
                          AutovalidateMode.onUserInteraction;
                    });
                  }
                },
              ),
            ],
          ),
        )
    );
  }

  _profileView() {
    return Column(
      children: [
        SizedBox(
          height: 120,
          width: 120,
          child: Stack(
            children: [
              SvgPicture.asset(Assets.placeholderSvg,fit: BoxFit.fill,height: 120,width: 120,),
              Positioned(
                bottom: 15,
                right: 10,
                child: InkWell(
                  onTap: () {
                    //todo image pick
                  },
                  child: const Icon(Icons.edit,color: CustomColor.blackColor,),
                ),
              )
            ],
          ),
        ),
      ],
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

  _nameTextField() {
    return TextFormField(
      controller: _nameController,
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
}
