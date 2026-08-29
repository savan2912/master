class ResponseEventTicketView {
  String? result;
  String? message;
  EventTicketView? data;

  ResponseEventTicketView({this.result, this.message, this.data});

  ResponseEventTicketView.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    data = json['data'] != null ? new EventTicketView.fromJson(json['data']) : null;
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

class EventTicketView {
  String? bookingId;
  dynamic eventBookingNumber;
  String? userId;
  String? listingId;
  String? bookingDate;
  String? bookingTime;
  User? user;
  Event? event;
  int? totalTickets;
  Qr? qr;

  EventTicketView(
      {this.bookingId,
        this.eventBookingNumber,
        this.userId,
        this.listingId,
        this.bookingDate,
        this.bookingTime,
        this.user,
        this.event,
        this.totalTickets,
        this.qr});

  EventTicketView.fromJson(Map<String, dynamic> json) {
    bookingId = json['booking_id'];
    eventBookingNumber = json['event_booking_number'];
    userId = json['user_id'];
    listingId = json['listing_id'];
    bookingDate = json['booking_date'];
    bookingTime = json['booking_time'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    event = json['event'] != null ? new Event.fromJson(json['event']) : null;
    totalTickets = json['total_tickets'];
    qr = json['qr'] != null ? new Qr.fromJson(json['qr']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['booking_id'] = this.bookingId;
    data['event_booking_number'] = this.eventBookingNumber;
    data['user_id'] = this.userId;
    data['listing_id'] = this.listingId;
    data['booking_date'] = this.bookingDate;
    data['booking_time'] = this.bookingTime;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.event != null) {
      data['event'] = this.event!.toJson();
    }
    data['total_tickets'] = this.totalTickets;
    if (this.qr != null) {
      data['qr'] = this.qr!.toJson();
    }
    return data;
  }
}

class User {
  String? id;
  String? firstName;
  String? lastName;
  String? fullName;

  User({this.id, this.firstName, this.lastName, this.fullName});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    fullName = json['full_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['full_name'] = this.fullName;
    return data;
  }
}

class Event {
  String? eventId;
  String? title;
  String? address;
  String? description;
  String? listingId;
  String? eventCreatedDate;
  String? eventCreatedTime;

  Event(
      {this.eventId,
        this.title,
        this.address,
        this.description,
        this.listingId,
        this.eventCreatedDate,
        this.eventCreatedTime});

  Event.fromJson(Map<String, dynamic> json) {
    eventId = json['event_id'];
    title = json['title'];
    address = json['address'];
    description = json['description'];
    listingId = json['listing_id'];
    eventCreatedDate = json['event_created_date'];
    eventCreatedTime = json['event_created_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['event_id'] = this.eventId;
    data['title'] = this.title;
    data['address'] = this.address;
    data['description'] = this.description;
    data['listing_id'] = this.listingId;
    data['event_created_date'] = this.eventCreatedDate;
    data['event_created_time'] = this.eventCreatedTime;
    return data;
  }
}

class Qr {
  String? listingId;

  Qr({this.listingId});

  Qr.fromJson(Map<String, dynamic> json) {
    listingId = json['listing_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['listing_id'] = this.listingId;
    return data;
  }
}
