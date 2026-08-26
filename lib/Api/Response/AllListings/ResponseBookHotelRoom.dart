class ResponseBookHotelRoom {
  String? result;
  String? message;
  BookHotelRoomData? data;

  ResponseBookHotelRoom({this.result, this.message, this.data});

  ResponseBookHotelRoom.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    data = json['data'] != null ? new BookHotelRoomData.fromJson(json['data']) : null;
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

class BookHotelRoomData {
  Hotel? hotel;
  List<Rooms>? rooms;
  List<HotelServices>? hotelServices;

  BookHotelRoomData({this.hotel, this.rooms, this.hotelServices});

  BookHotelRoomData.fromJson(Map<String, dynamic> json) {
    hotel = json['hotel'] != null ? new Hotel.fromJson(json['hotel']) : null;
    if (json['rooms'] != null) {
      rooms = <Rooms>[];
      json['rooms'].forEach((v) {
        rooms!.add(new Rooms.fromJson(v));
      });
    }
    if (json['hotel_services'] != null) {
      hotelServices = <HotelServices>[];
      json['hotel_services'].forEach((v) {
        hotelServices!.add(new HotelServices.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.hotel != null) {
      data['hotel'] = this.hotel!.toJson();
    }
    if (this.rooms != null) {
      data['rooms'] = this.rooms!.map((v) => v.toJson()).toList();
    }
    if (this.hotelServices != null) {
      data['hotel_services'] =
          this.hotelServices!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Hotel {
  int? listingId;
  int? hotelMasterId;
  String? hotelName;
  String? checkin;
  String? checkout;
  String? checkinDay;
  String? checkoutDay;
  int? totalNights;
  int? totalRooms;
  int? totalAdults;
  int? totalChilds;
  int? subTotal;
  int? taxPercent;
  int? taxAmount;
  int? grandTotal;
  int? totalMattress;
  String? hotelPolicies;

  Hotel(
      {this.listingId,
        this.hotelMasterId,
        this.hotelName,
        this.checkin,
        this.checkout,
        this.checkinDay,
        this.checkoutDay,
        this.totalNights,
        this.totalRooms,
        this.totalAdults,
        this.totalChilds,
        this.subTotal,
        this.taxPercent,
        this.taxAmount,
        this.grandTotal,
        this.totalMattress,
        this.hotelPolicies});

  Hotel.fromJson(Map<String, dynamic> json) {
    listingId = json['listing_id'];
    hotelMasterId = json['hotel_master_id'];
    hotelName = json['hotel_name'];
    checkin = json['checkin'];
    checkout = json['checkout'];
    checkinDay = json['checkin_day'];
    checkoutDay = json['checkout_day'];
    totalNights = json['total_nights'];
    totalRooms = json['total_rooms'];
    totalAdults = json['total_adults'];
    totalChilds = json['total_childs'];
    subTotal = json['sub_total'];
    taxPercent = json['tax_percent'];
    taxAmount = json['tax_amount'];
    grandTotal = json['grand_total'];
    totalMattress = json['total_mattress'];
    hotelPolicies = json['hotel_policies'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['listing_id'] = this.listingId;
    data['hotel_master_id'] = this.hotelMasterId;
    data['hotel_name'] = this.hotelName;
    data['checkin'] = this.checkin;
    data['checkout'] = this.checkout;
    data['checkin_day'] = this.checkinDay;
    data['checkout_day'] = this.checkoutDay;
    data['total_nights'] = this.totalNights;
    data['total_rooms'] = this.totalRooms;
    data['total_adults'] = this.totalAdults;
    data['total_childs'] = this.totalChilds;
    data['sub_total'] = this.subTotal;
    data['tax_percent'] = this.taxPercent;
    data['tax_amount'] = this.taxAmount;
    data['grand_total'] = this.grandTotal;
    data['total_mattress'] = this.totalMattress;
    data['hotel_policies'] = this.hotelPolicies;
    return data;
  }
}

class Rooms {
  int? roomId;
  String? roomName;
  int? planId;
  String? planName;
  List<PlanFeatures>? planFeatures;
  int? adults;
  int? childs;
  int? mattress;
  int? basePrice;
  int? mattressPricePerUnit;
  int? mattressTotal;
  int? pricePerUnit;
  int? totalPrice;
  int? quantity;
  List<DateWisePrices>? dateWisePrices;
  List<RoomServices>? roomServices;
  int? roomTotal;
  RoomSummary? roomSummary;

  Rooms(
      {this.roomId,
        this.roomName,
        this.planId,
        this.planName,
        this.planFeatures,
        this.adults,
        this.childs,
        this.mattress,
        this.basePrice,
        this.mattressPricePerUnit,
        this.mattressTotal,
        this.pricePerUnit,
        this.totalPrice,
        this.quantity,
        this.dateWisePrices,
        this.roomServices,
        this.roomTotal,
        this.roomSummary});

  Rooms.fromJson(Map<String, dynamic> json) {
    roomId = json['room_id'];
    roomName = json['room_name'];
    planId = json['plan_id'];
    planName = json['plan_name'];
    if (json['plan_features'] != null) {
      planFeatures = <PlanFeatures>[];
      json['plan_features'].forEach((v) {
        planFeatures!.add(new PlanFeatures.fromJson(v));
      });
    }
    adults = json['adults'];
    childs = json['childs'];
    mattress = json['mattress'];
    basePrice = json['base_price'];
    mattressPricePerUnit = json['mattress_price_per_unit'];
    mattressTotal = json['mattress_total'];
    pricePerUnit = json['price_per_unit'];
    totalPrice = json['total_price'];
    quantity = json['quantity'];
    if (json['date_wise_prices'] != null) {
      dateWisePrices = <DateWisePrices>[];
      json['date_wise_prices'].forEach((v) {
        dateWisePrices!.add(new DateWisePrices.fromJson(v));
      });
    }
    if (json['room_services'] != null) {
      roomServices = <RoomServices>[];
      json['room_services'].forEach((v) {
        roomServices!.add(new RoomServices.fromJson(v));
      });
    }
    roomTotal = json['room_total'];
    roomSummary = json['room_summary'] != null
        ? new RoomSummary.fromJson(json['room_summary'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['room_id'] = this.roomId;
    data['room_name'] = this.roomName;
    data['plan_id'] = this.planId;
    data['plan_name'] = this.planName;
    if (this.planFeatures != null) {
      data['plan_features'] =
          this.planFeatures!.map((v) => v.toJson()).toList();
    }
    data['adults'] = this.adults;
    data['childs'] = this.childs;
    data['mattress'] = this.mattress;
    data['base_price'] = this.basePrice;
    data['mattress_price_per_unit'] = this.mattressPricePerUnit;
    data['mattress_total'] = this.mattressTotal;
    data['price_per_unit'] = this.pricePerUnit;
    data['total_price'] = this.totalPrice;
    data['quantity'] = this.quantity;
    if (this.dateWisePrices != null) {
      data['date_wise_prices'] =
          this.dateWisePrices!.map((v) => v.toJson()).toList();
    }
    if (this.roomServices != null) {
      data['room_services'] =
          this.roomServices!.map((v) => v.toJson()).toList();
    }
    data['room_total'] = this.roomTotal;
    if (this.roomSummary != null) {
      data['room_summary'] = this.roomSummary!.toJson();
    }
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['description'] = this.description;
    return data;
  }
}

class DateWisePrices {
  String? date;
  String? effectiveDate;
  int? basePrice;
  int? finalPrice;

  DateWisePrices(
      {this.date, this.effectiveDate, this.basePrice, this.finalPrice});

  DateWisePrices.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    effectiveDate = json['effective_date'];
    basePrice = json['base_price'];
    finalPrice = json['final_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['effective_date'] = this.effectiveDate;
    data['base_price'] = this.basePrice;
    data['final_price'] = this.finalPrice;
    return data;
  }
}

class RoomServices {
  int? id;
  String? name;
  String? description;
  String? price;
  int? maxLimit;

  RoomServices(
      {this.id, this.name, this.description, this.price, this.maxLimit});

  RoomServices.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    maxLimit = json['max_limit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['price'] = this.price;
    data['max_limit'] = this.maxLimit;
    return data;
  }
}

class RoomSummary {
  String? roomName;
  List<DateWisePricess>? dateWisePricess;
  String? totalExtraMattressPrice;
  List<PlanFeatures>? planFeatures;

  RoomSummary(
      {this.roomName,
        this.dateWisePricess,
        this.totalExtraMattressPrice,
        this.planFeatures});

  RoomSummary.fromJson(Map<String, dynamic> json) {
    roomName = json['room_name'];
    if (json['date_wise_prices'] != null) {
      dateWisePricess = <DateWisePricess>[];
      json['date_wise_prices'].forEach((v) {
        dateWisePricess!.add(new DateWisePricess.fromJson(v));
      });
    }
    totalExtraMattressPrice = json['total_extra_mattress_price'];
    if (json['plan_features'] != null) {
      planFeatures = <PlanFeatures>[];
      json['plan_features'].forEach((v) {
        planFeatures!.add(new PlanFeatures.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['room_name'] = this.roomName;
    if (this.dateWisePricess != null) {
      data['date_wise_prices'] =
          this.dateWisePricess!.map((v) => v.toJson()).toList();
    }
    data['total_extra_mattress_price'] = this.totalExtraMattressPrice;
    if (this.planFeatures != null) {
      data['plan_features'] =
          this.planFeatures!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DateWisePricess{
  String? date;
  String? price;

  DateWisePricess({this.date, this.price});

  DateWisePricess.fromJson(Map<String, dynamic> json) {
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

class HotelServices {
  String? name;
  String? description;
  String? price;

  HotelServices({this.name, this.description, this.price});

  HotelServices.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['description'] = this.description;
    data['price'] = this.price;
    return data;
  }
}
