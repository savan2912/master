class RequestMyOrder {
  String? userId;
  String? counter;

  RequestMyOrder({this.userId, this.counter});

  RequestMyOrder.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    counter = json['counter'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['counter'] = this.counter;
    return data;
  }
}
