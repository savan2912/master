class ResponseEditAddress {
  String? result;
  String? message;
  EditAddress? data;

  ResponseEditAddress({this.result, this.message, this.data});

  ResponseEditAddress.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    data = json['data'] != null ? new EditAddress.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class EditAddress {
  int? id;
  int? userId;
  String? address;
  String? latitude;
  String? longitude;
  String? pincode;
  String? createdAt;
  String? updatedAt;

  EditAddress(
      {this.id,
        this.userId,
        this.address,
        this.latitude,
        this.longitude,
        this.pincode,
        this.createdAt,
        this.updatedAt});

  EditAddress.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'] is int ? json['user_id'] : int.tryParse(json['user_id'].toString());
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    pincode = json['pincode'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['pincode'] = this.pincode;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
