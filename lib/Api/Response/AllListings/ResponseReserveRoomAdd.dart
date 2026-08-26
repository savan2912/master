class ResponseReserveRoomAdd {
  String? result;
  String? message;
  ReserveRoomAddDetail? data;

  ResponseReserveRoomAdd({this.result, this.message, this.data});

  ResponseReserveRoomAdd.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    data = json['data'] != null ? ReserveRoomAddDetail.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['result'] = result;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ReserveRoomAddDetail {
  Stay? stay;
  Summary? summary;
  List<Rooms>? rooms;

  // UI Code માં selectedRooms નો ગેટર વાપર્યો હોવાથી Error આવતી હતી, તેના માટે નીચેનો ગેટર ઉમેરેલ છે:
  List<Rooms>? get selectedRooms => rooms;

  ReserveRoomAddDetail({this.stay, this.summary, this.rooms});

  ReserveRoomAddDetail.fromJson(Map<String, dynamic> json) {
    stay = json['stay'] != null ? Stay.fromJson(json['stay']) : null;
    summary = json['summary'] != null ? Summary.fromJson(json['summary']) : null;

    // API રિસ્પોન્સમાં ક્યારેક 'selected_rooms' અથવા 'rooms' તરીકે કી (key) આવતી હોય તો બંને હેન્ડલ થશે
    var roomsJson = json['selected_rooms'] ?? json['rooms'];
    if (roomsJson != null) {
      rooms = <Rooms>[];
      roomsJson.forEach((v) {
        rooms!.add(Rooms.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (stay != null) {
      data['stay'] = stay!.toJson();
    }
    if (summary != null) {
      data['summary'] = summary!.toJson();
    }
    if (rooms != null) {
      data['rooms'] = rooms!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Stay {
  int? listingId;
  String? checkin;
  String? checkout;
  int? totalNights;
  int? adults;
  int? childs;

  Stay({
    this.listingId,
    this.checkin,
    this.checkout,
    this.totalNights,
    this.adults,
    this.childs,
  });

  Stay.fromJson(Map<String, dynamic> json) {
    listingId = json['listing_id'];
    checkin = json['checkin'];
    checkout = json['checkout'];
    totalNights = json['total_nights'];
    adults = json['adults'];
    childs = json['childs'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['listing_id'] = listingId;
    data['checkin'] = checkin;
    data['checkout'] = checkout;
    data['total_nights'] = totalNights;
    data['adults'] = adults;
    data['childs'] = childs;
    return data;
  }
}

class Summary {
  int? totalRooms;
  int? totalMattress;
  int? totalAdults;
  int? totalChilds;
  int? capacity;
  int? requiredCapacity;
  bool? isEnoughCapacity;
  int? subTotal;
  int? grandTotal;

  Summary({
    this.totalRooms,
    this.totalMattress,
    this.totalAdults,
    this.totalChilds,
    this.capacity,
    this.requiredCapacity,
    this.isEnoughCapacity,
    this.subTotal,
    this.grandTotal,
  });

  Summary.fromJson(Map<String, dynamic> json) {
    totalRooms = json['total_rooms'];
    totalMattress = json['total_mattress'];
    totalAdults = json['total_adults'];
    totalChilds = json['total_childs'];
    capacity = json['capacity'];
    requiredCapacity = json['required_capacity'];
    isEnoughCapacity = json['is_enough_capacity'];
    subTotal = json['sub_total'];
    grandTotal = json['grand_total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_rooms'] = totalRooms;
    data['total_mattress'] = totalMattress;
    data['total_adults'] = totalAdults;
    data['total_childs'] = totalChilds;
    data['capacity'] = capacity;
    data['required_capacity'] = requiredCapacity;
    data['is_enough_capacity'] = isEnoughCapacity;
    data['sub_total'] = subTotal;
    data['grand_total'] = grandTotal;
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
  int? quantity;
  int? totalPrice;
  List<DateWisePrices>? dateWisePrices;

  Rooms({
    this.roomId,
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
    this.quantity,
    this.totalPrice,
    this.dateWisePrices,
  });

  Rooms.fromJson(Map<String, dynamic> json) {
    roomId = json['room_id'];
    roomName = json['room_name'];
    planId = json['plan_id'];
    planName = json['plan_name'];
    if (json['plan_features'] != null) {
      planFeatures = <PlanFeatures>[];
      json['plan_features'].forEach((v) {
        planFeatures!.add(PlanFeatures.fromJson(v));
      });
    }
    adults = json['adults'];
    childs = json['childs'];
    mattress = json['mattress'];
    basePrice = json['base_price'];
    mattressPricePerUnit = json['mattress_price_per_unit'];
    mattressTotal = json['mattress_total'];
    pricePerUnit = json['price_per_unit'];
    quantity = json['quantity'];
    totalPrice = json['total_price'];
    if (json['date_wise_prices'] != null) {
      dateWisePrices = <DateWisePrices>[];
      json['date_wise_prices'].forEach((v) {
        dateWisePrices!.add(DateWisePrices.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['room_id'] = roomId;
    data['room_name'] = roomName;
    data['plan_id'] = planId;
    data['plan_name'] = planName;
    if (planFeatures != null) {
      data['plan_features'] = planFeatures!.map((v) => v.toJson()).toList();
    }
    data['adults'] = adults;
    data['childs'] = childs;
    data['mattress'] = mattress;
    data['base_price'] = basePrice;
    data['mattress_price_per_unit'] = mattressPricePerUnit;
    data['mattress_total'] = mattressTotal;
    data['price_per_unit'] = pricePerUnit;
    data['quantity'] = quantity;
    data['total_price'] = totalPrice;
    if (dateWisePrices != null) {
      data['date_wise_prices'] = dateWisePrices!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['description'] = description;
    return data;
  }
}

class DateWisePrices {
  String? date;
  String? effectiveDate;
  int? basePrice;
  int? finalPrice;

  DateWisePrices({this.date, this.effectiveDate, this.basePrice, this.finalPrice});

  DateWisePrices.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    effectiveDate = json['effective_date'];
    basePrice = json['base_price'];
    finalPrice = json['final_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['effective_date'] = effectiveDate;
    data['base_price'] = basePrice;
    data['final_price'] = finalPrice;
    return data;
  }
}