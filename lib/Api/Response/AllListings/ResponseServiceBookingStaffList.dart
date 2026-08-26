class ResponseServiceBookingStaffList {
  String? result;
  String? message;
  List<ServiceBookingStaffList>? data;
  bool? isStaff;

  ResponseServiceBookingStaffList(
      {this.result, this.message, this.data, this.isStaff});

  ResponseServiceBookingStaffList.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ServiceBookingStaffList>[];
      json['data'].forEach((v) {
        data!.add(new ServiceBookingStaffList.fromJson(v));
      });
    }
    isStaff = json['is_staff'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['is_staff'] = this.isStaff;
    return data;
  }
}

class ServiceBookingStaffList {
  int? id;
  int? vendorId;
  int? listingId;
  String? name;
  String? email;
  String? phone;
  String? password;
  String? passwordStr;
  int? status;
  dynamic authToken;
  String? createdAt;
  String? updatedAt;

  ServiceBookingStaffList(
      {this.id,
        this.vendorId,
        this.listingId,
        this.name,
        this.email,
        this.phone,
        this.password,
        this.passwordStr,
        this.status,
        this.authToken,
        this.createdAt,
        this.updatedAt});

  ServiceBookingStaffList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vendorId = json['vendor_id'];
    listingId = json['listing_id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    password = json['password'];
    passwordStr = json['password_str'];
    status = json['status'];
    authToken = json['auth_token'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['vendor_id'] = this.vendorId;
    data['listing_id'] = this.listingId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['password'] = this.password;
    data['password_str'] = this.passwordStr;
    data['status'] = this.status;
    data['auth_token'] = this.authToken;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
