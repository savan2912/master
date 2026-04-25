class RequestLogin {
  String? phone;
  String? password;
  String? role;
  String? deviceToken;

  RequestLogin({
    this.phone,
    this.password,
    this.role,
    this.deviceToken
  });

  RequestLogin.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
    password = json['password'];
    role = json['role'];
    deviceToken = json['device_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phone'] = this.phone;
    data['password'] = this.password;
    data['role'] = this.role;
    data['device_token'] = this.deviceToken;
    return data;
  }
}

