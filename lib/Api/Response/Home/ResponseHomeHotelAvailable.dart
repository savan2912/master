class ResponseHomeHotelAvailable {
  String? result;
  String? message;
  HotelHomeList? data;

  ResponseHomeHotelAvailable({this.result, this.message, this.data});

  ResponseHomeHotelAvailable.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    data = json['data'] != null ? new HotelHomeList.fromJson(json['data']) : null;
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

class HotelHomeList {
  List<Listings>? listings;

  HotelHomeList({this.listings});

  HotelHomeList.fromJson(Map<String, dynamic> json) {
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
  int? hotelBookingExists;

  Listings(
      {this.id,
        this.listingTitle,
        this.mobileNo,
        this.address,
        this.zipCode,
        this.imgS3Path,
        this.category,
        this.hotelBookingExists});

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
    hotelBookingExists = json['hotel_booking_exists'];
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
    data['hotel_booking_exists'] = this.hotelBookingExists;
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
