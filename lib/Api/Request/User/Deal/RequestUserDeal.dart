class RequestUserDeal {
  String? userId;
  String? counter;
  String? search;

  RequestUserDeal({this.userId, this.counter, this.search});

  RequestUserDeal.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    counter = json['counter'];
    search = json['search'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['counter'] = this.counter;
    data['search'] = this.search;
    return data;
  }
}
