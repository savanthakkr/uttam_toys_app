import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uttam_toys_app/screens/order_setting/buy_again_screen.dart';
import 'package:uttam_toys_app/utils/assets.dart';
import 'package:uttam_toys_app/utils/custom_color.dart';
import 'package:uttam_toys_app/utils/custom_style.dart';
import 'package:uttam_toys_app/utils/dimensions.dart';
import 'package:uttam_toys_app/utils/intentutils.dart';
import 'package:uttam_toys_app/utils/size.dart';
import 'package:uttam_toys_app/widgets/appbar_common.dart';

import '../../models/orders_model.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  List<OrdersModel> _orderList = <OrdersModel>[];
  
  @override
  void initState() {
    super.initState();
    getOrders();
  }
  
  void getOrders()
  {
   setState(() {
     _orderList.add(OrdersModel('Toy Train Engine', Assets.train, '03-06-2024', 'Arriving'));
     _orderList.add(OrdersModel('Colourful Shapes', Assets.shapes, '01-06-2024', 'Delivered'));
     _orderList.add(OrdersModel('Toy Train Engine', Assets.train, '25-05-2024', 'Delivered'));
     _orderList.add(OrdersModel('Toy Train Engine', Assets.train, '20-05-2024', 'Delivered'));

   }); 
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.backgroundColor,
      appBar: const CommonAppbar(
        title: 'Orders',
        hasBottom: true,
        backEnable: false,
      ),
      body: _orderList.isEmpty ? Center(
        child: Text(
          'No Orders Placed',
          style: CustomStyle.primarySemiBoldText,
        ),
      )
      : ListView.separated(
        itemCount: _orderList.length,
          padding: EdgeInsets.symmetric(
            vertical: Dimensions.heightSize,
            horizontal: 0
          ),
          itemBuilder: (context, index) {
            return _itemView(_orderList[index]);
          },
        separatorBuilder: (BuildContext context, int index) {
          return index < _orderList.length ? const Divider(
            color: CustomColor.borderColor,
            height: 0,
            thickness: 1,
          )
              : const SizedBox.shrink();
        },),
    );
  }

  _itemView(OrdersModel order)
  {
    return InkWell(
      onTap: () {
        IntentUtils.fireIntent(context: context, screen: BuyAgainScreen(), finishAll: false);
      },
      child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: Dimensions.heightSize,
            horizontal: Dimensions.widthSize
          ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
                order.image!,
            height: 70,width: 70,),
            addHorizontalSpace(Dimensions.widthSize),
            Expanded(
                child: Column(
                  crossAxisAlignment : CrossAxisAlignment.start,
                  children: [
                    Text(order.name ?? '',style: CustomStyle.regularBlackText,),
                    Text('${order.status} on ${order.date}',
                      style: CustomStyle.blackSmallestTextStyle,),
                  ],
                )
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: CustomColor.blackColor,
            )
          ],
        ),
      ),
    );
  }
}
