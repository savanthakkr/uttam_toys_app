import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uttam_toys/screens/auth/login_screen.dart';
import 'package:uttam_toys/screens/bottom/user_bottom_bar.dart';
import 'package:uttam_toys/screens/walkthrough/intro_screen.dart';
import 'package:uttam_toys/utils/intentutils.dart';
import 'package:uttam_toys/utils/prefs.dart';

import '../utils/assets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isLoggedIn=false,_isOnboardingSeen=false;

  @override
  void initState() {
    super.initState();
    getPrefs();
    Timer(const Duration(seconds: 2),() => navigateUser());
  }

  getPrefs() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool(Prefs.isLogin) ?? false;
    bool isIntroSeen = prefs.getBool(Prefs.onBoardseen) ?? false;

    setState(() {
      _isLoggedIn = isLoggedIn;
      _isOnboardingSeen = isIntroSeen;
    });
  }

  navigateUser() async {
    //check if user is logged in
    if(_isLoggedIn && _isOnboardingSeen)
    {
      //todo go to home
      IntentUtils.fireIntent(context: context, screen: const UserBottomBar(), finishAll: true);
    }
    else if(!_isLoggedIn && _isOnboardingSeen)
    {
      IntentUtils.fireIntent(context: context, screen: const LoginScreen(), finishAll: true);
    }
    else {
      //go to onboarding
      IntentUtils.fireIntent(context: context, screen: const IntroScreen(), finishAll: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: _bodyWidget(context),
      ),
    );
  }

  _bodyWidget(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Image.asset(
        Assets.appLogo,
        height: MediaQuery.of(context).size.height * 0.3,
        width: MediaQuery.of(context).size.width * 0.5,
      ),
    );
  }
}

