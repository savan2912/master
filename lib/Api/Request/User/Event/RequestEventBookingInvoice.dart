class RequestEventBookingInvoice {
  String? userId;
  String? bookingId;

  RequestEventBookingInvoice({this.userId, this.bookingId});

  RequestEventBookingInvoice.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    bookingId = json['booking_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['booking_id'] = this.bookingId;
    return data;
  }
}
