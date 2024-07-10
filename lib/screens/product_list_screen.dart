import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:uttam_toys_app/widgets/appbar_common.dart';

import '../models/wishlist_model.dart';
import '../utils/assets.dart';
import '../utils/custom_color.dart';
import '../utils/custom_style.dart';
import '../utils/dimensions.dart';
import '../utils/size.dart';

class ProductListScreen extends StatefulWidget {
  final String type;
  const ProductListScreen({
    super.key,
    required this.type
  });

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final toysList = <WishlistModel>[
    WishlistModel('Colorful shape', Assets.shapes, '499','599', '4.5', false,'100'),
    WishlistModel('Colorful shape', Assets.shapes, '499','599', '4.5', false,'50'),
    WishlistModel('Colorful shape', Assets.shapes, '499', '599','4.5', true,'70'),
    WishlistModel('Colorful shape', Assets.shapes, '499','599', '4.5', false,'50'),
    WishlistModel('Colorful shape', Assets.shapes, '499','599', '4.5', false,'100'),
  ];

  void _onBackPressed() {
    // IntentUtils.fireIntent(context, const MobileVerifyScreen());
    Navigator.of(context).pop();
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
        backgroundColor: CustomColor.backgroundColor,
        appBar: CommonAppbar(
          title: widget.type,
          leadingOnTap: _onBackPressed,
        ),
        body:  GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.widthSize*1.5,vertical: Dimensions.heightSize),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: MediaQuery.of(context).size.width /
                    (MediaQuery.of(context).size.height / 1.35),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10),
            itemCount: toysList.length,
            itemBuilder: (BuildContext ctx, index) {
              return _itemView(toysList[index]);
            }),
      ),
    );
  }

  _itemView(WishlistModel toy) {
    return Card(
      elevation: 0,
      color: CustomColor.whiteColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius),
          side: const BorderSide(color: CustomColor.borderColor,width: 1,style: BorderStyle.solid)
      ),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: BoxConstraints(
            minWidth: 120,
            minHeight: 120,
            maxWidth: 140
        ),
        child: Column(
          crossAxisAlignment: crossStretch,
          children: [
            Container(
              color: CustomColor.cardColor,
              height: 120,
              width: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(toy.image!,height: 100,width: double.infinity,fit: BoxFit.contain,),
                  Positioned(
                    right: 5,
                    top: 10,
                    child: InkWell(
                      onTap: () {
                        //todo add/remove wishlist
                      },
                      child: Icon(
                        !toy.isWishlisted! ? Icons.favorite_border_rounded : Icons.favorite,
                        color: CustomColor.primaryColor,
                        size: Dimensions.iconSizeDefault,
                      ),
                    ),
                  )
                ],
              ),
            ),
            addVerticalSpace(Dimensions.heightSize*0.2),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.widthSize,
                  vertical: 0
              ),
              child: Row(
                crossAxisAlignment: crossStart,
                children: [
                  Flexible(
                    child: Text(toy.name ?? '',
                      textAlign: TextAlign.start,
                      style: CustomStyle.smallHeadingTextStyle,),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisSize: mainMin,
                    mainAxisAlignment: mainSpaceBet,
                    children: [
                      SvgPicture.asset(Assets.starSvg,height: 12,width: 12,),
                      Text(toy.rating ?? '',
                        style: CustomStyle.blackSmallestTextStyle,
                        textAlign: TextAlign.end,),
                    ],
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: mainMin,
              children: [
                Text('\u20b9 ${toy.price}',
                  style: CustomStyle.blackSmallestTextStyle,
                  textAlign: TextAlign.start,),
                addHorizontalSpace(Dimensions.widthSize*0.5),
                Text('\u20b9 ${toy.oldPrice}',
                  style: CustomStyle.cancelledTextStyle,
                  textAlign: TextAlign.start,),
              ],
            ).paddingSymmetric(
                horizontal: Dimensions.widthSize,
                vertical: 0
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.widthSize,
                  vertical: Dimensions.heightSize*0.1
              ),
              child: toy.priceDrop!=null ? Row(
                mainAxisSize: mainMin,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline_rounded,color: CustomColor.borderColor,size: Dimensions.iconSizeSmall,),
                  addHorizontalSpace(Dimensions.widthSize*0.2),
                  Text('Price dropped by \u20b9${toy.priceDrop}',
                    style: CustomStyle.blackSmallestTextStyle.copyWith(
                        fontSize: 10
                    ),
                    textAlign: TextAlign.start,),
                ],
              )  : SizedBox(height: Dimensions.heightSize,),
            ),
            const Divider(
              color: CustomColor.borderColor,
              height: 0,
              thickness: 0.5,
            ),
            InkWell(
              onTap: () {
                //todo add cart
              },
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: Dimensions.heightSize*0.5,
                    horizontal: 0
                ),
                child: Center(
                  child: Text(
                    'move to bag'.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: CustomStyle.primaryRegularBoldText,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
