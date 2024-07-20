import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uttam_toys/screens/bottom/cart_screen.dart';
import 'package:uttam_toys/screens/bottom/order_screen.dart';
import 'package:uttam_toys/screens/bottom/wishlist_screen.dart';
import 'dart:io' as io;

import '../../utils/assets.dart';
import '../../utils/custom_color.dart';
import '../../utils/dimensions.dart';
import '../../utils/size.dart';
import '../../utils/ui_utils.dart';
import '../../widgets/tab_common.dart';
import 'account_screen.dart';
import 'home_screen.dart';

class UserBottomBar extends StatefulWidget {
  const UserBottomBar({super.key});

  @override
  State<UserBottomBar> createState() => _UserBottomBarState();
}

class _UserBottomBarState extends State<UserBottomBar> {
  DateTime? currentBackPressTime;
  int selectedIndex=0;

  onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      UIUtils.bottomToast(context: context, text: 'Press Back Once Again to Exit.', isError: false);
      return false;
    } else {
      return true;
    }
  }

  onBottomTap(int value) {
    setState(() {
      selectedIndex = value;
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
          bool backStatus = onWillPop();
          if (backStatus) {
            io.exit(0);
          }
        }
      },
      child: Scaffold(
        backgroundColor: CustomColor.backgroundColor,
        extendBodyBehindAppBar: false,
        extendBody: false,
        body: selectedIndex == 0 ? const HomeScreen()
                  : selectedIndex == 1 ? const WishlistScreen()
                      :selectedIndex == 2 ? const OrderScreen()
                          :selectedIndex == 3 ? const CartScreen()
                            :const AccountScreen(),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
              boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 2)]),
          child: BottomAppBar(
            height: Dimensions.bottomBarHeight,
            color: CustomColor.whiteColor,
            surfaceTintColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: Dimensions.heightSize*0.2,horizontal: Dimensions.widthSize),
            child: Row( //children inside bottom appbar
              // mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: mainMax,
              children: <Widget>[
                TabCommon(
                  onTap:() => onBottomTap(0),
                  index: 0,
                  selectedIndex: selectedIndex,
                  title: 'Home',
                  image: Assets.homeSvg,
                ),
                TabCommon(
                  onTap: () => onBottomTap(1),
                  index: 1,
                  selectedIndex: selectedIndex,
                  title: 'Wishlist',
                  image: Assets.wishlistSvg,
                ),
                TabCommon(
                  onTap:() => onBottomTap(2),
                  index: 2,
                  selectedIndex: selectedIndex,
                  title: 'Orders',
                  image: Assets.ordersSvg,
                ),
                TabCommon(
                  onTap:() => onBottomTap(3),
                  index: 3,
                  selectedIndex: selectedIndex,
                  title: 'cart',
                  image: Assets.cartSvg,
                ),
                TabCommon(
                  onTap:() => onBottomTap(4),
                  index: 4,
                  selectedIndex: selectedIndex,
                  title: 'Account',
                  image: Assets.accountSvg,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
