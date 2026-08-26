class RequestAddService {
  int? id;
  int? listingId;
  int? staffId;
  String? name;
  String? email;
  String? phone;
  String? address;
  String? description;
  String? bookingDate;
  String? slotFrom;
  String? slotTo;
  int? totalPrice;
  int? totalMinutes;
  List<Services>? services;

  RequestAddService(
      {this.id,
        this.listingId,
        this.staffId,
        this.name,
        this.email,
        this.phone,
        this.address,
        this.description,
        this.bookingDate,
        this.slotFrom,
        this.slotTo,
        this.totalPrice,
        this.totalMinutes,
        this.services});

  RequestAddService.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    listingId = json['listing_id'];
    staffId = json['staff_id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
    description = json['description'];
    bookingDate = json['booking_date'];
    slotFrom = json['slot_from'];
    slotTo = json['slot_to'];
    totalPrice = json['total_price'];
    totalMinutes = json['total_minutes'];
    if (json['services'] != null) {
      services = <Services>[];
      json['services'].forEach((v) {
        services!.add(new Services.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['listing_id'] = this.listingId;
    data['staff_id'] = this.staffId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['description'] = this.description;
    data['booking_date'] = this.bookingDate;
    data['slot_from'] = this.slotFrom;
    data['slot_to'] = this.slotTo;
    data['total_price'] = this.totalPrice;
    data['total_minutes'] = this.totalMinutes;
    if (this.services != null) {
      data['services'] = this.services!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Services {
  int? id;
  String? name;
  int? price;
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
