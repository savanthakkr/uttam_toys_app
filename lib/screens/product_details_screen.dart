import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uttam_toys/apis/api_manager.dart';
import 'package:uttam_toys/models/product_details_model.dart';
import 'package:uttam_toys/models/ragister_model.dart';
import 'package:uttam_toys/screens/buy_now_screen.dart';
import 'package:uttam_toys/utils/connection_utils.dart';
import 'package:uttam_toys/utils/custom_color.dart';
import 'package:uttam_toys/utils/custom_style.dart';
import 'package:uttam_toys/utils/intentutils.dart';
import 'package:uttam_toys/utils/prefs.dart';
import 'package:uttam_toys/utils/ui_utils.dart';
import 'package:uttam_toys/widgets/appbar_common.dart';
import 'package:uttam_toys/widgets/primary_button.dart';

import '../models/review_model.dart';
import '../utils/assets.dart';
import '../utils/dimensions.dart';
import '../utils/size.dart';
import '../widgets/page_indicator.dart';

class ProductDetailsScreen extends StatefulWidget {

  String pId;
  ProductDetailsScreen({super.key,required this.pId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late double mWidth,mHeight;
  bool _isWishlisted = false;
  bool _isLoading = false;
  final _dummyimageList = [
    Assets.train,
    Assets.train,
    Assets.train
  ];
  int _currentIndex = 0;
  List<ReviewModel> _reviews = <ReviewModel>[];
  List<ProductDetail> productDetails = <ProductDetail>[];
  List<String> _imageList = <String>[];
  String? userId;

  void _onBackPressed() {
    // IntentUtils.fireIntent(context, const MobileVerifyScreen());
    Navigator.of(context).pop();
    // return false;
  }

  @override
  void initState() {
    getPrefs();
    super.initState();
  }

  getPrefs() async {
    SharedPreferences mPrefs = await SharedPreferences.getInstance();
    String? uId = mPrefs.getString(Prefs.ID);
    setState(() {
      userId = uId;
    });
    getReviews();
    getProductDetails();
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
        body: _isLoading ? Center(child: CircularProgressIndicator(color: CustomColor.primaryColor,)) : ListView(
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
            Text(productDetails.isNotEmpty ? productDetails.first.name : "",style: CustomStyle.blackMediumTextStyle,),
            Text(productDetails.isNotEmpty ? productDetails.first.descriptionShort : "",style: CustomStyle.regularBlackLightText,),
            Row(
              children: [
                Text('MRP \u20b9 ${productDetails.isNotEmpty ? productDetails.first.discountPrice : "0"}',style: CustomStyle.blackMediumTextStyle,),
                addHorizontalSpace(Dimensions.widthSize*0.5),
                Text('\u20b9 ${productDetails.isNotEmpty ? productDetails.first.mainPrice : "0"}',
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
                        AddCart();
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
      items: _imageList.isNotEmpty ? _imageList
          .map((item) =>
          Container(
            child: imgItems(item),
          )
      )
          .toList() : _dummyimageList
          .map((item) =>
          Container(
            child: dummyimgItems(item),
          )
      )
          .toList(),
    );
  }

  imgItems(String item) {

    dynamic bytes;
    if(item.isNotEmpty) {
      bytes = base64.decode(item);
    } else {
      bytes = null;
    }

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
              bytes != null ? Image.memory(bytes,height: mWidth,width: mWidth,) : Image.asset(item,height: mWidth,width: mWidth,),
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

  dummyimgItems(String item) {
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
    if(_imageList.isNotEmpty) {
      for (int i = 0; i < _imageList.length; i++) {
        list.add(PageIndicator(isActive: i == _currentIndex ? true : false));
      }
    } else {
      for (int i = 0; i < _dummyimageList.length; i++) {
        list.add(PageIndicator(isActive: i == _currentIndex ? true : false));
      }
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

  void getProductDetails() {
    ConnectionUtils.checkConnection().then((intenet) async {
      if (intenet) {
        setState(() {
          _isLoading = true;
          productDetails.clear();
        });
        try{
          final ProductDetailsModel resultModel = await ApiManager.FetchProductDetails(widget.pId);

          if(resultModel.error == false) {
            setState(() {
              _isLoading = false;
              productDetails = resultModel.productDetails;
              _imageList = resultModel.productDetails.first.images;
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

  void AddCart() {
    ConnectionUtils.checkConnection().then((intenet) async {
      if (intenet) {
        setState(() {
          _isLoading = true;
        });
        try{
          final RegisterModel resultModel = await ApiManager.AddtoCart(widget.pId,userId!,"1");

          if(resultModel.error == false) {
            setState(() {
              _isLoading = false;
            });

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

}
