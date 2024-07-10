import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uttam_toys_app/screens/auth/login_screen.dart';
import 'package:uttam_toys_app/screens/edit_profile_screen.dart';
import 'package:uttam_toys_app/screens/security_screen.dart';
import 'package:uttam_toys_app/utils/assets.dart';
import 'package:uttam_toys_app/utils/custom_color.dart';
import 'package:uttam_toys_app/utils/custom_style.dart';
import 'package:uttam_toys_app/widgets/appbar_common.dart';

import '../../helper/exit_dialog.dart';
import '../../utils/dimensions.dart';
import '../../utils/intentutils.dart';
import '../../utils/prefs.dart';
import '../../utils/size.dart';
import '../../widgets/primary_button.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.backgroundColor,
      appBar: const CommonAppbar(
        title: 'Profile',
        backEnable: false,
        hasBottom: true,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(
            vertical: Dimensions.heightSize,
          horizontal: 0
        ),
        children: [
          _profileView(),
          addVerticalSpace(Dimensions.heightSize),
          _divider(),
          _listItem(asset: Assets.accountSvg, title: 'Personal Information',
              onTap: (){
                IntentUtils.fireIntent(context: context, screen: EditProfileScreen(), finishAll: false);
              }),
          _divider(),
          _listItem(asset: Assets.securitySvg, title: 'Login & Security',
              onTap: (){
                IntentUtils.fireIntent(context: context, screen: SecurityScreen(), finishAll: false);
              }),
          _divider(),
          _listItem(asset: Assets.termsSvg, title: 'Terms of Services',
              onTap: (){
                // IntentUtils.fireIntent(context, ManageEmployeesScreen());
              }),
          _divider(),
          _listItem(asset: Assets.privacySvg, title: 'Privacy Policy',
              onTap: (){
                // IntentUtils.fireIntent(context, ManageEmployeesScreen());
              }),
          _divider(),
          _listItem(asset: Assets.feedbackSvg, title: 'Give us Feedback',
              onTap: (){
                // IntentUtils.fireIntent(context, ManageEmployeesScreen());
              }),
          _divider(),
          _deleteWidget(),
          _divider(),
          _listItem(asset: Assets.logoutSvg, title: 'Logout',
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => ExitDialog(
                    msg: "Are you sure you want to logout?",
                    exitText: 'Yes'.toUpperCase(),
                    onPressed: () async {
                      SharedPreferences prefs =
                      await SharedPreferences.getInstance();

                      prefs.setBool(Prefs.isLogin, false);
                      prefs.setString(Prefs.ID, "");
                      IntentUtils.fireIntent(context: context,screen: LoginScreen(),finishAll: true);
                    },
                    onCancel: () => Navigator.pop(context),),
                );
              }),
        ],
      ),
    );
  }

  _profileView() {
    return Column(
      children: [
        Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: CustomColor.primaryColor,width: 3)
          ),
          child: SvgPicture.asset(Assets.placeholderSvg,height: 90,width: 90,),
        ),
        addVerticalSpace(Dimensions.heightSize*0.5),
        Text('username'.toUpperCase(),style: CustomStyle.blackMediumTextStyle,),
      ],
    );
  }

  _divider()
  {
    return Divider(height: Dimensions.heightSize,thickness: 1,color: CustomColor.borderColor,);
  }

  _listItem({required String asset,required String title,required GestureTapCallback onTap})
  {
    return ListTile(
      onTap: onTap,
      tileColor: Colors.white,
      dense: true,
      title: Text(title,style: title.toLowerCase() == 'logout' ? CustomStyle.primarySemiBoldText
      : CustomStyle.blackMediumTextStyle,),
      // subtitle:  Text(subtitle,style: CustomStyle.regularTextstyle,),
      leading: SvgPicture.asset(asset,height: 25,width: 25,
      colorFilter: const ColorFilter.mode(CustomColor.primaryColor, BlendMode.srcATop),),
      trailing: Icon(
        Icons.keyboard_arrow_right,
        color: title.toLowerCase() == 'logout' ? CustomColor.primaryColor : Colors.black,
      ),
    );
  }

  _deleteWidget() {
    return ListTile(
      onTap: ()
      {
        showDialog(
          context: context,
          builder: (context) => DeleteDialog(),
        );
      },
      dense: true,
      tileColor: Colors.white,
      title: Text('Delete Account',style: CustomStyle.blackMediumTextStyle.copyWith(
        color: CustomColor.errorColor
      ),),
      // subtitle:  Text(subtitle,style: CustomStyle.regularTextstyle,),
      leading: SvgPicture.asset(Assets.deleteSvg,height: 25,width: 25,
        colorFilter: const ColorFilter.mode(CustomColor.errorColor, BlendMode.srcATop),),
      trailing: Icon(
        Icons.keyboard_arrow_right,
        color: CustomColor.errorColor,
      ),
    );
  }

  DeleteDialog() {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius*0.5)
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: Dimensions.heightSize,
            horizontal: Dimensions.widthSize
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Are you sure you want delete your account?',
              textAlign: TextAlign.center,
              style: CustomStyle.regularBlackText,
            ),
            Text(
              'Once delete, the action cant be undone.',
              textAlign: TextAlign.center,
              style: CustomStyle.blackSmallestTextStyle,
            ),
            addVerticalSpace(Dimensions.heightSize),
            Row(
              mainAxisAlignment: mainCenter,
              children: [
                PrimaryButtonWidget(
                  smallButton: true,
                  radius: Dimensions.radius*2,
                  width: 100,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  text: 'No, Cancel',
                ),
                PrimaryButtonWidget(
                  width: 100,
                  backgroundColor: CustomColor.errorColor,
                  textColor: CustomColor.whiteColor,
                  radius: Dimensions.radius*2,
                  smallButton: true,
                  onPressed: () {
                    //todo delete account
                  },
                  text: "Yes, Confirm",
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
