import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:uttam_toys_app/models/cart_model.dart';
import 'package:uttam_toys_app/utils/custom_style.dart';
import 'package:uttam_toys_app/utils/size.dart';
import 'package:uttam_toys_app/widgets/primary_button.dart';

import '../../utils/assets.dart';
import '../../utils/custom_color.dart';
import '../../utils/dimensions.dart';
import '../../widgets/appbar_common.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CartModel> _cartList = <CartModel>[];
  double subTotal=0;

  @override
  void initState() {
    super.initState();
    getCart();
  }

  void getCart()
  {
    setState(() {
      _cartList.add(CartModel('Toy Train Engine', Assets.train, '499','599', '4.5',true,'100','Blue & Yellow'));
      _cartList.add(CartModel('Toy Train Engine', Assets.train, '499','599', '4.5',true,'100','Blue & Yellow'));
      _cartList.add(CartModel('Toy Train Engine', Assets.train, '499','599', '4.5',true,'100','Blue & Yellow'));
    });
    setTotal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.backgroundColor,
      appBar: const CommonAppbar(
        title: 'Cart',
        hasBottom: true,
        backEnable: false,
      ),
      body: _cartList.isEmpty ? Center(
        child: Text(
          'Your cart is empty',
          style: CustomStyle.primarySemiBoldText,
        ),
      )
          : Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: _bottomView(),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _cartList.length,
                  padding: EdgeInsets.symmetric(
                      vertical: Dimensions.heightSize,
                      horizontal: Dimensions.widthSize
                  ),
                  itemBuilder: (context, index) {
                    return _itemView(_cartList[index]);
                  },
                        ),
              ),
            ],
          ),
    );
  }

  Widget _itemView(CartModel cart) {
    return Card(
      elevation: 0,
      color: CustomColor.cardColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius),
          side: const BorderSide(color: CustomColor.borderColor,width: 1,style: BorderStyle.solid)
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: Dimensions.heightSize,
          horizontal: Dimensions.widthSize
        ),
        child: Row(
          crossAxisAlignment: crossStart,
          children: [
            Column(
              children: [
                Image.asset(cart.image!,height: 100,width: 100,fit: BoxFit.contain,),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(Dimensions.radius*0.5),
                    border: Border.all(color: CustomColor.borderColor,width: 1)
                  ),
                  child: IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: mainEnd,
                      children: [
                        InkWell(
                          onTap: () {
                            // if(cartQuantity != 1)
                            // {
                            //   setState(() {
                            //     cartQuantity = cartQuantity - 1;
                            //   });
                            //   updateProductCart(quantity: '$cartQuantity',toBuy: false);
                            // }
                            // else{
                            //   //todo removeProduct(cartId: item.id!);
                            // }

                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: const Icon(Icons.remove,color: CustomColor.blackColor,),
                          ),
                        ),
                        VerticalDivider(
                          color: CustomColor.borderColor,
                          thickness: 1,
                          width: 0,
                        ),
                        addHorizontalSpace(Dimensions.widthSize),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text('1',style: CustomStyle.regularBlackText,),
                        ),
                        addHorizontalSpace(Dimensions.widthSize),
                        VerticalDivider(
                          color: CustomColor.borderColor,
                          thickness: 1,
                          width: 0,
                        ),
                        InkWell(
                          onTap: () {
                            // setState(() {
                            //   cartQuantity = cartQuantity + 1;
                            // });
                            // updateProductCart(quantity: '$cartQuantity',toBuy: false);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: const Icon(Icons.add,color: CustomColor.blackColor,),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            addHorizontalSpace(Dimensions.widthSize),
            Expanded(
                child: Column(
                  crossAxisAlignment: crossStart,
                  children: [
                    Text(cart.name!.toUpperCase(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                      style: CustomStyle.regularBlackText,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: mainMin,
                      children: [
                        Text('\u20b9 ${cart.price}',
                          style: CustomStyle.smallHeadingTextStyle,
                          textAlign: TextAlign.start,),
                        addHorizontalSpace(Dimensions.widthSize*0.5),
                        Text('\u20b9 ${cart.oldPrice}',
                          style: CustomStyle.cancelledTextStyle,
                          textAlign: TextAlign.start,),
                      ],
                    ),
                    Row(
                      mainAxisSize: mainMin,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline_rounded,color: CustomColor.borderColor,size: Dimensions.iconSizeSmall,),
                        addHorizontalSpace(Dimensions.widthSize*0.2),
                        Text('Price dropped by \u20b9${cart.priceDrop}',
                          style: CustomStyle.blackSmallestTextStyle,
                          textAlign: TextAlign.start,),
                      ],
                    ),
                    cart.inStock! ? Text('IN STOCK',
                      style: CustomStyle.blackSmallestTextStyle,
                      textAlign: TextAlign.start,)
                    : Text('OUT OF STOCK',
                      style: CustomStyle.errorTextStyle,
                      textAlign: TextAlign.start,),
                    Text.rich(
                        TextSpan(
                          text: 'colour: '.toUpperCase(),
                          style: CustomStyle.smallHeadingTextStyle,
                          children: [
                            TextSpan(
                              text: cart.color ?? '',
                              style: CustomStyle.blackSmallestTextStyle
                            )
                          ]
                        )
                    ),
                    Row(
                      mainAxisSize: mainMin,
                      mainAxisAlignment: mainSpaceBet,
                      children: [
                        SvgPicture.asset(Assets.starSvg,height: 12,width: 12,),
                        addHorizontalSpace(Dimensions.widthSize*0.2),
                        Text(cart.rating ?? '',
                          style: CustomStyle.smallHeadingTextStyle,
                          textAlign: TextAlign.end,),
                      ],
                    )
                  ],
                )
            ),
            Align(
              alignment: Alignment.topCenter,
              child: InkWell(
                onTap: () {
                  //todo remove from cart
                },
                child: SvgPicture.asset(Assets.deleteSvg,
                colorFilter: const ColorFilter.mode(CustomColor.blackColor, BlendMode.srcATop),),
              ),
            )
          ],
        ),
      ),
    );
  }

  _bottomView() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: Dimensions.heightSize,
        horizontal: Dimensions.widthSize
      ),
      child: Column(
        crossAxisAlignment: crossStart,
        children: [
          Text.rich(
            textAlign: TextAlign.start,
              TextSpan(
                  text: 'SubTotal: ',
                  style: CustomStyle.regularBlackLightText,
                  children: [
                    TextSpan(
                        text: '\u20b9 $subTotal',
                        style: CustomStyle.regularBlackText
                    )
                  ]
              )
          ),
          Row(
            mainAxisAlignment: mainSpaceBet,
            children: [
              Column(
                crossAxisAlignment: crossStart,
                children: [
                  Text('Deliver To: ',style: CustomStyle.regularBlackText,),
                  Text('Lorem ipsum dolor sit amet\n123456',style: CustomStyle.regularBlackLightText,),
                ],
              ),
              PrimaryButtonWidget(
                text: 'Change',
                elevation: 0,
                borderColor: CustomColor.primaryColor,
                onPressed: () {
                //todo add address
                },
                backgroundColor: Colors.white,
                smallButton: true,
                width: 120,
                textColor: CustomColor.primaryColor,
                radius: Dimensions.radius,
              )
            ],
          ),
          PrimaryButtonWidget(
            text: 'Proceed to buy (${_cartList.length} items)',
            onPressed: () {
              //todo add address
            },
            radius: Dimensions.radius,
          )
        ],
      ),
    );
  }

  setTotal() {
    setState(() {
      subTotal = 0;
      for(int i=0; i<_cartList.length; i++)
        {
          double price = double.parse(_cartList[i].price ?? '0');
          subTotal = subTotal + price;
        }
    });
  }
}
