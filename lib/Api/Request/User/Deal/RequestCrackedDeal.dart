class RequestCrackedDeal {
  String? userId;
  int? counter;

  RequestCrackedDeal({this.userId, this.counter});

  RequestCrackedDeal.fromJson(Map<String, dynamic> json) {
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
