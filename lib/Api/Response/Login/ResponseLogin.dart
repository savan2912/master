class ResponseLogin {
  String? result;
  String? message;
  Data? data;

  ResponseLogin({this.result, this.message, this.data});

  ResponseLogin.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
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

class Data {
  String? userId;
  String? role;
  int? isVerified;

  Data({this.userId, this.role,this.isVerified});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    role = json['role'];
    isVerified = json['is_phone_verified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['role'] = role;
    data['is_phone_verified'] = isVerified;
    return data;
  }
}
