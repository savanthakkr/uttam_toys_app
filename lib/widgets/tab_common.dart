import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/custom_color.dart';
import '../utils/dimensions.dart';
import '../utils/size.dart';

class TabCommon extends StatelessWidget {
  final int? index,selectedIndex;
  final String? title;
  final String image;
  final GestureTapCallback? onTap;

  const TabCommon({Key? key,
    required this.title,
    required this.index,
    required this.image,
    required this.selectedIndex,
    required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minWidth: Dimensions.marginSize*2
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radius*2),
        color: selectedIndex == index ? CustomColor.primaryColor.withOpacity(0.2) : Colors.white
      ),
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.widthSize,
        vertical: Dimensions.heightSize*0.5
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Container(
              //   height: 2,
              //   color: dashboardCtrl.selectedIndex == index
              //       ? appCtrl.appTheme.sameWhite
              //       : appCtrl.appTheme.primary,
              //   width: MediaQuery.of(context).size.width * .1,
              // ),
              SvgPicture.asset(
                  image,
                  colorFilter: ColorFilter.mode(selectedIndex == index ? CustomColor.primaryColor : CustomColor.blackColor,
                      BlendMode.srcATop),
                  // dashboardCtrl.selectedIndex == index ? sImage! : usImage!,
                  height:  20,
                  width:  20,
                  fit: BoxFit.fill),
              addHorizontalSpace(Dimensions.widthSize*0.5),
              if(selectedIndex == index)Text(title!.toString(),
                  style: GoogleFonts.poppins(
                    color: CustomColor.blackColor,
                    fontSize: Dimensions.smallestTextSize,
                    fontWeight: FontWeight.w500,
                  ))
            ]),
      ),
    );
  }
}
