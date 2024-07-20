import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uttam_toys/apis/api_manager.dart';
import 'package:uttam_toys/models/address_model.dart';
import 'package:uttam_toys/utils/connection_utils.dart';
import 'package:uttam_toys/utils/custom_color.dart';
import 'package:uttam_toys/utils/custom_style.dart';
import 'package:uttam_toys/utils/prefs.dart';
import 'package:uttam_toys/utils/size.dart';
import 'package:uttam_toys/utils/ui_utils.dart';

import '../widgets/appbar_common.dart';

class SelectAddressScreen extends StatefulWidget {
  const SelectAddressScreen({super.key});

  @override
  State<SelectAddressScreen> createState() => _SelectAddressScreenState();
}

class _SelectAddressScreenState extends State<SelectAddressScreen> {
  bool _isLoading = false;
  String? userId;
  List<AddressDetail> _allAddress = <AddressDetail>[];
  String? _selectedAddressType;

  @override
  void initState() {
    super.initState();
    getPrefs();
  }

  getPrefs() async {
    SharedPreferences mPrefs = await SharedPreferences.getInstance();
    String? uId = mPrefs.getString(Prefs.ID);
    String? lastSelectedAddress = mPrefs.getString('lastSelectedAddress');
    setState(() {
      userId = uId;
      _selectedAddressType = lastSelectedAddress;
    });
    FetchAddress();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _onBackPressed();
        return false;
      },
      child: Scaffold(
        backgroundColor: CustomColor.backgroundColor,
        appBar: CommonAppbar(
          title: 'Select Address',
          hasBottom: true,
          leadingOnTap: _onBackPressed,
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator(color: CustomColor.primaryColor))
            : ListView.builder(
          itemCount: _allAddress.length,
          itemBuilder: (context, index) {
            return rawType(index);
          },
          shrinkWrap: true,
        ),
      ),
    );
  }

  Widget rawType(int index) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: CustomColor.primaryColor),
      ),
      child: Row(
        children: [
          Radio(
            value: _allAddress.elementAt(index).type,
            groupValue: _selectedAddressType,
            onChanged: (value) {
              setState(() {
                _selectedAddressType = value as String?;
                saveLastSelectedAddress(_selectedAddressType!);
                Navigator.pop(context, _selectedAddressType);
              });
            },
            activeColor: CustomColor.primaryColor,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_allAddress.elementAt(index).type, style: CustomStyle.primarySemiBoldText),
                addVerticalSpace(5),
                Text(_allAddress.elementAt(index).addressLine1 + ",", style: CustomStyle.blackSmallestTextStyle),
                _allAddress.elementAt(index).addressLine2.isNotEmpty ? addVerticalSpace(5) : Container(),
                _allAddress.elementAt(index).addressLine2.isNotEmpty ? Text(_allAddress.elementAt(index).addressLine2 + ",", style: CustomStyle.blackSmallestTextStyle) : Container(),
                addVerticalSpace(5),
                Text(_allAddress.elementAt(index).landmark + ", " + _allAddress.elementAt(index).city + ", " + _allAddress.elementAt(index).state, style: CustomStyle.blackSmallestTextStyle),
                addVerticalSpace(5),
                Text(_allAddress.elementAt(index).pincode + ".", style: CustomStyle.blackSmallestTextStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void FetchAddress() {
    ConnectionUtils.checkConnection().then((internet) async {
      if (internet) {
        setState(() {
          _isLoading = true;
        });
        try {
          final AddressModel resultModel = await ApiManager.FetchAllAddress(userId!);

          if (resultModel.error == false) {
            setState(() {
              _isLoading = false;
              _allAddress = resultModel.addressDetails;
              if (_selectedAddressType == null && _allAddress.isNotEmpty) {
                _selectedAddressType = _allAddress[0].type;
              }
            });
          } else {
            setState(() {
              _isLoading = false;
            });
            UIUtils.bottomToast(context: context, text: resultModel.message, isError: true);
          }
        } on Exception catch (_, e) {
          setState(() {
            _isLoading = false;
          });
          print(e.toString());
          UIUtils.bottomToast(context: context, text: e.toString(), isError: true);
        }
      } else {
        // No-Internet Case
        UIUtils.bottomToast(context: context, text: "Please check your internet connection", isError: true);
      }
    });
  }

  void _onBackPressed() {
    if (_selectedAddressType != null) {
      Navigator.of(context).pop(_selectedAddressType);
    } else {
      Navigator.of(context).pop();
    }
  }

  void saveLastSelectedAddress(String addressType) async {
    SharedPreferences mPrefs = await SharedPreferences.getInstance();
    await mPrefs.setString('lastSelectedAddress', addressType);
  }
}
