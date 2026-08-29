class RequestEventFinalBooking {
  String? userId;
  String? listingId;
  List<BookingData>? bookingData;
  int? subTotal;
  int? finalAmount;
  String? razorpayPaymentId;
  String? razorpaySignature;
  String? paymentStatus;
  String? paymentMethod;
  int? amount;
  String? gatewayResponse;

  RequestEventFinalBooking(
      {this.userId,
        this.listingId,
        this.bookingData,
        this.subTotal,
        this.finalAmount,
        this.razorpayPaymentId,
        this.razorpaySignature,
        this.paymentStatus,
        this.paymentMethod,
        this.amount,
        this.gatewayResponse});

  RequestEventFinalBooking.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    listingId = json['listing_id'];
    if (json['booking_data'] != null) {
      bookingData = <BookingData>[];
      json['booking_data'].forEach((v) {
        bookingData!.add(new BookingData.fromJson(v));
      });
    }
    subTotal = json['subTotal'];
    finalAmount = json['finalAmount'];
    razorpayPaymentId = json['razorpay_payment_id'];
    razorpaySignature = json['razorpay_signature'];
    paymentStatus = json['payment_status'];
    paymentMethod = json['payment_method'];
    amount = json['amount'];
    gatewayResponse = json['gateway_response'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['listing_id'] = this.listingId;
    if (this.bookingData != null) {
      data['booking_data'] = this.bookingData!.map((v) => v.toJson()).toList();
    }
    data['subTotal'] = this.subTotal;
    data['finalAmount'] = this.finalAmount;
    data['razorpay_payment_id'] = this.razorpayPaymentId;
    data['razorpay_signature'] = this.razorpaySignature;
    data['payment_status'] = this.paymentStatus;
    data['payment_method'] = this.paymentMethod;
    data['amount'] = this.amount;
    data['gateway_response'] = this.gatewayResponse;
    return data;
  }
}

class BookingData {
  String? eventId;
  String? slotId;
  String? slotName;
  String? categoryId;
  String? categoryName;
  int? categoryPrice;
  int? quantity;

  BookingData(
      {this.eventId,
        this.slotId,
        this.slotName,
        this.categoryId,
        this.categoryName,
        this.categoryPrice,
        this.quantity});

  BookingData.fromJson(Map<String, dynamic> json) {
    eventId = json['event_id'];
    slotId = json['slot_id'];
    slotName = json['slot_name'];
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    categoryPrice = json['category_price'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['event_id'] = this.eventId;
    data['slot_id'] = this.slotId;
    data['slot_name'] = this.slotName;
    data['category_id'] = this.categoryId;
    data['category_name'] = this.categoryName;
    data['category_price'] = this.categoryPrice;
    data['quantity'] = this.quantity;
    return data;
  }
}
