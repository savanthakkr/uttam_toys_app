import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uttam_toys/models/home_model.dart';
import 'package:uttam_toys/models/result_model.dart';
import 'package:uttam_toys/screens/product_details_screen.dart';
import 'package:uttam_toys/utils/intentutils.dart';
import 'package:uttam_toys/widgets/appbar_common.dart';

import '../apis/api_manager.dart';
import '../utils/assets.dart';
import '../utils/connection_utils.dart';
import '../utils/custom_color.dart';
import '../utils/custom_style.dart';
import '../utils/dimensions.dart';
import '../utils/prefs.dart';
import '../utils/size.dart';
import '../utils/ui_utils.dart';

class ProductListScreen extends StatefulWidget {
  final String type;

  ProductListScreen({
    super.key,
    required this.type,
  });

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {

  void _onBackPressed() {
    // IntentUtils.fireIntent(context, const MobileVerifyScreen());
    Navigator.of(context).pop();
    // return false;
  }

  bool _isLoading = false;

  String? userId;


  List<Product> trendingList = <Product>[];
  List<Product> featuredList = <Product>[];
  List<Product> sellingList = <Product>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPrefs();
    print(widget.type);
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
            itemCount: widget.type == "Featured Products" ? featuredList.length : widget.type == "Trending Products" ? trendingList.length : sellingList.length,
            itemBuilder: (BuildContext ctx, index) {
              return _itemView(widget.type == "Featured Products" ? featuredList[index] : widget.type == "Trending Products" ? trendingList[index] : sellingList[index]);
            }),
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
          trendingList.clear();
          featuredList.clear();
          sellingList.clear();
        });
        try{
          final HomeModel resultModel = await ApiManager.FetchHomeData(userId!);

          if(resultModel.error == false) {
            setState(() {
              _isLoading = false;
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

  _itemView(Product toy) {

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

    return GestureDetector(
      onTap: (){
        IntentUtils.fireIntent(context: context, screen: ProductDetailsScreen(pId: toy.id.toString(),), finishAll: false);
      },
      child: Card(
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
                    bytes != null ? Image.memory(bytes,height: 100,) : Image.asset(Assets.shapes,height: 100,),
                    Positioned(
                      right: 5,
                      top: 10,
                      child: InkWell(
                        onTap: () {
                          //todo add/remove wishlist
                        },
                        child: Icon(
                          toy.isWishlisted == null || !toy.isWishlisted! ? Icons.favorite_border_rounded : Icons.favorite,
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
                        Text("4.5" ?? '',
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
                  Text('\u20b9 ${toy.discountPrice}',
                    style: CustomStyle.blackSmallestTextStyle,
                    textAlign: TextAlign.start,),
                  addHorizontalSpace(Dimensions.widthSize*0.5),
                  Text('\u20b9 ${toy.mainPrice}',
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
      ),
    );
  }
}
