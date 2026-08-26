class ResponseAddService {
  String? result;
  String? message;
  Data? data;

  ResponseAddService({this.result, this.message, this.data});

  ResponseAddService.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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

class Data {
  int? bookingId;
  int? vendorId;
  int? listingId;
  int? userId;
  int? staffId;
  String? name;
  String? email;
  String? phone;
  String? address;
  String? bookingDate;
  String? slotFrom;
  String? slotTo;
  int? totalAmount;
  int? status;
  List<Services>? services;

  Data(
      {this.bookingId,
        this.vendorId,
        this.listingId,
        this.userId,
        this.staffId,
        this.name,
        this.email,
        this.phone,
        this.address,
        this.bookingDate,
        this.slotFrom,
        this.slotTo,
        this.totalAmount,
        this.status,
        this.services});

  Data.fromJson(Map<String, dynamic> json) {
    bookingId = json['booking_id'];
    vendorId = json['vendor_id'];
    listingId = json['listing_id'];
    userId = json['user_id'];
    staffId = json['staff_id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
    bookingDate = json['booking_date'];
    slotFrom = json['slot_from'];
    slotTo = json['slot_to'];
    totalAmount = json['total_amount'];
    status = json['status'];
    if (json['services'] != null) {
      services = <Services>[];
      json['services'].forEach((v) {
        services!.add(new Services.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['booking_id'] = this.bookingId;
    data['vendor_id'] = this.vendorId;
    data['listing_id'] = this.listingId;
    data['user_id'] = this.userId;
    data['staff_id'] = this.staffId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['booking_date'] = this.bookingDate;
    data['slot_from'] = this.slotFrom;
    data['slot_to'] = this.slotTo;
    data['total_amount'] = this.totalAmount;
    data['status'] = this.status;
    if (this.services != null) {
      data['services'] = this.services!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Services {
  int? id;
  String? name;
  String? price;
  int? minutes;

  Services({this.id, this.name, this.price, this.minutes});

  Services.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    minutes = json['minutes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;
    data['minutes'] = this.minutes;
    return data;
  }
}
