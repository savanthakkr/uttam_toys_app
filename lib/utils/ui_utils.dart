import 'package:flutter/material.dart';

import 'custom_color.dart';
import 'custom_style.dart';
import 'dimensions.dart';

class UIUtils{

  static bottomToast({required BuildContext context,required String text,required bool isError})
  {
    // Fluttertoast.showToast(
    //   msg: text,
    //   backgroundColor: isError ? CustomColor.primaryColor : CustomColor.whiteColor,
    //   toastLength: Toast.LENGTH_SHORT,
    //   gravity: ToastGravity.BOTTOM,
    //   timeInSecForIosWeb: 1,
    //   textColor: Colors.black,
    // );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: isError ? CustomColor.hintColor : Colors.white,
        content: Text(text,style: CustomStyle.regularBlackLightText,),
        duration: Duration(milliseconds: 1500),
      ),
    );
  }

  static var textinputPadding = const EdgeInsets.symmetric(vertical: 15,horizontal: 10);

  static OutlineInputBorder searchInputBorder = OutlineInputBorder(
    borderSide: const BorderSide(
      color: CustomColor.hintColor,
    ),
    borderRadius: BorderRadius.circular(Dimensions.radius),
  );

  static OutlineInputBorder textInputBorder = OutlineInputBorder(
    borderSide: const BorderSide(
      color: CustomColor.blackColor,
      width: 1
    ),
    borderRadius: BorderRadius.circular(Dimensions.radius*0.5),
  );

  static OutlineInputBorder dropDownBorder =  OutlineInputBorder(
    borderSide: BorderSide(
      color: CustomColor.primaryColor,
      width: 1
    ),
    borderRadius: BorderRadius.circular(Dimensions.radius*0.5),
  );

  static OutlineInputBorder tansparentinputborder = OutlineInputBorder(
    borderSide: const BorderSide(
      color: Colors.transparent,
    ),
    borderRadius: BorderRadius.circular(Dimensions.radius),
  );

  static OutlineInputBorder errorBorder = OutlineInputBorder(
    borderSide: const BorderSide(
      color: Colors.red,
    ),
    borderRadius: BorderRadius.circular(Dimensions.radius*0.5),
  );

  static rounded_decoration({required Color color,required double radius,required Color borderColor})
  {
    return BoxDecoration(
        color: color,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.all(Radius.circular(radius))
    );
  }

  // static notFountText({required String text}){
  //   return Center(
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         //not_found.json
  //         // Lottie.asset('assets/lottie/not_found.json',
  //         //         height: 200,
  //         //         width: 200),
  //         Text(text,
  //           style: CustomStyle.notFoundTextStyle,),
  //       ],
  //     ),
  //   );
  // }
}