// To parse this JSON data, do
//
//     final getCategory = getCategoryFromJson(jsonString);

import 'dart:convert';

GetCategory getCategoryFromJson(String str) => GetCategory.fromJson(json.decode(str));

String getCategoryToJson(GetCategory data) => json.encode(data.toJson());

class GetCategory {
  bool error;
  String message;
  List<Category> categories;

  GetCategory({
    required this.error,
    required this.message,
    required this.categories,
  });

  factory GetCategory.fromJson(Map<String, dynamic> json) => GetCategory(
    error: json["error"],
    message: json["message"],
    categories: List<Category>.from(json["categories"].map((x) => Category.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
  };
}

class Category {
  int id;
  String name;
  String image;
  int status;
  DateTime createdAt;
  DateTime updatedAt;

  Category({
    required this.id,
    required this.name,
    required this.image,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    name: json["name"],
    image: json["image"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
