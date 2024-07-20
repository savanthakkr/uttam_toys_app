import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uttam_toys/screens/auth/login_screen.dart';
import 'package:uttam_toys/utils/assets.dart';
import 'package:uttam_toys/utils/custom_style.dart';
import 'package:uttam_toys/utils/dimensions.dart';
import 'package:uttam_toys/utils/intentutils.dart';
import 'package:uttam_toys/widgets/page_indicator.dart';

import '../../utils/custom_color.dart';
import '../../utils/prefs.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  int _currentIndex = 0;
  final _pageController = PageController(initialPage: 0);
  late List<Widget> _pages = <Widget>[
    _buildIconView(
        title: 'Lorem ipsum dolor sit',
        subtitle: 'Lorem ipsum dolor sit amet consectetur. Nulla eleifend duis fames tellus. Erat augue dui condimentum fermentum turpis lacus. Dis commodo ac sed vitae est augue. Tortor lorem magna a congue risus vel vitae.',
        pngIcon: Assets.intro1),
    _buildIconView(
        title: 'Lorem ipsum dolor sit',
        subtitle: 'Lorem ipsum dolor sit amet consectetur. Nulla eleifend duis fames tellus. Erat augue dui condimentum fermentum turpis lacus. Dis commodo ac sed vitae est augue. Tortor lorem magna a congue risus vel vitae.',
        pngIcon: Assets.intro2),
    _buildIconView(
        title: 'Lorem ipsum dolor sit',
        subtitle: 'Lorem ipsum dolor sit amet consectetur. Nulla eleifend duis fames tellus. Erat augue dui condimentum fermentum turpis lacus. Dis commodo ac sed vitae est augue. Tortor lorem magna a congue risus vel vitae.',
        pngIcon: Assets.intro3),
  ];
  Timer? _timer;

  void setTimer(){
    setState(() {
      _timer = Timer.periodic(
        const Duration(seconds: 3),
            (Timer time) {
          if (_currentIndex < (_pages.length-1)) {
            _currentIndex = _currentIndex + 1;
          } else {
            _currentIndex = 0;
          }
          _pageController.animateToPage(
            _currentIndex,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    if(_timer!=null && _timer!.isActive)
      {
        _timer!.cancel();
      }

    _pageController.dispose();

  }

  @override
  void initState() {
    super.initState();
    setTimer();
    // getPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: Dimensions.widthSize,vertical: 0),
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index){
                  setState(() {
                    _currentIndex = index;
                  });
                },
                children: _pages,
              ),
            ),
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
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: (){
                      movToNextScreen();
                    },
                    child: Text(
                      'skip'.toUpperCase(),
                      textAlign: TextAlign.start,
                      style: CustomStyle.primarySemiBoldText.copyWith(
                        fontSize: Dimensions.defaultTextSize
                      ),
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: (){
                      if(_currentIndex == (_pages.length-1))
                        {
                          movToNextScreen();
                        }
                      else{
                        _pageController.jumpToPage(
                          _currentIndex + 1);
                      }
                    },
                    child: Text(
                      _currentIndex < (_pages.length-1) ? 'next'.toUpperCase() : 'get started'.toUpperCase(),
                      textAlign: TextAlign.start,
                      style: CustomStyle.primarySemiBoldText.copyWith(
                          fontSize: Dimensions.defaultTextSize
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildIconView({required String title,required String subtitle,required String pngIcon})
  {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.2)
          ),
          padding: EdgeInsets.all(Dimensions.defaultPaddingSize*0.8),
          child: Image.asset(
            pngIcon,
            height: MediaQuery.of(context).size.height*0.6,),
        ),
        Text(
          title,
          textAlign: TextAlign.center,
          style: CustomStyle.largeBlackStyle,),
        Text(subtitle,
          textAlign: TextAlign.center,
          style: CustomStyle.regularBlackLightText,),
      ],
    );
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _pages.length; i++) {
      list.add(PageIndicator(isActive: i == _currentIndex ? true : false));
    }
    return list;
  }

  Future<void> movToNextScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(Prefs.onBoardseen,  true);
    IntentUtils.fireIntent(context: context, screen: const LoginScreen(),finishAll: true);
  }

}
