import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uttam_toys/apis/api_manager.dart';
import 'package:uttam_toys/models/address_model.dart';
import 'package:uttam_toys/models/cart_model.dart';
import 'package:uttam_toys/models/ragister_model.dart';
import 'package:uttam_toys/screens/bottom/user_bottom_bar.dart';
import 'package:uttam_toys/screens/select_address_Screen.dart';
import 'package:uttam_toys/utils/connection_utils.dart';
import 'package:uttam_toys/utils/custom_style.dart';
import 'package:uttam_toys/utils/intentutils.dart';
import 'package:uttam_toys/utils/prefs.dart';
import 'package:uttam_toys/utils/size.dart';
import 'package:uttam_toys/utils/ui_utils.dart';
import 'package:uttam_toys/widgets/primary_button.dart';

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
  double subTotal=0;
  String? userId;
  List<CartDetail> _cartList = <CartDetail>[];
  bool _isLoading = false;
  String? addressId,landmark,state,city,pincode;
  String? selectedAddress;
  String? lastSelectedAddress;

  @override
  void initState() {
    super.initState();
    getPrefs();
  }

  getPrefs() async {
    SharedPreferences mPrefs = await SharedPreferences.getInstance();
    String? uId = mPrefs.getString(Prefs.ID);
    String? lastSelected = await getLastSelectedAddress();
    setState(() {
      userId = uId;
      lastSelectedAddress = lastSelected;
    });
    getCart();
    FetchAddress(lastSelectedAddress!);
  }

  Future<String?> getLastSelectedAddress() async {
    SharedPreferences mPrefs = await SharedPreferences.getInstance();
    return mPrefs.getString('lastSelectedAddress');
  }

  void getCart() {
    ConnectionUtils.checkConnection().then((intenet) async {
      if (intenet) {
        setState(() {
          _isLoading = true;
          _cartList.clear();
        });
        try{
          final CartModel resultModel = await ApiManager.FetchCart(userId!);

          if(resultModel.error == false) {
            setState(() {
              _isLoading = false;
              _cartList = resultModel.cartDetails;
            });
            setTotal();
          } else{
            setState(() {
              _isLoading = false;
            });
            UIUtils.bottomToast(context: context, text: resultModel.message, isError: true);
          }
        }
        on Exception catch(_,e){
          setState(() {
            _isLoading = false;
          });
          print(e.toString());
          UIUtils.bottomToast(context: context, text: e.toString(), isError: true);
        }
      }
      else {
        // No-Internet Case
        UIUtils.bottomToast(context: context, text: "Please check your internet connection", isError: true);
      }
    });
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
      body: _isLoading ? Center(child: CircularProgressIndicator(color: CustomColor.primaryColor,)) : _cartList.isEmpty ? Center(
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

  Widget _itemView(CartDetail cart) {

    dynamic bytes;
    if(cart.products.first.images.isNotEmpty) {
      bytes = base64.decode(cart.products.first.images.first);
    } else {
      bytes = null;
    }

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
                bytes == null ? Image.asset(Assets.train,height: 100,width: 100,fit: BoxFit.contain,) :
                Image.memory(bytes,height: 100,width: 100,),
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
                            int cartQuantity = int.parse(cart.quantity);
                            if(cartQuantity != 1)
                            {
                              setState(() {
                                cartQuantity = cartQuantity - 1;
                              });
                              UpdateCart(cart.id.toString(), cartQuantity.toString());
                            }
                            else{
                              DeleteCart(cart.id.toString());
                            }

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
                          child: Text(cart.quantity,style: CustomStyle.regularBlackText,),
                        ),
                        addHorizontalSpace(Dimensions.widthSize),
                        VerticalDivider(
                          color: CustomColor.borderColor,
                          thickness: 1,
                          width: 0,
                        ),
                        InkWell(
                          onTap: () {
                            int cartQuantity = int.parse(cart.quantity);
                            setState(() {
                              cartQuantity = cartQuantity + 1;
                            });
                            UpdateCart(cart.id.toString(), cartQuantity.toString());
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
                    Text(cart.products.first.name.toUpperCase(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                      style: CustomStyle.regularBlackText,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: mainMin,
                      children: [
                        Text('\u20b9 ${cart.products.first.discountPrice}',
                          style: CustomStyle.smallHeadingTextStyle,
                          textAlign: TextAlign.start,),
                        addHorizontalSpace(Dimensions.widthSize*0.5),
                        Text('\u20b9 ${cart.products.first.mainPrice}',
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
                        Text('Price dropped by \u20b9${double.parse(cart.products.first.mainPrice) - double.parse(cart.products.first.discountPrice)}',
                          style: CustomStyle.blackSmallestTextStyle,
                          textAlign: TextAlign.start,),
                      ],
                    ),
                    cart.products.first.quantity != "0" ? Text('IN STOCK',
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
                                  text: 'Multicolor',
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
                        Text('4.5',
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
                  DeleteCart(cart.id.toString());
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
                  Text('$landmark,$state,$city\n$pincode',style: CustomStyle.regularBlackLightText,),
                ],
              ),
              PrimaryButtonWidget(
                text: 'Change',
                elevation: 0,
                borderColor: CustomColor.primaryColor,
                onPressed: () async {
                  final result = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SelectAddressScreen(),
                    ),
                  );
                  if (result != null && result is String) {
                    // Handle the selected address type here
                    setState(() {
                      selectedAddress = result;
                    });
                    saveLastSelectedAddress(selectedAddress!);
                    // Print the selected address
                    print('Selected Address: $selectedAddress');
                  }
                  FetchAddress(selectedAddress!);
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
              if(addressId != null || addressId != ""){
                CreateOrder();
              } else {
                UIUtils.bottomToast(context: context, text: "Select your address", isError: true);
              }
            },
            radius: Dimensions.radius,
          )
        ],
      ),
    );
  }

  void UpdateCart(String cid,String qunt) {
    ConnectionUtils.checkConnection().then((intenet) async {
      if (intenet) {
        setState(() {
          _isLoading = true;
        });
        try{
          final RegisterModel resultModel = await ApiManager.UpdateCart(cid,qunt);

          if(resultModel.error == false) {
            setState(() {
              _isLoading = false;
            });

            UIUtils.bottomToast(context: context, text: resultModel.message, isError: false);
            getCart();
          } else{
            setState(() {
              _isLoading = false;
            });
            UIUtils.bottomToast(context: context, text: resultModel.message, isError: true);
          }
        }
        on Exception catch(_,e){
          setState(() {
            _isLoading = false;
          });
          print(e.toString());
          UIUtils.bottomToast(context: context, text: e.toString(), isError: true);
        }
      }
      else {
        // No-Internet Case
        UIUtils.bottomToast(context: context, text: "Please check your internet connection", isError: true);
      }
    });
  }

  void DeleteCart(String cid) {
    ConnectionUtils.checkConnection().then((intenet) async {
      if (intenet) {
        setState(() {
          _isLoading = true;
        });
        try{
          final RegisterModel resultModel = await ApiManager.DeleteCart(cid);

          if(resultModel.error == false) {
            setState(() {
              _isLoading = false;
            });

            UIUtils.bottomToast(context: context, text: resultModel.message, isError: false);
            getCart();
          } else{
            setState(() {
              _isLoading = false;
            });
            UIUtils.bottomToast(context: context, text: resultModel.message, isError: true);
          }
        }
        on Exception catch(_,e){
          setState(() {
            _isLoading = false;
          });
          print(e.toString());
          UIUtils.bottomToast(context: context, text: e.toString(), isError: true);
        }
      }
      else {
        // No-Internet Case
        UIUtils.bottomToast(context: context, text: "Please check your internet connection", isError: true);
      }
    });
  }

  void FetchAddress(String type) {
    ConnectionUtils.checkConnection().then((intenet) async {
      if (intenet) {
        setState(() {
          _isLoading = true;
        });
        try{
          final AddressModel resultModel = await ApiManager.FetchAddress(userId!,type);

          if(resultModel.error == false) {
            setState(() {
              _isLoading = false;
              if(resultModel.addressDetails.isNotEmpty) {
                landmark = resultModel.addressDetails.first.landmark;
                state = resultModel.addressDetails.first.state;
                city = resultModel.addressDetails.first.city;
                pincode = resultModel.addressDetails.first.pincode;
                addressId = resultModel.addressDetails.first.id.toString();
              }
            });
          } else{
            setState(() {
              _isLoading = false;
            });
            UIUtils.bottomToast(context: context, text: resultModel.message, isError: true);
          }
        }
        on Exception catch(_,e){
          setState(() {
            _isLoading = false;
          });
          print(e.toString());
          UIUtils.bottomToast(context: context, text: e.toString(), isError: true);
        }
      }
      else {
        // No-Internet Case
        UIUtils.bottomToast(context: context, text: "Please check your internet connection", isError: true);
      }
    });
  }

  void CreateOrder() {
    ConnectionUtils.checkConnection().then((intenet) async {
      if (intenet) {
        setState(() {
          _isLoading = true;
        });
        try{

          String transactionId = "UTTAM${DateTime.now().millisecondsSinceEpoch}";

          final RegisterModel resultModel = await ApiManager.CreateOrder(userId!,addressId!,"Cash",transactionId,subTotal.toString());

          if(resultModel.error == false) {
            setState(() {
              _isLoading = false;
            });
            UIUtils.bottomToast(context: context, text: resultModel.message, isError: false);
            IntentUtils.fireIntentwithAnimations(context, UserBottomBar(), false);
          } else{
            setState(() {
              _isLoading = false;
            });
            UIUtils.bottomToast(context: context, text: resultModel.message, isError: true);
          }
        }
        on Exception catch(_,e){
          setState(() {
            _isLoading = false;
          });
          print(e.toString());
          UIUtils.bottomToast(context: context, text: e.toString(), isError: true);
        }
      }
      else {
        // No-Internet Case
        UIUtils.bottomToast(context: context, text: "Please check your internet connection", isError: true);
      }
    });
  }

  setTotal() {
    setState(() {
      subTotal = 0;
      for(int i=0; i<_cartList.length; i++)
      {
        double price = double.parse(_cartList[i].products.first.discountPrice ?? '0') * int.parse(_cartList[i].quantity);
        subTotal = subTotal + price;
      }
    });
  }

  void saveLastSelectedAddress(String addressType) async {
    SharedPreferences mPrefs = await SharedPreferences.getInstance();
    await mPrefs.setString('lastSelectedAddress', addressType);
  }
}
