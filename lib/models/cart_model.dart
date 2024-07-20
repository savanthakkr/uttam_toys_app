import 'dart:convert';

CartModel cartModelFromJson(String str) => CartModel.fromJson(json.decode(str));

String cartModelToJson(CartModel data) => json.encode(data.toJson());

class CartModel {
  bool error;
  String message;
  List<CartDetail> cartDetails;

  CartModel({
    required this.error,
    required this.message,
    required this.cartDetails,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
    error: json["error"],
    message: json["message"],
    cartDetails: json["CartDetails"] != null ? List<CartDetail>.from(json["CartDetails"].map((x) => CartDetail.fromJson(x))) : [],
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "CartDetails": List<dynamic>.from(cartDetails.map((x) => x.toJson())),
  };
}

class CartDetail {
  int id;
  String productId;
  String userId;
  String quantity;
  String status;
  dynamic orderId;
  DateTime createdAt;
  DateTime updatedAt;
  List<Product> products;

  CartDetail({
    required this.id,
    required this.productId,
    required this.userId,
    required this.quantity,
    required this.status,
    required this.orderId,
    required this.createdAt,
    required this.updatedAt,
    required this.products,
  });

  factory CartDetail.fromJson(Map<String, dynamic> json) => CartDetail(
    id: json["id"],
    productId: json["product_id"],
    userId: json["user_id"],
    quantity: json["quantity"],
    status: json["status"],
    orderId: json["order_id"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    products: List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "product_id": productId,
    "user_id": userId,
    "quantity": quantity,
    "status": status,
    "order_id": orderId,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "products": List<dynamic>.from(products.map((x) => x.toJson())),
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
    images: json["images"] != null ? List<String>.from(json["images"].map((x) => x)) : [],
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
