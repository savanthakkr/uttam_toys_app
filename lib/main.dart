import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uttam_toys/screens/splash_screen.dart';

import 'utils/custom_color.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    lockScreenPortrait();
    // lockStatusBarColor();
    return StreamBuilder(
      stream: Connectivity().onConnectivityChanged,
      builder: (context, snapshot) {
        return ScreenUtilInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          splitScreenMode: true,
          child: MaterialApp(
              locale: const Locale('en', 'US'),
              // translations: Language(),
              // fallbackLocale: const Locale('en', 'US'),
              theme: ThemeData(
                  primaryColor: CustomColor.primaryColor,
                  fontFamily: 'Lexend'
              ),
              home:const SplashScreen(),
              title: 'Uttam Toys',
              // getPages: appRoute.getPages,
              debugShowCheckedModeBanner: false),
          builder: (context, widget) {
            ScreenUtil.init(context);
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: widget!,
            );
          },
        );
      },
    );
  }


  lockScreenPortrait() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  void lockStatusBarColor() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      // statusBarColor: CustomColor.primaryLight,
      // systemNavigationBarColor: CustomColor.primaryColor.withOpacity(0.2),
      // systemNavigationBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark
    ));
  }
}

