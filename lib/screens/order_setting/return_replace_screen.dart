import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uttam_toys_app/screens/order_setting/replacement_status_screen.dart';
import 'package:uttam_toys_app/screens/order_setting/return_status_screen.dart';
import 'package:uttam_toys_app/utils/intentutils.dart';
import 'package:uttam_toys_app/widgets/primary_button.dart';

import '../../utils/assets.dart';
import '../../utils/custom_color.dart';
import '../../utils/custom_style.dart';
import '../../utils/dimensions.dart';
import '../../utils/size.dart';
import '../../utils/ui_utils.dart';

class ReturnReplaceScreen extends StatefulWidget {
  const ReturnReplaceScreen({super.key});

  @override
  State<ReturnReplaceScreen> createState() => _ReturnReplaceScreenState();
}

class _ReturnReplaceScreenState extends State<ReturnReplaceScreen> {
  late TextEditingController  _replaceController;
  late TextEditingController _returnController;
  List<PaymentType> _payTypes = <PaymentType>[];

  void _onBackPressed() {
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    _replaceController = TextEditingController();
    _returnController = TextEditingController();
    setPayTypes();
  }

  void setPayTypes()
  {
    setState(() {
      _payTypes.add(PaymentType('Upi Apps', false));
      _payTypes.add(PaymentType('Credit/ Debit Card', false));
    });
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
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: CustomColor.backgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.white,
            systemOverlayStyle: const SystemUiOverlayStyle(
              // Status bar color
              statusBarColor: CustomColor.whiteColor,
              // Status bar brightness (optional)
              statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
              statusBarBrightness: Brightness.light, // For iOS (dark icons)
            ),
            elevation: 0,
            scrolledUnderElevation: 0,
            centerTitle: false,
            title: Text('Replacement/Return',style: CustomStyle.appbarTextTitleDark,),
            // leadingWidth: 40,
            leading: Container(
              margin: EdgeInsets.only(left: Dimensions.widthSize,right: Dimensions.widthSize),
              child: InkWell(
                onTap: _onBackPressed,
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: CustomColor.blackColor,
                ),
              ),
            ),
            automaticallyImplyLeading: false,
            bottom: TabBar(
              unselectedLabelStyle: CustomStyle.regularBlackLightText,
              unselectedLabelColor: CustomColor.hintColor,
              labelColor: CustomColor.primaryColor,
              labelStyle: CustomStyle.regularBlackText,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorColor: CustomColor.primaryColor,
              tabs: const [
                Tab(
                  text: 'Replace',
                ),
                Tab(
                  text: 'Return',
                )
              ],
            ),
          ),
          body: TabBarView(
            children: [
              _replacePage(),
              _returnPage(),
            ],
          ),
        ),
      ),
    );
  }

  _replacePage() {
    return ListView(
      padding: EdgeInsets.symmetric(
          vertical: Dimensions.heightSize,
          horizontal: Dimensions.widthSize
      ),
      children: [
        _product(),
        addVerticalSpace(Dimensions.heightSize,),
        Text('Reason of your replacement',style: CustomStyle.blackMediumTextStyle,),
        addVerticalSpace(Dimensions.heightSize*0.8),
        _reasonText(text: 'Wrong colour'),
        _reasonText(text: 'Defective Product'),
        _reasonText(text: 'Wrong colour'),
        _reasonText(text: 'Wrong colour'),
        _reasonText(text: 'Other Reason'),
        addVerticalSpace(Dimensions.heightSize*0.2),
        _replaceTextField(),
        addVerticalSpace(Dimensions.heightSize,),
        Text('Upload a photo',style: CustomStyle.blackMediumTextStyle,),
        _photoUpload(),
        addVerticalSpace(Dimensions.heightSize*1.5),
        PrimaryButtonWidget(
            text: 'Send the request',
            onPressed: () {
              //send replace request
              IntentUtils.fireIntent(context: context, screen: ReplacementStatusScreen(), finishAll: false);
            },
          borderColor: CustomColor.primaryColor,
          textColor: CustomColor.primaryColor,
          elevation: 0,
          backgroundColor: CustomColor.whiteColor,
          radius: Dimensions.radius*0.6,
        )
      ],
    );
  }

  _returnPage() {
    return ListView(
      padding: EdgeInsets.symmetric(
          vertical: Dimensions.heightSize,
          horizontal: Dimensions.widthSize
      ),
      children: [
        _product(),
        addVerticalSpace(Dimensions.heightSize,),
        Text('Reason of your return',style: CustomStyle.blackMediumTextStyle,),
        addVerticalSpace(Dimensions.heightSize*0.8),
        _reasonText(text: 'Wrong colour'),
        _reasonText(text: 'Defective Product'),
        _reasonText(text: 'Wrong colour'),
        _reasonText(text: 'Wrong colour'),
        _reasonText(text: 'Other Reason'),
        _returnTextField(),
        addVerticalSpace(Dimensions.heightSize,),
        Text('Upload a photo',style: CustomStyle.blackMediumTextStyle,),
        _photoUpload(),
        addVerticalSpace(Dimensions.heightSize,),
        Text('Refund mode',style: CustomStyle.blackMediumTextStyle,),
        for(int i=0; i<_payTypes.length ; i++)
          _buildPaymentItem(_payTypes[i]),
        addVerticalSpace(Dimensions.heightSize*1.5),
        PrimaryButtonWidget(
          text: 'Send the request',
          onPressed: () {
            IntentUtils.fireIntent(context: context, screen: ReturnStatusScreen(), finishAll: false);
          },
          borderColor: CustomColor.primaryColor,
          textColor: CustomColor.primaryColor,
          elevation: 0,
          backgroundColor: CustomColor.whiteColor,
          radius: Dimensions.radius*0.6,
        )
      ],
    );
  }

  _product() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(
          Assets.train,
          height: 120,width: 120,),
        addHorizontalSpace(Dimensions.widthSize),
        Expanded(
            child: Column(
              crossAxisAlignment : CrossAxisAlignment.center,
              children: [
                Text('Toy Train Engine',style: CustomStyle.blackMediumTextStyle,),
                Row(
                  mainAxisAlignment: mainCenter,
                  children: [
                    const Icon(
                      Icons.file_upload_outlined,
                      color: CustomColor.blackColor,
                    ),
                    Text('Share this item',
                      style: CustomStyle.regularBlackLightText,),
                  ],
                ),
              ],
            )
        ),
      ],
    );
  }

  _reasonText({required String text})
  {
    return Text(text,style: CustomStyle.regularBlackLightText,);
  }

  _replaceTextField() {
    return TextFormField(
      controller: _replaceController,
      keyboardType: TextInputType.multiline,
      maxLines: 4,
      cursorColor: CustomColor.primaryColor,
      decoration: InputDecoration(
        border: UIUtils.textInputBorder,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        contentPadding: UIUtils.textinputPadding,
        errorBorder: UIUtils.errorBorder,
        enabledBorder: UIUtils.textInputBorder,
        focusedBorder: UIUtils.textInputBorder,
        errorStyle: CustomStyle.errorTextStyle,
        filled: false,
        hintText: 'Write your reason of replacement',
        hintStyle: CustomStyle.hintTextStyle,
        counterText: '',
        // fillColor: CustomColor.editTextColor,
      ),
      style: CustomStyle.inputTextStyle,
      textAlign: TextAlign.start,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      // validator: (value) {
      //   if(value==null || value.isEmpty)
      //     {
      //       return 'I'
      //     }
      // },
    );
  }

  _returnTextField() {
    return TextFormField(
      controller: _replaceController,
      keyboardType: TextInputType.multiline,
      maxLines: 4,
      cursorColor: CustomColor.primaryColor,
      decoration: InputDecoration(
        border: UIUtils.textInputBorder,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        contentPadding: UIUtils.textinputPadding,
        errorBorder: UIUtils.errorBorder,
        enabledBorder: UIUtils.textInputBorder,
        focusedBorder: UIUtils.textInputBorder,
        errorStyle: CustomStyle.errorTextStyle,
        filled: false,
        hintText: 'Write your reason of return',
        hintStyle: CustomStyle.hintTextStyle,
        counterText: '',
        // fillColor: CustomColor.editTextColor,
      ),
      style: CustomStyle.inputTextStyle,
      textAlign: TextAlign.start,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      // validator: (value) {
      //   if(value==null || value.isEmpty)
      //     {
      //       return 'I'
      //     }
      // },
    );
  }

  _photoUpload()
  {
    return DottedBorder(
      color: CustomColor.borderColor,
      radius: Radius.circular(Dimensions.radius),
      child: Container(
        decoration: const BoxDecoration(
          color: CustomColor.cardColor
        ),
        padding: EdgeInsets.symmetric(
            vertical: Dimensions.heightSize,
            horizontal: Dimensions.widthSize
        ),
        height: 150,
        child: Center(
          child: SvgPicture.asset(Assets.cameraSvg,height: 45,width: 45,),
        ),
      ),
    );
  }

  _buildPaymentItem(PaymentType paymentType)
  {
    return CheckboxListTile(
      value: paymentType.isChecked,
      activeColor: CustomColor.primaryColor,
      onChanged: (bool? selected) {
        setState(() {
          paymentType.isChecked = selected;
        });
      },
      title: Text(paymentType.title!,style: CustomStyle.regularBlackLightText,),
    );
  }
}
class PaymentType{
  String? title;
  bool? isChecked;

  PaymentType(this.title, this.isChecked);
}
