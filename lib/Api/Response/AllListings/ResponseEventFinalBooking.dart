class ResponseEventFinalBooking {
  String? result;
  String? message;
  Data? data;

  ResponseEventFinalBooking({this.result, this.message, this.data});

  ResponseEventFinalBooking.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? bookingId;
  String? eventBookingNumber;
  String? eventId;
  String? listingId;
  int? subtotal;
  int? totalAmount;
  int? paymentStatus;
  String? paymentMethod;
  String? transactionId;
  String? listingUrl;

  Data(
      {this.bookingId,
        this.eventBookingNumber,
        this.eventId,
        this.listingId,
        this.subtotal,
        this.totalAmount,
        this.paymentStatus,
        this.paymentMethod,
        this.transactionId,
        this.listingUrl});

  Data.fromJson(Map<String, dynamic> json) {
    bookingId = json['booking_id'];
    eventBookingNumber = json['event_booking_number'];
    eventId = json['event_id'];
    listingId = json['listing_id'];
    subtotal = json['subtotal'];
    totalAmount = json['total_amount'];
    paymentStatus = json['payment_status'];
    paymentMethod = json['payment_method'];
    transactionId = json['transaction_id'];
    listingUrl = json['listing_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['booking_id'] = this.bookingId;
    data['event_booking_number'] = this.eventBookingNumber;
    data['event_id'] = this.eventId;
    data['listing_id'] = this.listingId;
    data['subtotal'] = this.subtotal;
    data['total_amount'] = this.totalAmount;
    data['payment_status'] = this.paymentStatus;
    data['payment_method'] = this.paymentMethod;
    data['transaction_id'] = this.transactionId;
    data['listing_url'] = this.listingUrl;
    return data;
  }
}
