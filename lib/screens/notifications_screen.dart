import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uttam_toys/utils/custom_color.dart';
import 'package:uttam_toys/utils/custom_style.dart';
import 'package:uttam_toys/widgets/appbar_common.dart';

import '../utils/dimensions.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {

  void _onBackPressed() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
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
            title: 'Notification Center',
            hasBottom: true,
            leadingOnTap: _onBackPressed,
          ),
          body: ListView.separated(
            padding: EdgeInsets.symmetric(
                vertical: Dimensions.heightSize,
                horizontal: Dimensions.widthSize
            ),
            itemCount: 10,
            itemBuilder: (context, index) {
              return _buildNotificationItem();
            },
            separatorBuilder: (context, index) {
              return Divider(
                thickness: 1,
                color: CustomColor.borderColor,
                height: Dimensions.heightSize,
              );
            },
          ),
        )
    );
  }

  _buildNotificationItem()
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Lorem ipsum',style: CustomStyle.regularBlackText,),
        Text('Lorem ipsum dolor sit amet consectetur. Amet parturient eleifend cursus hac mus consequat venenatis.',
          style: CustomStyle.blackSmallestTextStyle,)
      ],
    );
  }
}
