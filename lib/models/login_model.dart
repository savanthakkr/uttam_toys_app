import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  bool error;
  String message;
  String token;
  int userId;

  LoginModel({
    required this.error,
    required this.message,
    required this.token,
    required this.userId,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    error: json["error"],
    message: json["message"],
    token: json["token"] != null ? json["token"] : "",
    userId: json["userId"] != null ? json["userId"] : 0,
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "token": token,
    "userId": userId,
  };
}
