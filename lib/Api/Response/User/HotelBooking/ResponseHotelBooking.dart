class ResponseHotelBooking {
  String? result;
  String? message;
  List<HotelBooking>? data;

  ResponseHotelBooking({this.result, this.message, this.data});

  ResponseHotelBooking.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    if (json['data'] != null) {
      data = <HotelBooking>[];
      json['data'].forEach((v) {
        data!.add(new HotelBooking.fromJson(v));
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

class HotelBooking {
  int? id;
  String? hotelName;
  String? checkInDate;
  String? checkOutDate;
  int? totalRooms;
  int? totalMattress;
  String? bookingStatus;
  String? bookingCancellationStatus;
  int? finalAmount;
  String? finalAmountText;

  HotelBooking(
      {this.id,
        this.hotelName,
        this.checkInDate,
        this.checkOutDate,
        this.totalRooms,
        this.totalMattress,
        this.bookingStatus,
        this.bookingCancellationStatus,
        this.finalAmount,
        this.finalAmountText});

  HotelBooking.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    hotelName = json['hotel_name'];
    checkInDate = json['check_in_date'];
    checkOutDate = json['check_out_date'];
    totalRooms = json['total_rooms'];
    totalMattress = json['total_mattress'];
    bookingStatus = json['booking_status'];
    bookingCancellationStatus = json['booking_cancellation_status'];
    finalAmount = json['final_amount'];
    finalAmountText = json['final_amount_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['hotel_name'] = this.hotelName;
    data['check_in_date'] = this.checkInDate;
    data['check_out_date'] = this.checkOutDate;
    data['total_rooms'] = this.totalRooms;
    data['total_mattress'] = this.totalMattress;
    data['booking_status'] = this.bookingStatus;
    data['booking_cancellation_status'] = this.bookingCancellationStatus;
    data['final_amount'] = this.finalAmount;
    data['final_amount_text'] = this.finalAmountText;
    return data;
  }
}
