class ResponseEventBookingList {
  String? result;
  String? message;
  EventBookingList? data;

  ResponseEventBookingList({this.result, this.message, this.data});

  ResponseEventBookingList.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    data = json['data'] != null ? new EventBookingList.fromJson(json['data']) : null;
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

class EventBookingList {
  List<Events>? events;
  String? taxPercent;
  String? listingId;
  String? listingTitle;
  ListingPayment? listingPayment;
  String? lowestPrice;
  String? razorpayLogo;

  EventBookingList(
      {this.events,
        this.taxPercent,
        this.listingTitle,
        this.listingId,
        this.listingPayment,
        this.lowestPrice,
        this.razorpayLogo});

  EventBookingList.fromJson(Map<String, dynamic> json) {
    if (json['events'] != null) {
      events = <Events>[];
      json['events'].forEach((v) {
        events!.add(new Events.fromJson(v));
      });
    }
    taxPercent = json['taxPercent'];
    listingTitle = json['listing_title'];
    listingId = json['listing_id'];
    listingPayment = json['listingPayment'] != null
        ? new ListingPayment.fromJson(json['listingPayment'])
        : null;
    lowestPrice = json['lowestPrice'];
    razorpayLogo = json['razorpayLogo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.events != null) {
      data['events'] = this.events!.map((v) => v.toJson()).toList();
    }
    data['taxPercent'] = this.taxPercent;
    data['listing_id'] = this.listingId;
    data['listing_title'] = this.listingTitle;
    if (this.listingPayment != null) {
      data['listingPayment'] = this.listingPayment!.toJson();
    }
    data['lowestPrice'] = this.lowestPrice;
    data['razorpayLogo'] = this.razorpayLogo;
    return data;
  }
}

class Events {
  int? id;
  int? vendorId;
  int? listingId;
  String? title;
  String? description;
  String? address;
  dynamic eventType;
  dynamic banner;
  dynamic eventScanner;
  int? status;
  int? deleteStatus;
  String? createdAt;
  String? updatedAt;
  List<VendorEventSlot>? vendorEventSlot;

  Events(
      {this.id,
        this.vendorId,
        this.listingId,
        this.title,
        this.description,
        this.address,
        this.eventType,
        this.banner,
        this.eventScanner,
        this.status,
        this.deleteStatus,
        this.createdAt,
        this.updatedAt,
        this.vendorEventSlot});

  Events.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vendorId = json['vendor_id'];
    listingId = json['listing_id'];
    title = json['title'];
    description = json['description'];
    address = json['address'];
    eventType = json['event_type'];
    banner = json['banner'];
    eventScanner = json['event_scanner'];
    status = json['status'];
    deleteStatus = json['delete_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['vendor_event_slot'] != null) {
      vendorEventSlot = <VendorEventSlot>[];
      json['vendor_event_slot'].forEach((v) {
        vendorEventSlot!.add(new VendorEventSlot.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['vendor_id'] = this.vendorId;
    data['listing_id'] = this.listingId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['address'] = this.address;
    data['event_type'] = this.eventType;
    data['banner'] = this.banner;
    data['event_scanner'] = this.eventScanner;
    data['status'] = this.status;
    data['delete_status'] = this.deleteStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.vendorEventSlot != null) {
      data['vendor_event_slot'] =
          this.vendorEventSlot!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VendorEventSlot {
  int? id;
  int? vendorEventId;
  String? slotName;
  String? date;
  String? startTime;
  String? endTime;
  int? totalQuantity;
  dynamic remainingQuantity;
  int? status;
  int? deleteStatus;
  String? createdAt;
  String? updatedAt;
  String? slotRemainingTotal;
  List<VendorEventCategory>? vendorEventCategory;

  VendorEventSlot(
      {this.id,
        this.vendorEventId,
        this.slotName,
        this.date,
        this.startTime,
        this.endTime,
        this.totalQuantity,
        this.remainingQuantity,
        this.status,
        this.deleteStatus,
        this.createdAt,
        this.updatedAt,
        this.slotRemainingTotal,
        this.vendorEventCategory});

  VendorEventSlot.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vendorEventId = json['vendor_event_id'];
    slotName = json['slot_name'];
    date = json['date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    totalQuantity = json['total_quantity'];
    remainingQuantity = json['remaining_quantity'];
    status = json['status'];
    deleteStatus = json['delete_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    slotRemainingTotal = json['slot_remaining_total'];
    if (json['vendor_event_category'] != null) {
      vendorEventCategory = <VendorEventCategory>[];
      json['vendor_event_category'].forEach((v) {
        vendorEventCategory!.add(new VendorEventCategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['vendor_event_id'] = this.vendorEventId;
    data['slot_name'] = this.slotName;
    data['date'] = this.date;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['total_quantity'] = this.totalQuantity;
    data['remaining_quantity'] = this.remainingQuantity;
    data['status'] = this.status;
    data['delete_status'] = this.deleteStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['slot_remaining_total'] = this.slotRemainingTotal;
    if (this.vendorEventCategory != null) {
      data['vendor_event_category'] =
          this.vendorEventCategory!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VendorEventCategory {
  int? id;
  int? vendorEventId;
  int? vendorEventSlotId;
  String? name;
  String? price;
  int? totalQuantity;
  int? remainingQuantity;
  int? maxPerUser;
  dynamic saleStart;
  dynamic saleEnd;
  int? status;
  int? deleteStatus;
  String? createdAt;
  String? updatedAt;

  VendorEventCategory(
      {this.id,
        this.vendorEventId,
        this.vendorEventSlotId,
        this.name,
        this.price,
        this.totalQuantity,
        this.remainingQuantity,
        this.maxPerUser,
        this.saleStart,
        this.saleEnd,
        this.status,
        this.deleteStatus,
        this.createdAt,
        this.updatedAt});

  VendorEventCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vendorEventId = json['vendor_event_id'];
    vendorEventSlotId = json['vendor_event_slot_id'];
    name = json['name'];
    price = json['price'];
    totalQuantity = json['total_quantity'];
    remainingQuantity = json['remaining_quantity'];
    maxPerUser = json['max_per_user'];
    saleStart = json['sale_start'];
    saleEnd = json['sale_end'];
    status = json['status'];
    deleteStatus = json['delete_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['vendor_event_id'] = this.vendorEventId;
    data['vendor_event_slot_id'] = this.vendorEventSlotId;
    data['name'] = this.name;
    data['price'] = this.price;
    data['total_quantity'] = this.totalQuantity;
    data['remaining_quantity'] = this.remainingQuantity;
    data['max_per_user'] = this.maxPerUser;
    data['sale_start'] = this.saleStart;
    data['sale_end'] = this.saleEnd;
    data['status'] = this.status;
    data['delete_status'] = this.deleteStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class ListingPayment {
  int? id;
  int? listingId;
  int? vendorId;
  String? apiKey;
  String? apiSecret;

  ListingPayment(
      {this.id, this.listingId, this.vendorId, this.apiKey, this.apiSecret});

  ListingPayment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    listingId = json['listing_id'];
    vendorId = json['vendor_id'];
    apiKey = json['api_key'];
    apiSecret = json['api_secret'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['listing_id'] = this.listingId;
    data['vendor_id'] = this.vendorId;
    data['api_key'] = this.apiKey;
    data['api_secret'] = this.apiSecret;
    return data;
  }
}
