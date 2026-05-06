class RequestHotelBookingDetail {
  String? bookingId;

  RequestHotelBookingDetail({this.bookingId});

  RequestHotelBookingDetail.fromJson(Map<String, dynamic> json) {
    bookingId = json['booking_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['booking_id'] = this.bookingId;
    return data;
  }
}
