class ResponseHomeEventAvailable {
  String? result;
  String? message;
  HomeEventList? data;

  ResponseHomeEventAvailable({this.result, this.message, this.data});

  ResponseHomeEventAvailable.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    data = json['data'] != null ? new HomeEventList.fromJson(json['data']) : null;
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

class HomeEventList {
  List<Listings>? listings;

  HomeEventList({this.listings});

  HomeEventList.fromJson(Map<String, dynamic> json) {
    if (json['listings'] != null) {
      listings = <Listings>[];
      json['listings'].forEach((v) {
        listings!.add(new Listings.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.listings != null) {
      data['listings'] = this.listings!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Listings {
  int? id;
  String? listingTitle;
  String? mobileNo;
  String? address;
  String? zipCode;
  String? imgS3Path;
  Category? category;
  int? eventAvailable;
  int? lowestEventPrice;
  List<Events>? events;

  Listings(
      {this.id,
        this.listingTitle,
        this.mobileNo,
        this.address,
        this.zipCode,
        this.imgS3Path,
        this.category,
        this.eventAvailable,
        this.lowestEventPrice,
        this.events});

  Listings.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    listingTitle = json['listing_title'];
    mobileNo = json['mobile_no'];
    address = json['address'];
    zipCode = json['zip_code'];
    imgS3Path = json['img_s3_path'];
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    eventAvailable = json['event_available'];
    lowestEventPrice = json['lowest_event_price'];
    if (json['events'] != null) {
      events = <Events>[];
      json['events'].forEach((v) {
        events!.add(new Events.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['listing_title'] = this.listingTitle;
    data['mobile_no'] = this.mobileNo;
    data['address'] = this.address;
    data['zip_code'] = this.zipCode;
    data['img_s3_path'] = this.imgS3Path;
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    data['event_available'] = this.eventAvailable;
    data['lowest_event_price'] = this.lowestEventPrice;
    if (this.events != null) {
      data['events'] = this.events!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Category {
  int? id;
  String? name;

  Category({this.id, this.name});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class Events {
  String? eventId;
  String? listingId;
  String? title;
  String? description;
  String? address;
  int? status;
  int? deleteStatus;
  List<Slots>? slots;

  Events(
      {this.eventId,
        this.listingId,
        this.title,
        this.description,
        this.address,
        this.status,
        this.deleteStatus,
        this.slots});

  Events.fromJson(Map<String, dynamic> json) {
    eventId = json['event_id'];
    listingId = json['listing_id'];
    title = json['title'];
    description = json['description'];
    address = json['address'];
    status = json['status'];
    deleteStatus = json['delete_status'];
    if (json['slots'] != null) {
      slots = <Slots>[];
      json['slots'].forEach((v) {
        slots!.add(new Slots.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['event_id'] = this.eventId;
    data['listing_id'] = this.listingId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['address'] = this.address;
    data['status'] = this.status;
    data['delete_status'] = this.deleteStatus;
    if (this.slots != null) {
      data['slots'] = this.slots!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Slots {
  String? slotId;
  String? slotName;
  String? slotDate;
  String? startTime;
  String? endTime;
  int? totalQuantity;
  int? remainingQuantity;
  List<Categories>? categories;

  Slots(
      {this.slotId,
        this.slotName,
        this.slotDate,
        this.startTime,
        this.endTime,
        this.totalQuantity,
        this.remainingQuantity,
        this.categories});

  Slots.fromJson(Map<String, dynamic> json) {
    slotId = json['slot_id'];
    slotName = json['slot_name'];
    slotDate = json['slot_date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    totalQuantity = json['total_quantity'];
    remainingQuantity = json['remaining_quantity'];
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(new Categories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['slot_id'] = this.slotId;
    data['slot_name'] = this.slotName;
    data['slot_date'] = this.slotDate;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['total_quantity'] = this.totalQuantity;
    data['remaining_quantity'] = this.remainingQuantity;
    if (this.categories != null) {
      data['categories'] = this.categories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Categories {
  String? categoryId;
  String? categoryName;
  int? price;
  int? totalQuantity;
  int? remainingQuantity;
  int? quantity;
  int? maxPerUser;

  Categories(
      {this.categoryId,
        this.categoryName,
        this.price,
        this.totalQuantity,
        this.remainingQuantity,
        this.quantity,
        this.maxPerUser});

  Categories.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    price = json['price'];
    totalQuantity = json['total_quantity'];
    remainingQuantity = json['remaining_quantity'];
    quantity = json['quantity'];
    maxPerUser = json['max_per_user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_id'] = this.categoryId;
    data['category_name'] = this.categoryName;
    data['price'] = this.price;
    data['total_quantity'] = this.totalQuantity;
    data['remaining_quantity'] = this.remainingQuantity;
    data['quantity'] = this.quantity;
    data['max_per_user'] = this.maxPerUser;
    return data;
  }
}
