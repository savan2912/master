class RequestHotelBookingRoomPricePlan {
  String? roomPlanId;
  String? userBookingId;
  String? counter;

  RequestHotelBookingRoomPricePlan(
      {this.roomPlanId, this.userBookingId, this.counter});

  RequestHotelBookingRoomPricePlan.fromJson(Map<String, dynamic> json) {
    roomPlanId = json['room_plan_id'];
    userBookingId = json['user_booking_id'];
    counter = json['counter'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['room_plan_id'] = this.roomPlanId;
    data['user_booking_id'] = this.userBookingId;
    data['counter'] = this.counter;
    return data;
  }
}
