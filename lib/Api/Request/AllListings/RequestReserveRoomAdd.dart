class RequestReserveRoomAdd {
  int? listingId;
  String? checkin;
  String? checkout;
  int? adults;
  int? childs;
  List<Rooms>? rooms;

  RequestReserveRoomAdd(
      {this.listingId,
        this.checkin,
        this.checkout,
        this.adults,
        this.childs,
        this.rooms});

  RequestReserveRoomAdd.fromJson(Map<String, dynamic> json) {
    listingId = json['listing_id'];
    checkin = json['checkin'];
    checkout = json['checkout'];
    adults = json['adults'];
    childs = json['childs'];
    if (json['rooms'] != null) {
      rooms = <Rooms>[];
      json['rooms'].forEach((v) {
        rooms!.add(new Rooms.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['listing_id'] = this.listingId;
    data['checkin'] = this.checkin;
    data['checkout'] = this.checkout;
    data['adults'] = this.adults;
    data['childs'] = this.childs;
    if (this.rooms != null) {
      data['rooms'] = this.rooms!.map((v) => v.toJson()).toList();
    }
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
        this.dateWisePrices});

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
