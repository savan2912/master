class ResponseEventBookingHistory {
  String? result;
  String? message;
  List<EventBookingHistory>? data;

  ResponseEventBookingHistory({this.result, this.message, this.data});

  ResponseEventBookingHistory.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    if (json['data'] != null) {
      data = <EventBookingHistory>[];
      json['data'].forEach((v) {
        data!.add(new EventBookingHistory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class EventBookingHistory {
  String? bookingId;
  String? eventId;
  String? bookingDateAndTime;
  String? eventName;
  int? subtotal;
  int? totalAmount;
  String? paymentStatus;

  EventBookingHistory(
      {this.bookingId,
        this.eventId,
        this.bookingDateAndTime,
        this.eventName,
        this.subtotal,
        this.totalAmount,
        this.paymentStatus});

  EventBookingHistory.fromJson(Map<String, dynamic> json) {
    bookingId = json['booking_id'];
    eventId = json['event_id'];
    bookingDateAndTime = json['booking_date_and_time'];
    eventName = json['event_name'];
    subtotal = json['subtotal'];
    totalAmount = json['total_amount'];
    paymentStatus = json['payment_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['booking_id'] = this.bookingId;
    data['event_id'] = this.eventId;
    data['booking_date_and_time'] = this.bookingDateAndTime;
    data['event_name'] = this.eventName;
    data['subtotal'] = this.subtotal;
    data['total_amount'] = this.totalAmount;
    data['payment_status'] = this.paymentStatus;
    return data;
  }
}
