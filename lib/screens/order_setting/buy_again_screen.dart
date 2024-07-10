import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:uttam_toys_app/screens/order_details_screen.dart';
import 'package:uttam_toys_app/screens/order_setting/return_replace_screen.dart';
import 'package:uttam_toys_app/screens/order_setting/review_screen.dart';
import 'package:uttam_toys_app/screens/order_setting/track_order_screen.dart';
import 'package:uttam_toys_app/utils/assets.dart';
import 'package:uttam_toys_app/utils/custom_color.dart';
import 'package:uttam_toys_app/utils/intentutils.dart';
import 'package:uttam_toys_app/widgets/appbar_common.dart';
import 'package:uttam_toys_app/widgets/primary_button.dart';

import '../../utils/custom_style.dart';
import '../../utils/dimensions.dart';
import '../../utils/size.dart';

class BuyAgainScreen extends StatefulWidget {
  const BuyAgainScreen({super.key});

  @override
  State<BuyAgainScreen> createState() => _BuyAgainScreenState();
}

class _BuyAgainScreenState extends State<BuyAgainScreen> {

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
            title: 'Buy Again',
            leadingOnTap: _onBackPressed,
            hasBottom: true,
          ),
          body: ListView(
            padding: EdgeInsets.symmetric(
                vertical: Dimensions.heightSize,
                horizontal: Dimensions.widthSize
            ),
            children: [
              Row(
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
              ),
              addVerticalSpace(Dimensions.heightSize),
              const Divider(
                height: 0,
                thickness: 1,
                color: CustomColor.borderColor,
              ),
              addVerticalSpace(Dimensions.heightSize*1.5),
              _buildBtn(
                title: 'Track your order',
                onPressed: () {
                  IntentUtils.fireIntent(context: context, screen: TrackOrderScreen(), finishAll: false);
                },
              ),
              addVerticalSpace(Dimensions.heightSize),
              _buildBtn(
                title: 'Buy it again',
                onPressed: () {

                },
              ),
              addVerticalSpace(Dimensions.heightSize),
              _buildBtn(
                title: 'Return/Replace the item',
                onPressed: () {
                  IntentUtils.fireIntent(context: context, screen: ReturnReplaceScreen(), finishAll: false);
                },
              ),
              addVerticalSpace(Dimensions.heightSize*1.5),
              Text('How’s your item?',style: CustomStyle.blackMediumTextStyle,),
              addVerticalSpace(Dimensions.heightSize),
              _buildTextIconBtn(
                  title: 'Write a product review',
                  onPressed: (){
                    //review
                    IntentUtils.fireIntent(context: context, screen: ReviewScreen(), finishAll: false);
                  }
              ),
              addVerticalSpace(Dimensions.heightSize),
              Text('Order info',style: CustomStyle.blackMediumTextStyle,),
              addVerticalSpace(Dimensions.heightSize),
              _buildTextIconBtn(
                  title: 'View order details',
                  onPressed: (){
                    IntentUtils.fireIntent(context: context, screen: OrderDetailsScreen(), finishAll: false);
                  }
              ),
              addVerticalSpace(Dimensions.heightSize*1.5),
              Text('Return window closed on 12-05-2024',style: CustomStyle.regularBlackLightText.copyWith(
                color: CustomColor.hintColor
              ),),
              Text('Ordered on 05-05-2024',style: CustomStyle.regularBlackLightText.copyWith(
                  color: CustomColor.hintColor
              ),),
            ],
          ),
        )
    );
  }

  _buildBtn({required String title, required GestureTapCallback onPressed}) {
    return PrimaryButtonWidget(
        text: title,
        radius: Dimensions.radius*0.5,
        onPressed: onPressed,
    );
  }

  _buildTextIconBtn({required String title, required GestureTapCallback onPressed}) {
    return InkWell(
      onTap: onPressed,
      child: Card(
        elevation: 0,
        color: CustomColor.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(Dimensions.radius*0.5),
          ),
          side: const BorderSide(
            width: 1,
            color: CustomColor.borderColor,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: Dimensions.heightSize*0.6,
              horizontal: Dimensions.widthSize*1.5
          ),
          child: Row(
            children: [
              Expanded(
                  child: Text(title,style: CustomStyle.regularBlackLightText,)
              ),
              Icon(Icons.keyboard_arrow_right,size: Dimensions.iconSizeDefault,color: CustomColor.blackColor,)
            ],
          ),
        ),
      ),
    );
  }
}
