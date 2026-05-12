class RequestSendOtp {
  String? phone;
  String? userType;

  RequestSendOtp({this.phone, this.userType});

  RequestSendOtp.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
    userType = json['user_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phone'] = this.phone;
    data['user_type'] = this.userType;
    return data;
  }
}
