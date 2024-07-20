import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uttam_toys/models/address_model.dart';
import 'package:uttam_toys/models/all_product_model.dart';
import 'package:uttam_toys/models/cart_model.dart';
import 'package:uttam_toys/models/get_all_category_model.dart';
import 'package:uttam_toys/models/home_model.dart';
import 'package:uttam_toys/models/login_model.dart';
import 'package:uttam_toys/models/product_details_model.dart';
import 'package:uttam_toys/models/ragister_model.dart';
import 'package:uttam_toys/models/result_model.dart';
import 'package:uttam_toys/models/sub_category_model.dart';

class ApiManager {

  // static String baseUrl = "http://3.110.124.116:3300/api/";

  // static String baseUrl = "http://3.110.185.95:3333/api/";
  // static String baseUrl = "https://sbo.onrender.com/api/";
  static String baseUrl = "http://192.168.0.229:5000/uttam/";


  static Future<RegisterModel> CreateUser(String name,String byear,String yearTo, String mobile) async {

    final response = await http.post(Uri.parse("${baseUrl}users/register"),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          "name" : name,
          "email" : byear,
          "phone_number": yearTo,
          "password" : mobile,
        }));

    return registerModelFromJson(response.body);
  }

  static Future<LoginModel> LoginUser(String username,String password) async {

    final response = await http.post(Uri.parse("${baseUrl}users/userlogin"),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          "phone_number" : username,
          "password" : password,
        }));

    return loginModelFromJson(response.body);
  }

  static Future<LoginModel> MobileLoginUser(String username) async {

    final response = await http.post(Uri.parse("${baseUrl}users/login"),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          "phone_number" : username
        }));

    return loginModelFromJson(response.body);
  }

  static Future<HomeModel> FetchHomeData(String userId) async {

    final response = await http.post(Uri.parse("${baseUrl}users/getHomeData"),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          "userId" : userId
        }));

    return homeModelFromJson(response.body);
  }

  static Future<GetCategory> FetchCategoryApi() async
  {
    final response = await http.get(Uri.parse("${baseUrl}users/getAllCategories"));

    return getCategoryFromJson(response.body);
  }


  static Future<SubCategoryModel> FetchSubCategory( String title) async
  {

    final response = await http.post(Uri.parse("${baseUrl}users/getSubCategories"),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'title': title
        }));

    return subCategoryModelFromJson(response.body);
  }

  static Future<AllProductModel> FetchSubCategoryByProduct(String title) async
  {

    final response = await http.post(Uri.parse("${baseUrl}users/getProductBySubCategory"),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'subCategory': title
        }));

    return allProductModelFromJson(response.body);
  }

  static Future<ProductDetailsModel> FetchProductDetails(String pId) async
  {

    final response = await http.post(Uri.parse("${baseUrl}users/getProductDetails"),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'productId': pId
        }));

    return productDetailsModelFromJson(response.body);
  }

  static Future<RegisterModel> AddtoCart(String pId,String uId,String qunt) async
  {

    final response = await http.post(Uri.parse("${baseUrl}users/addProductCart"),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'product_id': pId,
          'user_id': uId,
          'quantity': qunt
        }));

    return registerModelFromJson(response.body);
  }

  static Future<RegisterModel> UpdateCart(String cId,String qunt) async {

    final response = await http.post(Uri.parse("${baseUrl}users/updateProductCart"),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'cart_id': cId,
          'quantity': qunt
        }));

    return registerModelFromJson(response.body);
  }


  static Future<ResultModel> saveProducts(String userId,int id) async
  {

    final response = await http.post(Uri.parse("${baseUrl}users/saveProduct"),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          "userId": userId,
          'productId': id
        }));

    return resultModelFromJson(response.body);
  }
  static Future<CartModel> FetchCart(String uId) async {
    final response = await http.post(Uri.parse("${baseUrl}users/fetchCartItems"),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'user_id': uId
        }));
    return cartModelFromJson(response.body);
  }
  static Future<RegisterModel> DeleteCart(String cId) async {
    final response = await http.post(Uri.parse("${baseUrl}users/deleteProductCart"),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'cartId': cId
        }));
    return registerModelFromJson(response.body);
  }
  static Future<RegisterModel> CreateAddress(String address_line_1,String address_line_2,String state,String city,String pincode,String landmark,String user_id,String type) async {
    final response = await http.post(Uri.parse("${baseUrl}users/addUserAddress"),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'address_line_1': address_line_1,
          'address_line_2': address_line_2,
          'state': state,
          'city': city,
          'pincode': pincode,
          'landmark': landmark,
          'user_id': user_id,
          'type': type
        }));
    return registerModelFromJson(response.body);
  }
  static Future<AddressModel> FetchAddress(String userId,String type) async {
    final response = await http.post(Uri.parse("${baseUrl}users/fetchUserAddress"),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'userId': userId,
          'type': type
        }));
    return addressModelFromJson(response.body);
  }
  static Future<AddressModel> FetchAllAddress(String userId) async {
    final response = await http.post(Uri.parse("${baseUrl}users/fetchUserAllAddress"),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'userId': userId,
        }));
    return addressModelFromJson(response.body);
  }

  static Future<RegisterModel> CreateOrder(String userId, String addressId,String paymentType,String transactionId,String amount) async {
    final response = await http.post(Uri.parse("${baseUrl}users/createOrder"),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'userId': userId,
          'addressId': addressId,
          'paymentType': paymentType,
          'transactionId': transactionId,
          'amount': amount
        }));
    return registerModelFromJson(response.body);
  }

}