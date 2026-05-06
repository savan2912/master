class ResponseHotelBookingCancellationHistory {
  String? result;
  String? message;
  List<HotelBookingCancellationHistoryData>? data;

  ResponseHotelBookingCancellationHistory(
      {this.result, this.message, this.data});

  ResponseHotelBookingCancellationHistory.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    if (json['data'] != null) {
      data = <HotelBookingCancellationHistoryData>[];
      json['data'].forEach((v) {
        data!.add(new HotelBookingCancellationHistoryData.fromJson(v));
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

class HotelBookingCancellationHistoryData {
  int? id;
  String? hotelName;
  String? checkIn;
  String? checkOut;
  int? totalRooms;
  int? totalMattress;
  String? status;
  String? amount;

  HotelBookingCancellationHistoryData(
      {this.id,
        this.hotelName,
        this.checkIn,
        this.checkOut,
        this.totalRooms,
        this.totalMattress,
        this.status,
        this.amount});

  HotelBookingCancellationHistoryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    hotelName = json['hotel_name'];
    checkIn = json['check_in'];
    checkOut = json['check_out'];
    totalRooms = json['total_rooms'];
    totalMattress = json['total_mattress'];
    status = json['status'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['hotel_name'] = this.hotelName;
    data['check_in'] = this.checkIn;
    data['check_out'] = this.checkOut;
    data['total_rooms'] = this.totalRooms;
    data['total_mattress'] = this.totalMattress;
    data['status'] = this.status;
    data['amount'] = this.amount;
    return data;
  }
}
