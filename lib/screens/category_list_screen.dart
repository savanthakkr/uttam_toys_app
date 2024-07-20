import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:uttam_toys/apis/api_manager.dart';
import 'package:uttam_toys/models/get_all_category_model.dart';
import 'package:uttam_toys/models/sub_category_model.dart';
import 'package:uttam_toys/screens/subcategory_product_list_screen.dart';
import 'package:uttam_toys/utils/intentutils.dart';
import 'package:uttam_toys/widgets/appbar_common.dart';

import '../models/category_model.dart';
import '../models/wishlist_model.dart';
import '../utils/assets.dart';
import '../utils/custom_color.dart';
import '../utils/custom_style.dart';
import '../utils/dimensions.dart';
import '../utils/size.dart';
import '../utils/ui_utils.dart';

class CategoryListScreen extends StatefulWidget {
  final String type;
  const CategoryListScreen({
    super.key,
    required this.type
  });

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {


  int selectedCatIndex=0;
  List<Category> usermodelList = <Category>[];
  List<Subcategory> subCategorymodelList = <Subcategory>[];
  bool _isLoading = false;
  dynamic strUserImage;

  void _onBackPressed() {
    // IntentUtils.fireIntent(context, const MobileVerifyScreen());
    Navigator.of(context).pop();
    // return false;

  }

  @override
  void initState() {
    super.initState();
    fetchUser();
  }



  fetchUser() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final GetCategory responseModel = await ApiManager.FetchCategoryApi();
      if (!responseModel.error) {
        setState(() {
          usermodelList = responseModel.categories;
          _isLoading = false;
        });
        fetchSubCategory(responseModel.categories.first.name);
        UIUtils.bottomToast(
            context: context, text: responseModel.message, isError: false);
      } else {
        setState(() {
          _isLoading = false;
        });
        UIUtils.bottomToast(
            context: context, text: responseModel.message, isError: true);
      }
    } on Exception catch (e) {
      setState(() {
        _isLoading = false;
      });
      UIUtils.bottomToast(context: context, text: e.toString(), isError: true);
      print(e.toString());
    }
  }

  fetchSubCategory(String? name) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final SubCategoryModel responseModel = await ApiManager.FetchSubCategory(name!);
      if (!responseModel.error) {
        setState(() {
          subCategorymodelList = responseModel.subcategories;
          _isLoading = false;
        });
        // UIUtils.bottomToast(
        //     context: context, text: responseModel.message, isError: false);
      } else {
        setState(() {
          _isLoading = false;
        });
        // UIUtils.bottomToast(
        //     context: context, text: responseModel.message, isError: true);
      }
    } on Exception catch (e) {
      setState(() {
        _isLoading = false;
      });
      UIUtils.bottomToast(context: context, text: e.toString(), isError: true);
      print(e.toString());
    }
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
          title: 'CATEGORIES',
          leadingOnTap: _onBackPressed,
          hasBottom: true,
        ),
        body:  Row(
          children: [
            Container(
              width: 100,
              color: CustomColor.cardColor,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: usermodelList.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return _rowCats(usermodelList[index],index);
                  },),
            ),
            Expanded(
              child: GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.widthSize*0.8,vertical: Dimensions.heightSize),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.height / 1.7),
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10),
                  itemCount: subCategorymodelList.length,
                  itemBuilder: (BuildContext ctx, index) {
                    return _itemView(index);
                  }),
            ),
          ],
        ),
      ),
    );
  }

  _rowCats(Category category, int index) {
    dynamic bytes;
    if(usermodelList.elementAt(index).image != null && usermodelList.elementAt(index).image.isNotEmpty){
      bytes = base64.decode(usermodelList.elementAt(index).image);
    } else {
      bytes = null;
    }
    return InkWell(
      onTap: () {
        setState(() {
          selectedCatIndex = index;
        });
        fetchSubCategory(usermodelList.elementAt(index).name);
      },
      child: Container(
        color: selectedCatIndex == index ? CustomColor.primaryColor.withOpacity(0.2) : Colors.transparent,
        margin: EdgeInsets.only(top: Dimensions.heightSize*0.5,left: 0),
        padding: EdgeInsets.zero,
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: mainStart,
            children: [
              VerticalDivider(
                thickness: 5,
                width: 0,
                color: selectedCatIndex == index ? CustomColor.primaryColor : Colors.transparent,
              ),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      height: 50.0,
                      width: 50.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(image: Image.memory(bytes!).image ),
                      ),
                    ),
                    Text(category.name ?? '',style: CustomStyle.smallHeadingTextStyle,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,)
                  ],
                ).marginOnly(left: Dimensions.widthSize*0.5,right: Dimensions.widthSize*0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _itemView( int index) {
    dynamic bytes;
    if(subCategorymodelList.elementAt(index).image != null && subCategorymodelList.elementAt(index).image.isNotEmpty){
      bytes = base64.decode(subCategorymodelList.elementAt(index).image);
    } else {
      bytes = null;
    }
    return GestureDetector(
      onTap: (){
        IntentUtils.fireIntentwithAnimations(context, SubcategoryProductListScreen(subCat: subCategorymodelList.elementAt(index).name), false);
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
                height: 100.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(image: Image.memory(bytes!).image ),
                ),
              ),
              addVerticalSpace(Dimensions.heightSize*0.9),
              Text(subCategorymodelList.elementAt(index).name ?? '',
                textAlign: TextAlign.center,
                style: CustomStyle.blackMediumTextStyle.copyWith(
                    fontSize: Dimensions.mediumTextSize
                ),),
            ],
          ),
        ),
      ),
    );
  }
}
