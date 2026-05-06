class RequestHotelBookingCancellationHistory {
  String? userId;
  String? search;
  String? counter;

  RequestHotelBookingCancellationHistory(
      {this.userId, this.search, this.counter});

  RequestHotelBookingCancellationHistory.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    search = json['search'];
    counter = json['counter'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['search'] = this.search;
    data['counter'] = this.counter;
    return data;
  }
}
