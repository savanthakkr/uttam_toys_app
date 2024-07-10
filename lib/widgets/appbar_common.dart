import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/assets.dart';
import '../utils/custom_color.dart';
import '../utils/custom_style.dart';
import '../utils/dimensions.dart';

class CommonAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final GestureTapCallback? leadingOnTap;
  final double elavation;
  final List<Widget>? actions;
  final Color bgColor;
  final Color textColor ;
  final bool centerTitle;
  final bool backEnable;
  final bool hasBottom;

  const CommonAppbar(
      {
        super.key,
        required this.title,
        this.leadingOnTap,
        this.elavation = 1,
        this.actions,
        this.bgColor = CustomColor.whiteColor,
        this.textColor = CustomColor.blackColor,
        this.centerTitle = true,
        this.backEnable = true,
        this.hasBottom = false
      });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      systemOverlayStyle: const SystemUiOverlayStyle(
        // Status bar color
        statusBarColor: CustomColor.whiteColor,
        // Status bar brightness (optional)
        statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
        statusBarBrightness: Brightness.light, // For iOS (dark icons)
      ),
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      title: Text(title,style: CustomStyle.appbarTextTitleDark,),
      // leadingWidth: 40,
      leading: backEnable ?  Container(
        margin: EdgeInsets.only(left: Dimensions.widthSize,right: Dimensions.widthSize),
        child: InkWell(
          onTap: leadingOnTap,
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: textColor,
          ),
        ),
      ): null,
      automaticallyImplyLeading: false,
      actions: actions,
      bottom: hasBottom ? PreferredSize(
        preferredSize: const Size.fromHeight(4.0),
        child: Container(
          color: CustomColor.borderColor,
          height: 1.0,
        ),
      ): null,
    );
  }

  @override
  // implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
