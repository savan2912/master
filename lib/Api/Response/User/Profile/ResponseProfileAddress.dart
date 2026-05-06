class ResponseProfileAddress {
  String? result;
  String? message;
  List<ProfileAddress>? data;

  ResponseProfileAddress({this.result, this.message, this.data});

  ResponseProfileAddress.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ProfileAddress>[];
      json['data'].forEach((v) {
        data!.add(new ProfileAddress.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProfileAddress {
  int? id;
  int? userId;
  String? address;
  String? latitude;
  String? longitude;
  String? pincode;
  String? createdAt;
  String? updatedAt;

  ProfileAddress(
      {this.id,
        this.userId,
        this.address,
        this.latitude,
        this.longitude,
        this.pincode,
        this.createdAt,
        this.updatedAt});

  ProfileAddress.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
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
