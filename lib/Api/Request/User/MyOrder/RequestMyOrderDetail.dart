class RequestMyOrderDetail {
  String? tokenNumber;

  RequestMyOrderDetail({this.tokenNumber});

  RequestMyOrderDetail.fromJson(Map<String, dynamic> json) {
    tokenNumber = json['token_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token_number'] = this.tokenNumber;
    return data;
  }
}
