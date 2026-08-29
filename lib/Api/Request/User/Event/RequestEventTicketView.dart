class RequestEventTicketView {
  String? userId;
  String? bookingId;

  RequestEventTicketView({this.userId, this.bookingId});

  RequestEventTicketView.fromJson(Map<String, dynamic> json) {
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
