class RequestChangePassword {
  String? userId;
  String? password;

  RequestChangePassword({this.userId, this.password});

  RequestChangePassword.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['password'] = this.password;
    return data;
  }
}
