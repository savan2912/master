class ResponseLogin {
  String? result;
  String? message;
  Data? data;

  ResponseLogin({this.result, this.message, this.data});

  ResponseLogin.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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

class Data {
  String? userId;
  String? role;

  Data({this.userId, this.role});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['role'] = this.role;
    return data;
  }
}
