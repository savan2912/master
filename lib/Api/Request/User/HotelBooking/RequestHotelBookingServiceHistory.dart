class RequestHotelBookingServiceHistory {
  String? userBookingId;
  String? search;
  String? counter;

  RequestHotelBookingServiceHistory(
      {this.userBookingId, this.search, this.counter});

  RequestHotelBookingServiceHistory.fromJson(Map<String, dynamic> json) {
    userBookingId = json['user_booking_id'];
    search = json['search'];
    counter = json['counter'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_booking_id'] = this.userBookingId;
    data['search'] = this.search;
    data['counter'] = this.counter;
    return data;
  }
}
