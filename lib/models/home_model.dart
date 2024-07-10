import 'dart:convert';

HomeModel homeModelFromJson(String str) => HomeModel.fromJson(json.decode(str));

String homeModelToJson(HomeModel data) => json.encode(data.toJson());

class HomeModel {
  bool error;
  String message;
  List<Category> category;
  List<Product> featuredProduct;
  List<Product> trendingProduct;
  List<Product> bestSellingProduct;

  HomeModel({
    required this.error,
    required this.message,
    required this.category,
    required this.featuredProduct,
    required this.trendingProduct,
    required this.bestSellingProduct,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) => HomeModel(
    error: json["error"],
    message: json["message"],
    category: json["Category"] != null ? List<Category>.from(json["Category"].map((x) => Category.fromJson(x))) : [],
    featuredProduct: json["FeaturedProduct"] != null ? List<Product>.from(json["FeaturedProduct"].map((x) => Product.fromJson(x))) : [],
    trendingProduct: json["TrendingProduct"] != null ? List<Product>.from(json["TrendingProduct"].map((x) => Product.fromJson(x))) : [],
    bestSellingProduct: json["BestSellingProduct"] != null ? List<Product>.from(json["BestSellingProduct"].map((x) => Product.fromJson(x))) : [],
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "Category": List<dynamic>.from(category.map((x) => x.toJson())),
    "FeaturedProduct": List<dynamic>.from(featuredProduct.map((x) => x.toJson())),
    "TrendingProduct": List<dynamic>.from(trendingProduct.map((x) => x.toJson())),
    "BestSellingProduct": List<dynamic>.from(bestSellingProduct.map((x) => x.toJson())),
  };
}

class Product {
  int id;
  String name;
  String categoryId;
  String subCategoryId;
  String brandId;
  String descriptionShort;
  String descriptionLong;
  String mainPrice;
  String discountPrice;
  String quantity;
  String sku;
  String taxValue;
  String tags;
  String age;
  int status;
  DateTime createdAt;
  DateTime updatedAt;
  List<String> images;
  bool? isWishlisted;

  Product({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.subCategoryId,
    required this.brandId,
    required this.descriptionShort,
    required this.descriptionLong,
    required this.mainPrice,
    required this.discountPrice,
    required this.quantity,
    required this.sku,
    required this.taxValue,
    required this.tags,
    required this.age,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.images,
    this.isWishlisted,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    name: json["name"],
    categoryId: json["category_id"],
    subCategoryId: json["sub_category_id"],
    brandId: json["brand_id"],
    descriptionShort: json["description_short"],
    descriptionLong: json["description_long"],
    mainPrice: json["main_price"],
    discountPrice: json["discount_price"],
    quantity: json["quantity"],
    sku: json["sku"],
    taxValue: json["tax_value"],
    tags: json["tags"],
    age: json["age"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    images: json["images"] != null ? List<String>.from(json["images"].map((x) => x)) :[],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "category_id": categoryId,
    "sub_category_id": subCategoryId,
    "brand_id": brandId,
    "description_short": descriptionShort,
    "description_long": descriptionLong,
    "main_price": mainPrice,
    "discount_price": discountPrice,
    "quantity": quantity,
    "sku": sku,
    "tax_value": taxValue,
    "tags": tags,
    "age": age,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "images": List<dynamic>.from(images.map((x) => x)),
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

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
