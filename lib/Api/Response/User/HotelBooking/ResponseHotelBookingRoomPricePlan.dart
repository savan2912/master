class ResponseHotelBookingRoomPricePlan {
  String? result;
  String? message;
  List<HotelRoomPricePlanData>? data;

  ResponseHotelBookingRoomPricePlan({this.result, this.message, this.data});

  ResponseHotelBookingRoomPricePlan.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    if (json['data'] != null) {
      data = <HotelRoomPricePlanData>[];
      json['data'].forEach((v) {
        data!.add(new HotelRoomPricePlanData.fromJson(v));
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

class HotelRoomPricePlanData {
  String? dayName;
  String? date;
  String? price;
  int? status;

  HotelRoomPricePlanData({this.dayName, this.date, this.price, this.status});

  HotelRoomPricePlanData.fromJson(Map<String, dynamic> json) {
    dayName = json['day_name'];
    date = json['date'];
    price = json['price'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['day_name'] = this.dayName;
    data['date'] = this.date;
    data['price'] = this.price;
    data['status'] = this.status;
    return data;
  }
}
