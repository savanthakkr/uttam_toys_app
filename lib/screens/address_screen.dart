import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uttam_toys/apis/api_manager.dart';
import 'package:uttam_toys/models/address_model.dart';
import 'package:uttam_toys/models/ragister_model.dart';
import 'package:uttam_toys/utils/connection_utils.dart';
import 'package:uttam_toys/utils/custom_color.dart';
import 'package:uttam_toys/utils/custom_style.dart';
import 'package:uttam_toys/utils/dimensions.dart';
import 'package:uttam_toys/utils/prefs.dart';
import 'package:uttam_toys/utils/size.dart';
import 'package:uttam_toys/utils/ui_utils.dart';
import 'package:uttam_toys/utils/validation_utils.dart';
import 'package:uttam_toys/widgets/appbar_common.dart';
import 'package:uttam_toys/widgets/primary_button.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {

  TextEditingController _address1Controller = TextEditingController();
  TextEditingController _address2Controller = TextEditingController();
  TextEditingController _landmarkController = TextEditingController();
  TextEditingController _stateController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _pincodeController = TextEditingController();
  AutovalidateMode _autoValidate = AutovalidateMode.disabled;
  final _formKey = GlobalKey<FormState>();
  String? _addressType = "Home";
  bool _isLoading = false;
  String? address1,address2,landmark,state,city,pincode,userId,addressId;

  @override
  void initState() {
    super.initState();
    getPrefs();
  }

  getPrefs() async {
    SharedPreferences mPrefs = await SharedPreferences.getInstance();
    String? uId = mPrefs.getString(Prefs.ID);
    setState(() {
      userId = uId;
    });
    FetchAddress();
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
            title: 'Address',
            hasBottom: true,
            leadingOnTap: _onBackPressed,
          ),
          body: _isLoading ? Center(child: CircularProgressIndicator(color: CustomColor.primaryColor,)) : Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.symmetric(
                  vertical: Dimensions.heightSize,
                  horizontal: Dimensions.widthSize
              ),
              children: [
                addVerticalSpace(Dimensions.heightSize),
                _headingText(title: 'Address Type'),
                _typeWidget(),
                addVerticalSpace(Dimensions.heightSize),
                _headingText(title: 'Address 1'),
                _address1TextField(),
                addVerticalSpace(Dimensions.heightSize),
                _headingText(title: 'Address 2'),
                _address2TextField(),
                addVerticalSpace(Dimensions.heightSize),
                _headingText(title: 'Landmark'),
                _landmarkTextField(),
                addVerticalSpace(Dimensions.heightSize),
                _headingText(title: 'State'),
                _stateTextField(),
                addVerticalSpace(Dimensions.heightSize),
                _headingText(title: 'City'),
                _cityTextField(),
                addVerticalSpace(Dimensions.heightSize),
                _headingText(title: 'Pincode'),
                _pincodeTextField(),
                addVerticalSpace(Dimensions.heightSize*1.5),
                PrimaryButtonWidget(
                  // isLoading: _isLoading,
                  text: 'Save',
                  onPressed: () {
                    if(_formKey.currentState!.validate()) {
                      address1 = _address1Controller.text.toString().trim();
                      address2 = _address2Controller.text.toString().trim();
                      landmark = _landmarkController.text.toString().trim();
                      state = _stateController.text.toString().trim();
                      city = _cityController.text.toString().trim();
                      pincode = _pincodeController.text.toString().trim();

                      AddAddress();
                    } else{
                      setState(() {
                        _autoValidate =
                            AutovalidateMode.onUserInteraction;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        )
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

  _typeWidget() {
    return Row(
      children: [
        Row(
          children: [
            Radio(
              value: 'Home',
              groupValue: _addressType,
              onChanged: (value) {
                setState(() {
                  _addressType = value as String;
                });
                FetchAddress();
              },
              activeColor: CustomColor.primaryColor,
            ),
            Text('Home',style: CustomStyle.blackSmallestTextStyle),
          ],
        ),
        addHorizontalSpace(15), // add some space between the two radio buttons
        Row(
          children: [
            Radio(
              value: 'Office',
              groupValue: _addressType,
              onChanged: (value) {
                setState(() {
                  _addressType = value as String;
                });
                FetchAddress();
              },
              activeColor: CustomColor.primaryColor,
            ),
            Text('Office',style: CustomStyle.blackSmallestTextStyle),
          ],
        ),
        addHorizontalSpace(15),
        Row(
          children: [
            Radio(
              value: 'Other',
              groupValue: _addressType,
              onChanged: (value) {
                setState(() {
                  _addressType = value as String;
                });
                FetchAddress();
              },
              activeColor: CustomColor.primaryColor,
            ),
            Text('Other',style: CustomStyle.blackSmallestTextStyle),
          ],
        ),
      ],
    );
  }

  _address1TextField() {
    return TextFormField(
      controller: _address1Controller,
      keyboardType: TextInputType.multiline,
      cursorColor: CustomColor.primaryColor,
      maxLines: 3,
      decoration: InputDecoration(
        border: UIUtils.textInputBorder,
        contentPadding: UIUtils.textinputPadding,
        errorBorder: UIUtils.errorBorder,
        enabledBorder: UIUtils.textInputBorder,
        focusedBorder: UIUtils.textInputBorder,
        errorStyle: CustomStyle.errorTextStyle,
        filled: false,
        hintText: 'Enter your Address1',
        hintStyle: CustomStyle.hintTextStyle,
        counterText: '',
        // fillColor: CustomColor.editTextColor,
      ),
      style: CustomStyle.inputTextStyle,
      textAlign: TextAlign.start,
      autovalidateMode: _autoValidate,
      validator: addressValidator,
    );
  }

  _address2TextField() {
    return TextFormField(
      controller: _address2Controller,
      keyboardType: TextInputType.multiline,
      cursorColor: CustomColor.primaryColor,
      maxLines: 3,
      decoration: InputDecoration(
        border: UIUtils.textInputBorder,
        contentPadding: UIUtils.textinputPadding,
        errorBorder: UIUtils.errorBorder,
        enabledBorder: UIUtils.textInputBorder,
        focusedBorder: UIUtils.textInputBorder,
        errorStyle: CustomStyle.errorTextStyle,
        filled: false,
        hintText: 'Enter your Address2',
        hintStyle: CustomStyle.hintTextStyle,
        counterText: '',
        // fillColor: CustomColor.editTextColor,
      ),
      style: CustomStyle.inputTextStyle,
      textAlign: TextAlign.start,
      autovalidateMode: _autoValidate,
    );
  }

  _landmarkTextField() {
    return TextFormField(
      controller: _landmarkController,
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
        hintText: 'Enter your Landmark',
        hintStyle: CustomStyle.hintTextStyle,
        counterText: '',
        // fillColor: CustomColor.editTextColor,
      ),
      style: CustomStyle.inputTextStyle,
      textAlign: TextAlign.start,
      autovalidateMode: _autoValidate,
      validator: landmarkValidator,
    );
  }

  _stateTextField() {
    return TextFormField(
      controller: _stateController,
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
        hintText: 'Enter your State',
        hintStyle: CustomStyle.hintTextStyle,
        counterText: '',
        // fillColor: CustomColor.editTextColor,
      ),
      style: CustomStyle.inputTextStyle,
      textAlign: TextAlign.start,
      autovalidateMode: _autoValidate,
      validator: stateValidator,
    );
  }

  _cityTextField() {
    return TextFormField(
      controller: _cityController,
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
        hintText: 'Enter your City',
        hintStyle: CustomStyle.hintTextStyle,
        counterText: '',
        // fillColor: CustomColor.editTextColor,
      ),
      style: CustomStyle.inputTextStyle,
      textAlign: TextAlign.start,
      autovalidateMode: _autoValidate,
      validator: cityValidator,
    );
  }

  _pincodeTextField() {
    return TextFormField(
      controller: _pincodeController,
      keyboardType: TextInputType.number,
      maxLength: 6,
      cursorColor: CustomColor.primaryColor,
      decoration: InputDecoration(
        border: UIUtils.textInputBorder,
        contentPadding: UIUtils.textinputPadding,
        errorBorder: UIUtils.errorBorder,
        enabledBorder: UIUtils.textInputBorder,
        focusedBorder: UIUtils.textInputBorder,
        errorStyle: CustomStyle.errorTextStyle,
        filled: false,
        hintText: 'Enter your Pincode',
        hintStyle: CustomStyle.hintTextStyle,
        counterText: '',
        // fillColor: CustomColor.editTextColor,
      ),
      style: CustomStyle.inputTextStyle,
      textAlign: TextAlign.start,
      autovalidateMode: _autoValidate,
      validator: pincodeValidator,
    );
  }

  void FetchAddress() {
    ConnectionUtils.checkConnection().then((intenet) async {
      if (intenet) {
        setState(() {
          _isLoading = true;
        });
        try{
          final AddressModel resultModel = await ApiManager.FetchAddress(userId!,_addressType!);

          if(resultModel.error == false) {
            setState(() {
              _isLoading = false;
              if(resultModel.addressDetails.isNotEmpty) {
                _address1Controller.text = resultModel.addressDetails.first.addressLine1;
                _address2Controller.text = resultModel.addressDetails.first.addressLine2;
                _landmarkController.text = resultModel.addressDetails.first.landmark;
                _stateController.text = resultModel.addressDetails.first.state;
                _cityController.text = resultModel.addressDetails.first.city;
                _pincodeController.text = resultModel.addressDetails.first.pincode;
                addressId = resultModel.addressDetails.first.id.toString();
              } else {
                _address1Controller.text = "";
                _address2Controller.text = "";
                _landmarkController.text = "";
                _stateController.text = "";
                _cityController.text = "";
                _pincodeController.text = "";
                addressId = "";
              }
            });
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

  void AddAddress() {
    ConnectionUtils.checkConnection().then((intenet) async {
      if (intenet) {
        setState(() {
          _isLoading = true;
        });
        try{
          final RegisterModel resultModel = await ApiManager.CreateAddress(address1!,address2!,state!,city!,pincode!,landmark!,userId!,_addressType!);

          if(resultModel.error == false) {
            setState(() {
              _isLoading = false;
            });
            FetchAddress();
            UIUtils.bottomToast(context: context, text: resultModel.message, isError: false);
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

  void _onBackPressed() {
    Navigator.of(context).pop();
  }
}
