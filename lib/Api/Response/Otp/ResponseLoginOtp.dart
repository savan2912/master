class ResponseLoginOtp {
  String? result;
  String? message;
  LoginOtp? data;

  ResponseLoginOtp({this.result, this.message, this.data});

  ResponseLoginOtp.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    data = json['data'] != null ? new LoginOtp.fromJson(json['data']) : null;
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

class LoginOtp {
  String? userId;
  String? token;
  int? isPhoneVerified;

  LoginOtp({this.userId, this.token, this.isPhoneVerified});

  LoginOtp.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    token = json['token'];
    isPhoneVerified = json['is_phone_verified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['token'] = this.token;
    data['is_phone_verified'] = this.isPhoneVerified;
    return data;
  }
}
