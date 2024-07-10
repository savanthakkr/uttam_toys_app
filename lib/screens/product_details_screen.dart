import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:uttam_toys_app/screens/buy_now_screen.dart';
import 'package:uttam_toys_app/utils/custom_color.dart';
import 'package:uttam_toys_app/utils/custom_style.dart';
import 'package:uttam_toys_app/utils/intentutils.dart';
import 'package:uttam_toys_app/widgets/appbar_common.dart';
import 'package:uttam_toys_app/widgets/primary_button.dart';

import '../models/review_model.dart';
import '../utils/assets.dart';
import '../utils/dimensions.dart';
import '../utils/size.dart';
import '../widgets/page_indicator.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late double mWidth,mHeight;
  bool _isWishlisted = false;
  final _imageList = [
    Assets.train,
    Assets.train,
    Assets.train
  ];
  int _currentIndex = 0;
  List<ReviewModel> _reviews = <ReviewModel>[];

  void _onBackPressed() {
    // IntentUtils.fireIntent(context, const MobileVerifyScreen());
    Navigator.of(context).pop();
    // return false;
  }

  @override
  void initState() {
    getReviews();
    super.initState();
  }

  void getReviews()
  {
    setState(() {
      _reviews.add(ReviewModel('Rajat Kumar', '4.2', 'Review: Excellent product, Money worth product'));
      _reviews.add(ReviewModel('Rajat Kumar', '4.2', 'Review: Excellent product, Money worth product'));
      _reviews.add(ReviewModel('Rajat Kumar', '4.2', 'Review: Excellent product, Money worth product'));
      _reviews.add(ReviewModel('Rajat Kumar', '4.2', 'Review: Excellent product, Money worth product'));
    });
  }
  
  @override
  Widget build(BuildContext context) {
    mWidth = MediaQuery.of(context).size.width;
    mHeight = MediaQuery.of(context).size.height;

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
          title: 'Product Description',
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
            _imageSlider(),
            Container(
              alignment: Alignment.center,
              height: 20,
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _buildPageIndicator(),
                  )
              ),
            ),
            addVerticalSpace(Dimensions.heightSize),
            Text('TOY TRAIN ENGINE',style: CustomStyle.blackMediumTextStyle,),
            Text('5-6 year kids plastic toy train engine',style: CustomStyle.regularBlackLightText,),
            Row(
              children: [
                Text('MRP \u20b9499',style: CustomStyle.blackMediumTextStyle,),
                addHorizontalSpace(Dimensions.widthSize*0.5),
                Text('\u20b9599',
                  style: CustomStyle.cancelledTextStyle.copyWith(
                    fontSize: Dimensions.mediumTextSize
                  ),
                  textAlign: TextAlign.start,),
              ],
            ),
            addVerticalSpace(Dimensions.heightSize),
            Text('Available Colors',style: CustomStyle.regularBlackText,),
            _colorList(),
            addVerticalSpace(Dimensions.heightSize),
            Row(
              children: [
                Expanded(
                  flex: 5,
                    child: PrimaryButtonWidget(
                        text: 'Buy Now',
                        backgroundColor: Colors.white,
                        borderColor: CustomColor.primaryColor,
                        textColor: CustomColor.primaryColor,
                        smallButton: true,
                        radius: Dimensions.radius*0.6,
                        elevation: 0,
                        onPressed: () {
                          IntentUtils.fireIntent(context: context, screen: BuyNowScreen(), finishAll: false);
                        },
                    )
                ),
                Expanded(
                    flex: 5,
                    child: PrimaryButtonWidget(
                      text: 'Add to cart',
                      smallButton: true,
                      radius: Dimensions.radius*0.6,
                      onPressed: () {
                        //todo add to cart
                      },
                    )
                )
              ],
            ),
            addVerticalSpace(Dimensions.heightSize),
            deliveryAddress(),
            addVerticalSpace(Dimensions.heightSize*0.5),
            service(svgIcon: Assets.boxSvg,title: 'Get it by Fri,10 may'),
            service(svgIcon: Assets.codSvg,title: 'Pay on delivery'),
            service(svgIcon: Assets.returnSvg,title: '07 Days returnable'),
            addVerticalSpace(Dimensions.heightSize),
            Text('Ratings & Reviews',style: CustomStyle.primaryRegularBoldText,),
            _totalReviews(),
            addVerticalSpace(Dimensions.heightSize),
            Text('Customer Reviews',style: CustomStyle.primaryRegularBoldText,),
            _reviewListWidget()
          ],
        ),
      )
    );
  }

  _imageSlider() {
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        height: mHeight*0.35,
        onPageChanged: (index, reason) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      items: _imageList
          .map((item) =>
          Container(
            child: imgItems(item),
          )
      )
          .toList(),
    );
  }

  imgItems(String item) {
    return Card(
      color: CustomColor.cardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.radius*0.5),
        side: BorderSide(color: CustomColor.borderColor,width: 1)
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: Dimensions.heightSize,
          horizontal: Dimensions.widthSize
        ),
        child: SizedBox(
          height: mHeight*0.35,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(item,height: mWidth,width: mWidth,),
              Positioned(
                right: 0,
                top: 0,
                child: InkWell(
                  onTap: () {
                    //todo add/remove wishlist
                  },
                  child: Icon(
                    !_isWishlisted ? Icons.favorite_border_rounded : Icons.favorite,
                    color: CustomColor.primaryColor,
                    size: Dimensions.iconSizeDefault,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _imageList.length; i++) {
      list.add(PageIndicator(isActive: i == _currentIndex ? true : false));
    }
    return list;
  }

  _colorList() {
    return SizedBox(
      height: 80,
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        children: [
          colorItem(),
          colorItem(),
          colorItem(),
          colorItem(),
        ],
      ),
    );
  }

  colorItem() {
    return Image.asset(
      Assets.train,
      height: 70,
      width: 70,
    ).marginOnly(right: Dimensions.widthSize);
  }

  deliveryAddress() {
    return Row(
      children: [
        Expanded(
          flex: 7,
            child: Column(
              crossAxisAlignment: crossStart,
              children: [
                Text('Delivery & Services',style: CustomStyle.regularBlackText,),
                Text('Lorem ipsum dolor sit amet (123456)',style: CustomStyle.hintTextStyle,)
              ],
            )
        ),
        Expanded(
            flex: 3,
            child: PrimaryButtonWidget(
              text: 'Change',
              smallButton: true,
              radius: Dimensions.radius*0.6,
              onPressed: () {

              },
            )
        )
      ],
    );
  }

  service({required String svgIcon, required String title}) {
    return Row(
      children: [
        SvgPicture.asset(svgIcon,height: 20,width: 20,),
        addHorizontalSpace(Dimensions.widthSize*0.5),
        Text(title,style: CustomStyle.regularBlackText,)
      ],
    );
  }

  _totalReviews() {
    return Row(
      mainAxisSize: mainMax,
      mainAxisAlignment: mainStart,
      children: [
        SvgPicture.asset(Assets.starSvg,height: 18,width: 18,),
        addHorizontalSpace(Dimensions.widthSize*0.5),
        Text.rich(
            textAlign: TextAlign.end,
            TextSpan(
                text: '4.5',
                style: CustomStyle.blackMediumTextStyle,
                children: [
                  TextSpan(
                      text: ' 20567 Ratings',
                      style: CustomStyle.hintTextStyle
                  ),
                  TextSpan(
                      text: ' | ',
                      style: CustomStyle.hintTextStyle.copyWith(color: Colors.black)
                  ),
                  TextSpan(
                      text: '17302 Reviews',
                      style: CustomStyle.hintTextStyle
                  )
                ]
            )
        ),
      ],
    );
  }

  _reviewListWidget(){
    return Column(
      children: [
        for(int i=0; i<_reviews.length ; i++)
          _reviewItem(_reviews[i])
      ],
    );
  }

  _reviewItem(ReviewModel review) {
    return Row(
      mainAxisSize: mainMax,
      mainAxisAlignment: mainStart,
      children: [
        Image.asset(Assets.train,width: 100,),
        addHorizontalSpace(Dimensions.widthSize*0.5),
        Expanded(
            child: Column(
              crossAxisAlignment: crossStart,
              children: [
                Text(review.name!,style: CustomStyle.blackSmallestTextStyle,),
                Row(
                  children: [
                    Text('Rating: ',style: CustomStyle.hintTextStyle,),
                    Text(review.rating!,style: CustomStyle.smallHeadingTextStyle,),
                    addHorizontalSpace(Dimensions.widthSize*0.2),
                    SvgPicture.asset(Assets.starSvg,height: 15,width: 15,),
                  ],
                ),
                Text(review.review!,style: CustomStyle.blackSmallestTextStyle,),
              ],
            )
        )
      ],
    ).marginOnly(top: Dimensions.heightSize);
  }


}
