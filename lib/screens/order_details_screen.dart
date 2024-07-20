import 'package:flutter/material.dart';
import 'package:uttam_toys/utils/custom_color.dart';
import 'package:uttam_toys/widgets/appbar_common.dart';
import 'package:uttam_toys/widgets/primary_button.dart';

import '../utils/assets.dart';
import '../utils/custom_style.dart';
import '../utils/dimensions.dart';
import '../utils/size.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({super.key});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {

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
            title: 'Order Details',
            hasBottom: true,
            leadingOnTap: _onBackPressed,
          ),
          body: ListView(
            padding: EdgeInsets.symmetric(
                vertical: Dimensions.heightSize,
                horizontal: Dimensions.widthSize
            ),
            children: [
              _orderDetails(),
              addVerticalSpace(Dimensions.heightSize*0.5,),
              _invoiceBtn(),
              addVerticalSpace(Dimensions.heightSize*0.5,),
              Text('Shipping Details',style: CustomStyle.blackMediumTextStyle,),
              addVerticalSpace(Dimensions.heightSize*0.5),
              _shipDetails(),
              addVerticalSpace(Dimensions.heightSize,),
              Text('Payment Information',style: CustomStyle.blackMediumTextStyle,),
              addVerticalSpace(Dimensions.heightSize*0.5),
              _paymentDetails(),
              addVerticalSpace(Dimensions.heightSize,),
              Text('Shipping Address',style: CustomStyle.blackMediumTextStyle,),
              addVerticalSpace(Dimensions.heightSize*0.5),
              _addressDetails(),
              addVerticalSpace(Dimensions.heightSize,),
              Text('Order summary',style: CustomStyle.blackMediumTextStyle,),
              addVerticalSpace(Dimensions.heightSize*0.5),
              summary()
            ],
          ),
        )
    );
  }

  _orderDetails() {
    return Column(
      crossAxisAlignment: crossStart,
      children: [
        _buildRichText(title: 'Order Date: ', value: '05-05-2024'),
        _buildRichText(title: 'Order Number: ', value: '7891622269'),
        _buildRichText(title: 'Order Total: ', value: '\u20b9 3124'),
      ],
    );
  }

  _shipDetails()
  {
    return Card(
      elevation: 0,
      color: CustomColor.whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.radius*0.8),
        side: const BorderSide(color: CustomColor.borderColor,width: 1)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Three Day Shipping',
            textAlign: TextAlign.center,
            style: CustomStyle.regularBlackText,),
          const Divider(
            color: CustomColor.borderColor,
            height: 0,
            thickness: 1,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: Dimensions.heightSize,
                horizontal: Dimensions.widthSize
            ),
            child: Column(
              crossAxisAlignment: crossStart,
              children: [
                Text('Arriving Tomorrow\nBY 11am',style: CustomStyle.regularBlackLightText,),
                _product()
              ],
            ),
          )
        ],
      ),
    );
  }

  _product() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(
          Assets.train,
          height: 70,width: 70,),
        addHorizontalSpace(Dimensions.widthSize),
        Expanded(
            child: Column(
              crossAxisAlignment : CrossAxisAlignment.center,
              children: [
                Text('Toy Train Engine',style: CustomStyle.regularBlackText,),
                _buildRichText(title: 'QTY: ', value: '01'),
                _buildRichText(title: 'Tracking ID: ', value: '#78411561')
              ],
            )
        ),
      ],
    );
  }

  _buildRichText({required String title,required String value})
  {
    return Text.rich(
        textAlign: TextAlign.start,
        TextSpan(
            text: title,
            style: CustomStyle.regularBlackLightText,
            children: [
              TextSpan(
                  text: value,
                  style: CustomStyle.regularBlackText
              )
            ]
        )
    );
  }

  _paymentDetails() {
    return Card(
      elevation: 0,
      color: CustomColor.whiteColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius*0.8),
          side: const BorderSide(color: CustomColor.borderColor,width: 1)
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: Dimensions.heightSize,
          horizontal: Dimensions.widthSize
        ),
        child: Column(
          children: [
            _buildRowText(title: 'Payment Method:', value: 'Cash On Delivery'),
            _buildRowText(title: 'Transaction ID:', value: '#15468723')
          ],
        ),
      ),
    );
  }

  _addressDetails() {
    return Card(
      elevation: 0,
      color: CustomColor.whiteColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius*0.8),
          side: const BorderSide(color: CustomColor.borderColor,width: 1)
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: Dimensions.heightSize,
            horizontal: Dimensions.widthSize
        ),
        child: Column(
          crossAxisAlignment: crossStart,
          children: [
            Text('Ajwa road, Vadodara 123658',style: CustomStyle.regularBlackLightText,),
            Text('Gujarat, India',style: CustomStyle.regularBlackLightText,),
          ],
        ),
      ),
    );
  }

  _buildRowText({required String title,required String value})
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

  summary() {
    return Card(
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
            _buildRowText(title: 'Item:', value: 'Rs. 2950.00'),
            addVerticalSpace(Dimensions.heightSize*0.2),
            _buildRowText(title: 'Packaging:', value: 'Rs. 50.00'),
            addVerticalSpace(Dimensions.heightSize*0.2),
            _buildRowText(title: 'COD Fees:', value: 'Rs. 00.00'),
            addVerticalSpace(Dimensions.heightSize*0.2),
            _buildRowText(title: 'Tax:', value: 'Rs. 124.00'),
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
    );
  }

  _invoiceBtn() {
    return PrimaryButtonWidget(
        text: 'Download Invoice',
        radius: Dimensions.radius*0.6,
        onPressed: () {

        },
    );
  }
}
