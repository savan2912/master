class ResponseHotelBookingRoomHistory {
  String? result;
  String? message;
  List<HotelRoomHistory>? data;

  ResponseHotelBookingRoomHistory({this.result, this.message, this.data});

  ResponseHotelBookingRoomHistory.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    if (json['data'] != null) {
      data = <HotelRoomHistory>[];
      json['data'].forEach((v) {
        data!.add(new HotelRoomHistory.fromJson(v));
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

class HotelRoomHistory {
  String? hotelName;
  String? planName;
  String? roomName;
  String? checkIn;
  String? checkOut;
  int? totalRoom;
  String? featuresName;
  String? featuresDesc;
  int? roomPlanId;

  HotelRoomHistory(
      {this.hotelName,
        this.planName,
        this.roomName,
        this.checkIn,
        this.checkOut,
        this.totalRoom,
        this.featuresName,
        this.featuresDesc,
        this.roomPlanId});

  HotelRoomHistory.fromJson(Map<String, dynamic> json) {
    hotelName = json['hotel_name'];
    planName = json['plan_name'];
    roomName = json['room_name'];
    checkIn = json['check_in'];
    checkOut = json['check_out'];
    totalRoom = json['total_room'];
    featuresName = json['features_name'];
    featuresDesc = json['features_desc'];
    roomPlanId = json['room_plan_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hotel_name'] = this.hotelName;
    data['plan_name'] = this.planName;
    data['room_name'] = this.roomName;
    data['check_in'] = this.checkIn;
    data['check_out'] = this.checkOut;
    data['total_room'] = this.totalRoom;
    data['features_name'] = this.featuresName;
    data['features_desc'] = this.featuresDesc;
    data['room_plan_id'] = this.roomPlanId;
    return data;
  }
}
