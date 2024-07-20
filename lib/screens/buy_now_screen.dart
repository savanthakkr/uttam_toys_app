import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:uttam_toys/screens/order_summary_screen.dart';
import 'package:uttam_toys/utils/custom_color.dart';
import 'package:uttam_toys/utils/intentutils.dart';
import 'package:uttam_toys/widgets/appbar_common.dart';
import 'package:uttam_toys/widgets/primary_button.dart';

import '../utils/assets.dart';
import '../utils/custom_style.dart';
import '../utils/dimensions.dart';
import '../utils/size.dart';

class BuyNowScreen extends StatefulWidget {
  const BuyNowScreen({super.key});

  @override
  State<BuyNowScreen> createState() => _BuyNowScreenState();
}

class _BuyNowScreenState extends State<BuyNowScreen> {
  List<PaymentType> _payTypes = <PaymentType>[];
  List<Address> _addressList = <Address>[];

  void _onBackPressed() {
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    setPayTypes();
    getAddress();
  }
  
  void setPayTypes()
  {
    setState(() {
      _payTypes.add(PaymentType('Cash On Delivery', true));
      _payTypes.add(PaymentType('Upi Apps', false));
      _payTypes.add(PaymentType('Credit/ Debit Card', false));
    });
  }

  void getAddress()
  {
    setState(() {
      _addressList.add(Address('Ajwa road, Vadodara (458967) Gujarat, India', true));
      _addressList.add(Address('Ajwa road, Vadodara (458967) Gujarat, India', false));
      _addressList.add(Address('Ajwa road, Vadodara (458967) Gujarat, India', false));
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
        child: Scaffold(
          backgroundColor: CustomColor.backgroundColor,
          appBar: CommonAppbar(
            title: 'Buy Now',
            hasBottom: true,
            leadingOnTap: _onBackPressed,
            actions: [
              InkWell(
                onTap: () {
                  //todo go to cart
                },
                child: SvgPicture.asset(
                  Assets.cartSvg,
                  height: 20,
                  width: 20,
                ),
              ),
              addHorizontalSpace(Dimensions.widthSize),
            ],
          ),
          body: ListView(
            padding: EdgeInsets.symmetric(
              vertical: Dimensions.heightSize,
              horizontal: Dimensions.widthSize
            ),
            children: [
              Text.rich(
                  textAlign: TextAlign.start,
                  TextSpan(
                      text: 'SubTotal: ',
                      style: CustomStyle.regularBlackLightText.copyWith(
                        fontSize: Dimensions.mediumTextSize
                      ),
                      children: [
                        TextSpan(
                            text: '\u20b9 499',
                            style: CustomStyle.blackMediumTextStyle
                        )
                      ]
                  )
              ),
              addVerticalSpace(Dimensions.heightSize*1.5),
              Text('Select a Payment Method',style: CustomStyle.blackMediumTextStyle,),
              addVerticalSpace(Dimensions.heightSize),
              for(int i=0; i<_payTypes.length ; i++)
                _buildPaymentItem(_payTypes[i]),
              addVerticalSpace(Dimensions.heightSize*1.5),
              Text('Select a Delivery Address',style: CustomStyle.blackMediumTextStyle,),
              for(int i=0; i<_addressList.length ; i++)
                _buildAddressItem(_addressList[i]),
              addVerticalSpace(Dimensions.heightSize*1.5),
              PrimaryButtonWidget(
                  text: 'Continue',
                  borderColor: CustomColor.borderColor,
                  textColor: CustomColor.primaryColor,
                  backgroundColor: Colors.white,
                  radius: Dimensions.radius*0.5,
                  elevation: 0,
                  onPressed: () {
                    IntentUtils.fireIntent(context: context, screen: OrderSummaryScreen(), finishAll: false);
                  },
              )
            ],
          ),
        )
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

  _buildAddressItem(Address address)
  {
    return CheckboxListTile(
      value: address.isChecked,
      activeColor: CustomColor.primaryColor,
      onChanged: (bool? selected) {
        setState(() {
          address.isChecked = selected;
        });
      },
      title: Text(address.address!,style: CustomStyle.regularBlackLightText,),
    );
  }
}
class PaymentType{
  String? title;
  bool? isChecked;

  PaymentType(this.title, this.isChecked);
}
class Address{
  String? address;
  bool? isChecked;

  Address(this.address, this.isChecked);
}
