import 'package:product/BlocClass/CommonBlocClass/BaseMode.dart';

class ResAddOrder extends BaseModel {
  int code;
  String message;
  DataSccess result;

  ResAddOrder({this.code, this.message, this.result});

  ResAddOrder.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    result =
        json['result'] != null ? new DataSccess.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    return data;
  }
}

class DataSccess {
  int orderId;
  String data;

  DataSccess({this.orderId,this.data});

  DataSccess.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    data = json['data']??"";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['data'] = this.data??"";
    return data;
  }
}
