class ResponsePlaceOrder {
  String? result;
  String? tokenNumber;
  String? message;

  ResponsePlaceOrder({this.result, this.tokenNumber, this.message});

  ResponsePlaceOrder.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    tokenNumber = json['token_number'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['token_number'] = this.tokenNumber;
    data['message'] = this.message;
    return data;
  }
}
