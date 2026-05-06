class ResponseChangePassword {
  String? result;
  String? message;

  ResponseChangePassword({this.result, this.message});

  ResponseChangePassword.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['message'] = this.message;
    return data;
  }
}
