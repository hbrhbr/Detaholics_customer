import 'package:product/BlocClass/CommonBlocClass/BaseMode.dart';

class ResMealDeals extends BaseModel {
  int code;
  String message;
  List<Result> result;

  ResMealDeals({this.code, this.message, this.result});

  ResMealDeals.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['result'] != null) {
      result = [];
      json['result'].forEach((v) {
        result.add(new Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  String id;
  String name;
  String status;
  String restaurantName;
  String image;
  String price;
  String discount;
  String latitude;
  String longitude;
  String discountType;

  Result(
      {this.id,
      this.name,
      this.status,
      this.restaurantName,
      this.image,
      this.price,
      this.discount,
      this.latitude,
      this.longitude,
      this.discountType});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
    restaurantName = json['restaurant_name'];
    image = json['image'];
    price = json['price'];
    discount = json['discount'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    discountType = json['discount_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['status'] = this.status;
    data['restaurant_name'] = this.restaurantName;
    data['image'] = this.image;
    data['price'] = this.price;
    data['discount'] = this.discount;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['discount_type'] = this.discountType;
    return data;
  }
}
