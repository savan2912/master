class ResponseLogout {
  String? result;
  String? message;

  ResponseLogout({this.result, this.message});

  ResponseLogout.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['result'] = result;
    data['message'] = message;
    return data;
  }
}
