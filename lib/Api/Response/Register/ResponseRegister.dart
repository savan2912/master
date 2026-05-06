class ResponseRegister {
  String? result;
  String? message;
  RegisterData? data;

  ResponseRegister({this.result, this.message, this.data});

  ResponseRegister.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    data = json['data'] != null ? RegisterData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['result'] = result;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class RegisterData {
  String? userId;
  String? role;
  dynamic isPhoneVerified;

  RegisterData({this.userId, this.role, this.isPhoneVerified});

  RegisterData.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    role = json['role'];
    isPhoneVerified = json['is_phone_verified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['role'] = role;
    data['is_phone_verified'] = isPhoneVerified;
    return data;
  }
}
