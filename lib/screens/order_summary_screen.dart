import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:uttam_toys_app/utils/custom_color.dart';

import '../utils/assets.dart';
import '../utils/custom_style.dart';
import '../utils/dimensions.dart';
import '../utils/size.dart';
import '../widgets/appbar_common.dart';
import '../widgets/primary_button.dart';

class OrderSummaryScreen extends StatefulWidget {
  const OrderSummaryScreen({super.key});

  @override
  State<OrderSummaryScreen> createState() => _OrderSummaryScreenState();
}

class _OrderSummaryScreenState extends State<OrderSummaryScreen> {

  void _onBackPressed() {
    // IntentUtils.fireIntent(context, const MobileVerifyScreen());
    Navigator.of(context).pop();
    // return false;
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
              Text('Order summary',style: CustomStyle.blackMediumTextStyle,),
              Card(
                elevation: 0,
                color: CustomColor.backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimensions.radius*0.5),
                  side: const BorderSide(color: CustomColor.borderColor,width: 1)
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: Dimensions.heightSize,
                      horizontal: Dimensions.widthSize
                  ),
                  child: Column(
                    children: [
                      _buildItemView(title: 'Item:', value: 'Rs. 2950.00'),
                      addVerticalSpace(Dimensions.heightSize*0.2),
                      _buildItemView(title: 'Packaging:', value: 'Rs. 50.00'),
                      addVerticalSpace(Dimensions.heightSize*0.2),
                      _buildItemView(title: 'COD Fees:', value: 'Rs. 00.00'),
                      addVerticalSpace(Dimensions.heightSize*0.2),
                      _buildItemView(title: 'Tax:', value: 'Rs. 124.00'),
                      addVerticalSpace(Dimensions.heightSize*0.2),
                      Row(
                        children: [
                          Expanded(
                              flex: 5,
                              child: Text(
                                'Total:',
                                textAlign: TextAlign.start,
                                style: CustomStyle.regularBlackText,
                              )
                          ),
                          Expanded(
                              flex: 5,
                              child: Text(
                                'Rs. 3124.00',
                                textAlign: TextAlign.end,
                                style: CustomStyle.regularBlackText,
                              )
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              addVerticalSpace(Dimensions.heightSize*1.5),
              PrimaryButtonWidget(
                text: 'Place Your Order',
                borderColor: CustomColor.borderColor,
                textColor: CustomColor.primaryColor,
                backgroundColor: Colors.white,
                radius: Dimensions.radius*0.5,
                elevation: 0,
                onPressed: () {
                  //todo
                },
              )
            ],
          ),
        )
    );
  }

  _buildItemView({required String title,required String value})
  {
    return Row(
      children: [
        Expanded(
          flex: 5,
            child: Text(
              title,
              textAlign: TextAlign.start,
              style: CustomStyle.regularBlackLightText,
            )
        ),
        Expanded(
            flex: 5,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: CustomStyle.regularBlackLightText,
            )
        )
      ],
    );
  }
}
