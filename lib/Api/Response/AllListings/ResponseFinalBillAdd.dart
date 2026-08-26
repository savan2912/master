class ResponseFinalBillAdd {
  String? result;
  String? message;
  Data? data;

  ResponseFinalBillAdd({this.result, this.message, this.data});

  ResponseFinalBillAdd.fromJson(Map<String, dynamic> json) {
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
  int? bookingId;
  int? userId;
  int? hotelMasterId;
  int? listingId;
  String? checkInDate;
  String? checkOutDate;
  int? totalNights;
  int? totalRooms;
  int? totalAdults;
  int? totalChildren;
  int? totalMattress;
  int? subtotalAmount;
  int? taxAmount;
  int? discountAmount;
  int? finalAmount;
  int? bookingStatus;
  int? paymentStatus;
  String? paymentType;

  Data(
      {this.bookingId,
        this.userId,
        this.hotelMasterId,
        this.listingId,
        this.checkInDate,
        this.checkOutDate,
        this.totalNights,
        this.totalRooms,
        this.totalAdults,
        this.totalChildren,
        this.totalMattress,
        this.subtotalAmount,
        this.taxAmount,
        this.discountAmount,
        this.finalAmount,
        this.bookingStatus,
        this.paymentStatus,
        this.paymentType});

  Data.fromJson(Map<String, dynamic> json) {
    bookingId = json['booking_id'];
    userId = json['user_id'];
    hotelMasterId = json['hotel_master_id'];
    listingId = json['listing_id'];
    checkInDate = json['check_in_date'];
    checkOutDate = json['check_out_date'];
    totalNights = json['total_nights'];
    totalRooms = json['total_rooms'];
    totalAdults = json['total_adults'];
    totalChildren = json['total_children'];
    totalMattress = json['total_mattress'];
    subtotalAmount = json['subtotal_amount'];
    taxAmount = json['tax_amount'];
    discountAmount = json['discount_amount'];
    finalAmount = json['final_amount'];
    bookingStatus = json['booking_status'];
    paymentStatus = json['payment_status'];
    paymentType = json['payment_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['booking_id'] = this.bookingId;
    data['user_id'] = this.userId;
    data['hotel_master_id'] = this.hotelMasterId;
    data['listing_id'] = this.listingId;
    data['check_in_date'] = this.checkInDate;
    data['check_out_date'] = this.checkOutDate;
    data['total_nights'] = this.totalNights;
    data['total_rooms'] = this.totalRooms;
    data['total_adults'] = this.totalAdults;
    data['total_children'] = this.totalChildren;
    data['total_mattress'] = this.totalMattress;
    data['subtotal_amount'] = this.subtotalAmount;
    data['tax_amount'] = this.taxAmount;
    data['discount_amount'] = this.discountAmount;
    data['final_amount'] = this.finalAmount;
    data['booking_status'] = this.bookingStatus;
    data['payment_status'] = this.paymentStatus;
    data['payment_type'] = this.paymentType;
    return data;
  }
}
