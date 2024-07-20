import 'dart:convert';

AddressModel addressModelFromJson(String str) => AddressModel.fromJson(json.decode(str));

String addressModelToJson(AddressModel data) => json.encode(data.toJson());

class AddressModel {
  bool error;
  String message;
  List<AddressDetail> addressDetails;

  AddressModel({
    required this.error,
    required this.message,
    required this.addressDetails,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
    error: json["error"],
    message: json["message"],
    addressDetails: json["addressDetails"] != null ? List<AddressDetail>.from(json["addressDetails"].map((x) => AddressDetail.fromJson(x))) : [],
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "addressDetails": List<dynamic>.from(addressDetails.map((x) => x.toJson())),
  };
}

class AddressDetail {
  int id;
  String addressLine1;
  String addressLine2;
  String state;
  String city;
  String pincode;
  String landmark;
  String userId;
  String type;
  DateTime createdAt;
  DateTime updatedAt;

  AddressDetail({
    required this.id,
    required this.addressLine1,
    required this.addressLine2,
    required this.state,
    required this.city,
    required this.pincode,
    required this.landmark,
    required this.userId,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AddressDetail.fromJson(Map<String, dynamic> json) => AddressDetail(
    id: json["id"],
    addressLine1: json["address_line_1"],
    addressLine2: json["address_line_2"],
    state: json["state"],
    city: json["city"],
    pincode: json["pincode"],
    landmark: json["landmark"],
    userId: json["user_id"],
    type: json["type"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "address_line_1": addressLine1,
    "address_line_2": addressLine2,
    "state": state,
    "city": city,
    "pincode": pincode,
    "landmark": landmark,
    "user_id": userId,
    "type": type,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
