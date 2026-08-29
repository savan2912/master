class RequestEventBookingItem {
  String? userId;
  String? eventId;

  RequestEventBookingItem({this.userId, this.eventId});

  RequestEventBookingItem.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    eventId = json['event_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['event_id'] = this.eventId;
    return data;
  }
}
