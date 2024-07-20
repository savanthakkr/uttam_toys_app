import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uttam_toys/apis/api_manager.dart';
import 'package:uttam_toys/models/home_model.dart';
import 'package:uttam_toys/models/result_model.dart';
import 'package:uttam_toys/screens/category_list_screen.dart';
import 'package:uttam_toys/screens/notifications_screen.dart';
import 'package:uttam_toys/screens/product_details_screen.dart';
import 'package:uttam_toys/screens/product_list_screen.dart';
import 'package:uttam_toys/utils/assets.dart';
import 'package:uttam_toys/utils/connection_utils.dart';
import 'package:uttam_toys/utils/custom_color.dart';
import 'package:uttam_toys/utils/custom_style.dart';
import 'package:uttam_toys/utils/dimensions.dart';
import 'package:uttam_toys/utils/intentutils.dart';
import 'package:uttam_toys/utils/size.dart';
import 'package:uttam_toys/utils/ui_utils.dart';

import '../../models/category_model.dart';
import '../../utils/prefs.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _bannerList = [
    'assets/temp/banner.png',
    'assets/temp/banner.png',
    'assets/temp/banner.png'
  ];

  List<Category> catList = <Category>[];
  List<Product> trendingList = <Product>[];
  List<Product> featuredList = <Product>[];
  List<Product> sellingList = <Product>[];
  late double mWidth,mHeight;
  bool _isLoading = false;
  String? userId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPrefs();
    getHomeData();
  }
  getPrefs() async {
    SharedPreferences mPrefs = await SharedPreferences.getInstance();
    String? uId = mPrefs.getString(Prefs.ID);
    setState(() {
      userId = uId;
    });
  }

  @override
  Widget build(BuildContext context) {
    mWidth = MediaQuery.of(context).size.width;
    mHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: CustomColor.backgroundColor,
      appBar: AppBar(
        backgroundColor: CustomColor.whiteColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(greeting(),style: CustomStyle.blackMediumTextStyle.copyWith(
              fontSize: Dimensions.regularTextSize
            ),),
            Text('User',style: CustomStyle.regularBlackLightText.copyWith(
                fontSize: Dimensions.smallestTextSize
            ),)
          ],
        ),
        actions: [
          InkWell(
            onTap: () {
              //todo
            },
            child: SvgPicture.asset(
              Assets.searchSvg,
              height: 20,
              width: 20,
            ),
          ),
          addHorizontalSpace(Dimensions.widthSize),
          InkWell(
            onTap: () {
              IntentUtils.fireIntent(context: context, screen: NotificationsScreen(), finishAll: false);
            },
            child: SvgPicture.asset(
              Assets.bellSvg,
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
          horizontal: 0
        ),
        children: [
          CarouselSlider(
            options: CarouselOptions(
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                height: mHeight*0.24),
            items: _bannerList
                .map((item) =>
                Container(
                  child: bannerItems(item),
                )
            )
                .toList(),
          ),
          addVerticalSpace(Dimensions.heightSize),
          _headingText(title: 'Categories', onTap: () {
            IntentUtils.fireIntent(context: context, screen: CategoryListScreen(type: 'All',), finishAll: false);
          },),
          _categoryList(),
          addVerticalSpace(Dimensions.heightSize),
          _headingText(title: 'Trending Products', onTap: () {
            IntentUtils.fireIntent(context: context, screen: ProductListScreen(type: 'Trending Products',
            ),
                finishAll: false);
          },),
          _trendingList(),
          addVerticalSpace(Dimensions.heightSize),
          _headingText(title: 'Featured Products', onTap: () {
            IntentUtils.fireIntent(context: context, screen: ProductListScreen(type: 'Featured Products',
            ),
                finishAll: false);
          },),
          _feturedList(),
          addVerticalSpace(Dimensions.heightSize),
          _headingText(title: 'Best Selling Products', onTap: () {
            IntentUtils.fireIntent(context: context, screen: ProductListScreen(type: 'Best Selling Products',
            ),
                finishAll: false);
          },),
          _sellingList()
        ],
      ),
    );
  }

  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    }
    if (hour < 17) {
      return 'Good Afternoon';
    }
    return 'Good Evening';
  }

  Widget bannerItems(String? item) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Dimensions.widthSize * 0.2),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Image.asset(
          item!,
          width: double.infinity,
          height: mWidth,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
  
  _headingText({required String title,required GestureTapCallback onTap})
  {
    return Row(
      mainAxisAlignment: mainSpaceBet,
      children: [
        Expanded(
          child: Text(title,
            style: CustomStyle.primaryRegularBoldText,
            textAlign: TextAlign.start,),
        ),
        Expanded(
          child: InkWell(
            onTap: onTap,
            child: Row(
              mainAxisSize: mainMax,
              mainAxisAlignment: mainEnd,
              children: [
                Text('View All',
                  style: CustomStyle.primaryRegularBoldText,
                  textAlign: TextAlign.end,),
                const Icon(
                  Icons.keyboard_arrow_right,
                  color: CustomColor.primaryColor,
                )
              ],
            ),
          ),
        ),
      ],
    ).paddingSymmetric(
        vertical: 0,
        horizontal: Dimensions.widthSize*0.5
    );
  }

  _categoryList() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(
          vertical: Dimensions.heightSize*0.5,
          horizontal: 0
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: mainSpaceBet,
        children: [
          for(int i=0; i<catList.length ; i++)
            _rowCats(catList.elementAt(i))
        ],
      ),
    );
  }

  _rowCats(Category category) {

    dynamic bytes;
    if(category.image.isNotEmpty){
      bytes = base64.decode(category.image);
    } else {
      bytes = null;
    }

    return Column(
      crossAxisAlignment: crossCenter,
      children: [
        SizedBox(
          height: 65,
          width: 65,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: CustomColor.primaryColor
                ),
              ),
              Image.memory(bytes!,height: 65,width: 65,)
              // Image.asset(
              //     category.image!,
              //   height: 65,
              //   width: 65,
              // )
            ],
          ),
        ),
        Text(category.name ?? '',style: CustomStyle.smallHeadingTextStyle,textAlign: TextAlign.center,)
      ],
    ).marginOnly(left: Dimensions.widthSize*0.5,right: Dimensions.widthSize*0.5);
  }

  _trendingList() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(
          vertical: Dimensions.heightSize*0.5,
          horizontal: Dimensions.widthSize
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: mainSpaceBet,
        children: [
          for(int i=0; i<trendingList.length ; i++)
            _rowToys(trendingList.elementAt(i))
        ],
      ),
    );
  }

  _feturedList() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(
          vertical: Dimensions.heightSize*0.5,
          horizontal: Dimensions.widthSize
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: mainSpaceBet,
        children: [
          for(int i=0; i<featuredList.length ; i++)
            _rowToys(featuredList.elementAt(i))
        ],
      ),
    );
  }

  _sellingList() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(
          vertical: Dimensions.heightSize*0.5,
          horizontal: Dimensions.widthSize
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: mainSpaceBet,
        children: [
          for(int i=0; i<sellingList.length ; i++)
            _rowToys(sellingList.elementAt(i))
        ],
      ),
    );
  }

  _rowToys(Product toy) {

    dynamic bytes;
    if(toy.images.isNotEmpty){
      if(toy.images.first.isNotEmpty) {
        bytes = base64.decode(toy.images.first);
      } else {
        bytes = null;
      }
    } else {
      bytes = null;
    }

    return Card(
      elevation: 0,
      color: CustomColor.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.radius*1.8)
      ),
      child: InkWell(
        onTap: () {
          IntentUtils.fireIntent(context: context, screen: ProductDetailsScreen(pId: toy.id.toString(),), finishAll: false);
        },
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 120,
            minHeight: 120,
            maxWidth: 140
          ),
          child: Column(
            crossAxisAlignment: crossStart,
            children: [
              SizedBox(
                height: 120,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    bytes != null ? Image.memory(bytes,height: 100,) : Image.asset(Assets.shapes,height: 100,),
                    Positioned(
                      right: 2,
                      top: 10,
                      child: InkWell(
                        onTap: () {
                          //todo add/remove wishlist
                          saveProduct(toy.id);
                        },

                        child: Icon(
                          toy.isWishlisted != true  ? Icons.favorite_border_rounded : Icons.favorite,
                          color: CustomColor.primaryColor,
                          size: Dimensions.iconSizeDefault,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              addVerticalSpace(Dimensions.heightSize*0.5),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.widthSize,
                  vertical: 0
                ),
                child: Text(toy.name ?? '',
                  textAlign: TextAlign.start,
                  style: CustomStyle.smallHeadingTextStyle,),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: mainMax,
                children: [
                  Text('\u20b9 ${toy.discountPrice}',
                    style: CustomStyle.blackSmallestTextStyle,
                  textAlign: TextAlign.start,),
                  const Spacer(),
                  Row(
                    mainAxisSize: mainMax,
                    mainAxisAlignment: mainSpaceBet,
                    children: [
                      SvgPicture.asset(Assets.starSvg,height: 12,width: 12,),
                      Text("4.5" ?? '',
                        style: CustomStyle.blackSmallestTextStyle,
                      textAlign: TextAlign.end,),
                    ],
                  )
                ],
              ).paddingSymmetric(
                  horizontal: Dimensions.widthSize,
                  vertical: Dimensions.heightSize*0.2
              )
            ],
          ),
        ),
      ),
    );
  }

  void saveProduct(int id) {
    ConnectionUtils.checkConnection().then((internet) async {
      if (internet) {
        setState(() {
          _isLoading = true;
        });
        try {

          // Simulate an API call with delay
          final ResultModel resultModel = await ApiManager.saveProducts(
              userId!,
              id
          );

          if (resultModel.error == false) {
            setState(() {
              _isLoading = false;
            });
            print("Product saved successfully");
            UIUtils.bottomToast(context: context, text: resultModel.message, isError: false);
            getHomeData();
          } else {
            setState(() {
              _isLoading = false;
            });
            print("Error saving Product: ${resultModel.message}");
            UIUtils.bottomToast(context: context, text: resultModel.message, isError: true);
          }
        } catch (e) {
          setState(() {
            _isLoading = false;
          });
          print("Exception occurred: $e");
          UIUtils.bottomToast(context: context, text: e.toString(), isError: true);
        }
      } else {
        // No-Internet Case
        UIUtils.bottomToast(
            context: context,
            text: "Please check your internet connection",
            isError: true);
      }
    });
  }

  void getHomeData() {
    ConnectionUtils.checkConnection().then((intenet) async {
      if (intenet) {
        setState(() {
          _isLoading = true;
          catList.clear();
          trendingList.clear();
          featuredList.clear();
          sellingList.clear();
        });
        try{
          final HomeModel resultModel = await ApiManager.FetchHomeData(userId!);

          if(resultModel.error == false) {
            setState(() {
              _isLoading = false;
              catList = resultModel.category;
              trendingList = resultModel.trendingProduct;
              featuredList = resultModel.featuredProduct;
              sellingList = resultModel.bestSellingProduct;
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
}
