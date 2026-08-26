class RequestFinalBillAdd {
  int? userId;
  BookingMeta? bookingMeta;
  int? subTotal;
  int? tax;
  int? grandTotal;
  int? allMattress;
  List<Rooms>? rooms;
  List<Services>? services;

  RequestFinalBillAdd({
    this.userId,
    this.bookingMeta,
    this.subTotal,
    this.tax,
    this.grandTotal,
    this.allMattress,
    this.rooms,
    this.services,
  });

  RequestFinalBillAdd.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    bookingMeta = json['booking_meta'] != null
        ? BookingMeta.fromJson(json['booking_meta'])
        : null;
    subTotal = json['sub_total'];
    tax = json['tax'];
    grandTotal = json['grand_total'];
    allMattress = json['all_mattress'];
    if (json['rooms'] != null) {
      rooms = <Rooms>[];
      json['rooms'].forEach((v) {
        rooms!.add(Rooms.fromJson(v));
      });
    }
    if (json['services'] != null) {
      services = <Services>[];
      json['services'].forEach((v) {
        services!.add(Services.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    if (bookingMeta != null) {
      data['booking_meta'] = bookingMeta!.toJson();
    }
    data['sub_total'] = subTotal;
    data['tax'] = tax;
    data['grand_total'] = grandTotal;
    data['all_mattress'] = allMattress;
    if (rooms != null) {
      data['rooms'] = rooms!.map((v) => v.toJson()).toList();
    }
    if (services != null) {
      data['services'] = services!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BookingMeta {
  int? hotelMasterId;
  String? checkin;
  String? checkout;
  int? adults;
  int? childs;
  int? rooms;
  String? guestName;
  String? guestEmail;
  String? guestPhone;

  BookingMeta({
    this.hotelMasterId,
    this.checkin,
    this.checkout,
    this.adults,
    this.childs,
    this.rooms,
    this.guestName,
    this.guestEmail,
    this.guestPhone,
  });

  BookingMeta.fromJson(Map<String, dynamic> json) {
    hotelMasterId = json['hotel_master_id'];
    checkin = json['checkin'];
    checkout = json['checkout'];
    adults = json['adults'];
    childs = json['childs'];
    rooms = json['rooms'];
    guestName = json['guest_name'];
    guestEmail = json['guest_email'];
    guestPhone = json['guest_phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['hotel_master_id'] = hotelMasterId;
    data['checkin'] = checkin;
    data['checkout'] = checkout;
    data['adults'] = adults;
    data['childs'] = childs;
    data['rooms'] = rooms;
    data['guest_name'] = guestName;
    data['guest_email'] = guestEmail;
    data['guest_phone'] = guestPhone;
    return data;
  }
}

class Rooms {
  int? roomId;
  int? planId;
  int? quantity;
  int? totalAdults;
  int? totalChilds;
  int? totalMattress;
  int? mattressPrice;
  List<DateWisePrices>? dateWisePrices;
  List<PlanFeatures>? planFeatures;

  Rooms({
    this.roomId,
    this.planId,
    this.quantity,
    this.totalAdults,
    this.totalChilds,
    this.totalMattress,
    this.mattressPrice,
    this.dateWisePrices,
    this.planFeatures,
  });

  Rooms.fromJson(Map<String, dynamic> json) {
    roomId = json['room_id'];
    planId = json['plan_id'];
    quantity = json['quantity'];
    totalAdults = json['total_adults'];
    totalChilds = json['total_childs'];
    totalMattress = json['total_mattress'];
    mattressPrice = json['mattress_price'];
    if (json['date_wise_prices'] != null) {
      dateWisePrices = <DateWisePrices>[];
      json['date_wise_prices'].forEach((v) {
        dateWisePrices!.add(DateWisePrices.fromJson(v));
      });
    }
    if (json['plan_features'] != null) {
      planFeatures = <PlanFeatures>[];
      json['plan_features'].forEach((v) {
        planFeatures!.add(PlanFeatures.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['room_id'] = roomId;
    data['plan_id'] = planId;
    data['quantity'] = quantity;
    data['total_adults'] = totalAdults;
    data['total_childs'] = totalChilds;
    data['total_mattress'] = totalMattress;
    data['mattress_price'] = mattressPrice;
    if (dateWisePrices != null) {
      data['date_wise_prices'] =
          dateWisePrices!.map((v) => v.toJson()).toList();
    }
    if (planFeatures != null) {
      data['plan_features'] = planFeatures!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DateWisePrices {
  String? date;
  int? finalPrice;

  DateWisePrices({this.date, this.finalPrice});

  DateWisePrices.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    finalPrice = json['final_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['final_price'] = finalPrice;
    return data;
  }
}

class PlanFeatures {
  String? name;
  String? description;

  PlanFeatures({this.name, this.description});

  PlanFeatures.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['description'] = description;
    return data;
  }
}

class Services {
  int? serviceId;
  String? serviceName;
  String? description;
  int? qty;
  int? price;

  Services({
    this.serviceId,
    this.serviceName,
    this.description,
    this.qty,
    this.price,
  });

  Services.fromJson(Map<String, dynamic> json) {
    serviceId = json['service_id'];
    serviceName = json['service_name'];
    description = json['Description'];
    qty = json['qty'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['service_id'] = serviceId;
    data['service_name'] = serviceName;
    data['Description'] = description;
    data['qty'] = qty;
    data['price'] = price;
    return data;
  }
}