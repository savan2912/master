class ResponseCrackDeal {
  String? result;
  String? message;

  ResponseCrackDeal({this.result, this.message});

  ResponseCrackDeal.fromJson(Map<String, dynamic> json) {
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
