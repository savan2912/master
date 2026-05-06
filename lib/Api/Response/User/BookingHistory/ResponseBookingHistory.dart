class ResponseBookingHistory {
  String? result;
  String? message;
  List<UserBookingHistory>? data;

  ResponseBookingHistory({this.result, this.message, this.data});

  ResponseBookingHistory.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    if (json['data'] != null) {
      data = <UserBookingHistory>[];
      json['data'].forEach((v) {
        data!.add(new UserBookingHistory.fromJson(v));
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

class UserBookingHistory {
  int? id;
  String? bookingDate;
  String? listingTitle;
  String? name;
  String? email;
  String? phone;
  String? time;
  int? amount;
  int? status;
  String? statusText;

  UserBookingHistory(
      {this.id,
        this.bookingDate,
        this.listingTitle,
        this.name,
        this.email,
        this.phone,
        this.time,
        this.amount,
        this.status,
        this.statusText});

  UserBookingHistory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookingDate = json['booking_date'];
    listingTitle = json['listing_title'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    time = json['time'];
    amount = json['amount'];
    status = json['status'];
    statusText = json['status_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['booking_date'] = this.bookingDate;
    data['listing_title'] = this.listingTitle;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['time'] = this.time;
    data['amount'] = this.amount;
    data['status'] = this.status;
    data['status_text'] = this.statusText;
    return data;
  }
}

