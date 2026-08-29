class ResponseEventTicketDownload {
  String? result;
  String? message;
  EventTicketDownload? data;

  ResponseEventTicketDownload({this.result, this.message, this.data});

  ResponseEventTicketDownload.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    data = json['data'] != null ? new EventTicketDownload.fromJson(json['data']) : null;
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

class EventTicketDownload {
  String? bookingId;
  String? eventBookingNumber;
  int? totalTickets;
  List<Tickets>? tickets;

  EventTicketDownload(
      {this.bookingId,
        this.eventBookingNumber,
        this.totalTickets,
        this.tickets});

  EventTicketDownload.fromJson(Map<String, dynamic> json) {
    bookingId = json['booking_id'];
    eventBookingNumber = json['event_booking_number'];
    totalTickets = json['total_tickets'];
    if (json['tickets'] != null) {
      tickets = <Tickets>[];
      json['tickets'].forEach((v) {
        tickets!.add(new Tickets.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['booking_id'] = this.bookingId;
    data['event_booking_number'] = this.eventBookingNumber;
    data['total_tickets'] = this.totalTickets;
    if (this.tickets != null) {
      data['tickets'] = this.tickets!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Tickets {
  String? ticketId;
  String? ticketNumber;
  String? attendeeName;
  String? slotName;
  Event? event;
  Category? category;
  Qr? qr;

  Tickets(
      {this.ticketId,
        this.ticketNumber,
        this.attendeeName,
        this.slotName,
        this.event,
        this.category,
        this.qr});

  Tickets.fromJson(Map<String, dynamic> json) {
    ticketId = json['ticket_id'];
    ticketNumber = json['ticket_number'];
    attendeeName = json['attendee_name'];
    slotName = json['slot_name'];
    event = json['event'] != null ? new Event.fromJson(json['event']) : null;
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    qr = json['qr'] != null ? new Qr.fromJson(json['qr']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ticket_id'] = this.ticketId;
    data['ticket_number'] = this.ticketNumber;
    data['attendee_name'] = this.attendeeName;
    data['slot_name'] = this.slotName;
    if (this.event != null) {
      data['event'] = this.event!.toJson();
    }
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    if (this.qr != null) {
      data['qr'] = this.qr!.toJson();
    }
    return data;
  }
}

class Event {
  String? eventId;
  String? listingId;
  String? title;
  String? description;
  String? eventDate;
  String? eventTime;

  Event(
      {this.eventId,
        this.listingId,
        this.title,
        this.description,
        this.eventDate,
        this.eventTime});

  Event.fromJson(Map<String, dynamic> json) {
    eventId = json['event_id'];
    listingId = json['listing_id'];
    title = json['title'];
    description = json['description'];
    eventDate = json['event_date'];
    eventTime = json['event_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['event_id'] = this.eventId;
    data['listing_id'] = this.listingId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['event_date'] = this.eventDate;
    data['event_time'] = this.eventTime;
    return data;
  }
}

class Category {
  String? categoryId;
  String? categoryName;

  Category({this.categoryId, this.categoryName});

  Category.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    categoryName = json['category_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_id'] = this.categoryId;
    data['category_name'] = this.categoryName;
    return data;
  }
}

class Qr {
  String? listingId;
  String? ticketNumber;
  String? qrCode;

  Qr({this.listingId, this.ticketNumber, this.qrCode});

  Qr.fromJson(Map<String, dynamic> json) {
    listingId = json['listing_id'];
    ticketNumber = json['ticket_number'];
    qrCode = json['qr_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['listing_id'] = this.listingId;
    data['ticket_number'] = this.ticketNumber;
    data['qr_code'] = this.qrCode;
    return data;
  }
}
