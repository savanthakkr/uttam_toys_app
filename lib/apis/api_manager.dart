import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uttam_toys_app/models/get_all_category_model.dart';
import 'package:uttam_toys_app/models/home_model.dart';
import 'package:uttam_toys_app/models/login_model.dart';
import 'package:uttam_toys_app/models/ragister_model.dart';
import 'package:uttam_toys_app/models/sub_category_model.dart';

class ApiManager {

  // static String baseUrl = "http://3.110.124.116:3300/api/";

  // static String baseUrl = "http://3.110.185.95:3333/api/";
  // static String baseUrl = "https://sbo.onrender.com/api/";
  static String baseUrl = "http://192.168.1.4:5000/uttam/";


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

  static Future<HomeModel> FetchHomeData() async
  {
    final response = await http.get(Uri.parse("${baseUrl}users/getHomeData"));

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

}