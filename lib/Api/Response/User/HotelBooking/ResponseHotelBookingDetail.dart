class ResponseHotelBookingDetail {
  String? result;
  String? message;
  HotelBookingDetail? data;

  ResponseHotelBookingDetail({this.result, this.message, this.data});

  ResponseHotelBookingDetail.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    data = json['data'] != null ? new HotelBookingDetail.fromJson(json['data']) : null;
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

class HotelBookingDetail {
  int? bookingId;
  List<Rooms>? rooms;
  int? roomTotal;
  List<AdditionalServices>? additionalServices;
  int? serviceTotal;
  Summary? summary;

  HotelBookingDetail(
      {this.bookingId,
        this.rooms,
        this.roomTotal,
        this.additionalServices,
        this.serviceTotal,
        this.summary});

  HotelBookingDetail.fromJson(Map<String, dynamic> json) {
    bookingId = json['booking_id'];
    if (json['rooms'] != null) {
      rooms = <Rooms>[];
      json['rooms'].forEach((v) {
        rooms!.add(new Rooms.fromJson(v));
      });
    }
    roomTotal = json['room_total'];
    if (json['additional_services'] != null) {
      additionalServices = <AdditionalServices>[];
      json['additional_services'].forEach((v) {
        additionalServices!.add(new AdditionalServices.fromJson(v));
      });
    }
    serviceTotal = json['service_total'];
    summary =
    json['summary'] != null ? new Summary.fromJson(json['summary']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['booking_id'] = this.bookingId;
    if (this.rooms != null) {
      data['rooms'] = this.rooms!.map((v) => v.toJson()).toList();
    }
    data['room_total'] = this.roomTotal;
    if (this.additionalServices != null) {
      data['additional_services'] =
          this.additionalServices!.map((v) => v.toJson()).toList();
    }
    data['service_total'] = this.serviceTotal;
    if (this.summary != null) {
      data['summary'] = this.summary!.toJson();
    }
    return data;
  }
}

class Rooms {
  String? roomName;
  int? totalRooms;
  int? adults;
  int? children;
  String? planName;
  List<Features>? features;
  List<PriceBreakup>? priceBreakup;
  Mattress? mattress;
  int? subTotal;

  Rooms(
      {this.roomName,
        this.totalRooms,
        this.adults,
        this.children,
        this.planName,
        this.features,
        this.priceBreakup,
        this.mattress,
        this.subTotal});

  Rooms.fromJson(Map<String, dynamic> json) {
    roomName = json['room_name'];
    totalRooms = json['total_rooms'];
    adults = json['adults'];
    children = json['children'];
    planName = json['plan_name'];
    if (json['features'] != null) {
      features = <Features>[];
      json['features'].forEach((v) {
        features!.add(new Features.fromJson(v));
      });
    }
    if (json['price_breakup'] != null) {
      priceBreakup = <PriceBreakup>[];
      json['price_breakup'].forEach((v) {
        priceBreakup!.add(new PriceBreakup.fromJson(v));
      });
    }
    mattress = json['mattress'] != null
        ? new Mattress.fromJson(json['mattress'])
        : null;
    subTotal = json['sub_total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['room_name'] = this.roomName;
    data['total_rooms'] = this.totalRooms;
    data['adults'] = this.adults;
    data['children'] = this.children;
    data['plan_name'] = this.planName;
    if (this.features != null) {
      data['features'] = this.features!.map((v) => v.toJson()).toList();
    }
    if (this.priceBreakup != null) {
      data['price_breakup'] =
          this.priceBreakup!.map((v) => v.toJson()).toList();
    }
    if (this.mattress != null) {
      data['mattress'] = this.mattress!.toJson();
    }
    data['sub_total'] = this.subTotal;
    return data;
  }
}

class Features {
  String? title;
  String? description;

  Features({this.title, this.description});

  Features.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    return data;
  }
}

class PriceBreakup {
  String? date;
  int? price;

  PriceBreakup({this.date, this.price});

  PriceBreakup.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['price'] = this.price;
    return data;
  }
}

class Mattress {
  int? qty;
  int? unitPrice;
  int? total;

  Mattress({this.qty, this.unitPrice, this.total});

  Mattress.fromJson(Map<String, dynamic> json) {
    qty = json['qty'];
    unitPrice = json['unit_price'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['qty'] = this.qty;
    data['unit_price'] = this.unitPrice;
    data['total'] = this.total;
    return data;
  }
}

class AdditionalServices {
  String? serviceName;
  String? description;
  int? quantity;
  int? unitPrice;
  int? total;

  AdditionalServices(
      {this.serviceName,
        this.description,
        this.quantity,
        this.unitPrice,
        this.total});

  AdditionalServices.fromJson(Map<String, dynamic> json) {
    serviceName = json['service_name'];
    description = json['description'];
    quantity = json['quantity'];
    unitPrice = json['unit_price'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['service_name'] = this.serviceName;
    data['description'] = this.description;
    data['quantity'] = this.quantity;
    data['unit_price'] = this.unitPrice;
    data['total'] = this.total;
    return data;
  }
}

class Summary {
  int? totalNights;
  int? totalAdults;
  int? totalChildren;
  String? paymentType;
  List<String>? roomDetails;
  int? subTotalAmount;
  int? taxAmount;
  int? discountAmount;
  int? finalAmount;

  Summary(
      {this.totalNights,
        this.totalAdults,
        this.totalChildren,
        this.paymentType,
        this.roomDetails,
        this.subTotalAmount,
        this.taxAmount,
        this.discountAmount,
        this.finalAmount});

  Summary.fromJson(Map<String, dynamic> json) {
    totalNights = json['total_nights'];
    totalAdults = json['total_adults'];
    totalChildren = json['total_children'];
    paymentType = json['payment_type'];
    roomDetails = json['room_details'].cast<String>();
    subTotalAmount = json['sub_total_amount'];
    taxAmount = json['tax_amount'];
    discountAmount = json['discount_amount'];
    finalAmount = json['final_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_nights'] = this.totalNights;
    data['total_adults'] = this.totalAdults;
    data['total_children'] = this.totalChildren;
    data['payment_type'] = this.paymentType;
    data['room_details'] = this.roomDetails;
    data['sub_total_amount'] = this.subTotalAmount;
    data['tax_amount'] = this.taxAmount;
    data['discount_amount'] = this.discountAmount;
    data['final_amount'] = this.finalAmount;
    return data;
  }
}
