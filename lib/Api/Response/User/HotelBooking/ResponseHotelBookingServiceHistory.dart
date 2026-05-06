class ResponseHotelBookingServiceHistory {
  String? result;
  String? message;
  List<HotelBookingServiceHistory>? data;

  ResponseHotelBookingServiceHistory({this.result, this.message, this.data});

  ResponseHotelBookingServiceHistory.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    if (json['data'] != null) {
      data = <HotelBookingServiceHistory>[];
      json['data'].forEach((v) {
        data!.add(new HotelBookingServiceHistory.fromJson(v));
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

class HotelBookingServiceHistory {
  String? hotelName;
  String? serviceName;
  String? serviceDescription;
  String? unitPrice;
  int? quantity;
  String? totalPrice;

  HotelBookingServiceHistory(
      {this.hotelName,
        this.serviceName,
        this.serviceDescription,
        this.unitPrice,
        this.quantity,
        this.totalPrice});

  HotelBookingServiceHistory.fromJson(Map<String, dynamic> json) {
    hotelName = json['hotel_name'];
    serviceName = json['service_name'];
    serviceDescription = json['service_description'];
    unitPrice = json['unit_price'];
    quantity = json['quantity'];
    totalPrice = json['total_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hotel_name'] = this.hotelName;
    data['service_name'] = this.serviceName;
    data['service_description'] = this.serviceDescription;
    data['unit_price'] = this.unitPrice;
    data['quantity'] = this.quantity;
    data['total_price'] = this.totalPrice;
    return data;
  }
}
