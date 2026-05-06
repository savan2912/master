class ResponseHotelBookingCancellation {
  String? result;
  String? message;
  dynamic error;

  ResponseHotelBookingCancellation({this.result, this.message, this.error});

  ResponseHotelBookingCancellation.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['message'] = this.message;
    data['error'] = this.error;
    return data;
  }
}
