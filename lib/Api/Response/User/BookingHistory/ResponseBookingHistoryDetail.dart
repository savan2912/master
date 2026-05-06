class ResponseBookingHistoryDetail {
  String? result;
  String? message;
  BookingHistoryDetail? data;

  ResponseBookingHistoryDetail({this.result, this.message, this.data});

  ResponseBookingHistoryDetail.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    data = json['data'] != null ? new BookingHistoryDetail.fromJson(json['data']) : null;
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

class BookingHistoryDetail {
  int? id;
  String? description;
  String? bookingDate;
  String? startTime;
  String? endTime;
  List<BookingService>? bookingService;
  int? totalDuration;
  int? totalPrice;
  String? totalDurationText;
  String? totalPriceText;

  BookingHistoryDetail(
      {this.id,
        this.description,
        this.bookingDate,
        this.startTime,
        this.endTime,
        this.bookingService,
        this.totalDuration,
        this.totalPrice,
        this.totalDurationText,
        this.totalPriceText});

  BookingHistoryDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    bookingDate = json['booking_date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    if (json['booking_service'] != null) {
      bookingService = <BookingService>[];
      json['booking_service'].forEach((v) {
        bookingService!.add(new BookingService.fromJson(v));
      });
    }
    totalDuration = json['total_duration'];
    totalPrice = json['total_price'];
    totalDurationText = json['total_duration_text'];
    totalPriceText = json['total_price_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['description'] = this.description;
    data['booking_date'] = this.bookingDate;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    if (this.bookingService != null) {
      data['booking_service'] =
          this.bookingService!.map((v) => v.toJson()).toList();
    }
    data['total_duration'] = this.totalDuration;
    data['total_price'] = this.totalPrice;
    data['total_duration_text'] = this.totalDurationText;
    data['total_price_text'] = this.totalPriceText;
    return data;
  }
}

class BookingService {
  String? serviceTitle;
  int? duration;
  String? durationText;
  int? servicePrice;
  String? servicePriceText;

  BookingService(
      {this.serviceTitle,
        this.duration,
        this.durationText,
        this.servicePrice,
        this.servicePriceText});

  BookingService.fromJson(Map<String, dynamic> json) {
    serviceTitle = json['service_title'];
    duration = json['duration'];
    durationText = json['duration_text'];
    servicePrice = json['service_price'];
    servicePriceText = json['service_price_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['service_title'] = this.serviceTitle;
    data['duration'] = this.duration;
    data['duration_text'] = this.durationText;
    data['service_price'] = this.servicePrice;
    data['service_price_text'] = this.servicePriceText;
    return data;
  }
}
