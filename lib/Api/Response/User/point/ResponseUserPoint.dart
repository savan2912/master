class ResponseUserPoint {
  String? result;
  String? message;
  List<UserPoint>? data;

  ResponseUserPoint({this.result, this.message, this.data});

  ResponseUserPoint.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    if (json['data'] != null) {
      data = <UserPoint>[];
      json['data'].forEach((v) {
        data!.add(new UserPoint.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserPoint {
  int? userId;
  int? listingId;
  int? totalPoints;
  int? redeemedPoints;
  int? actualPoints;
  User? user;
  Listings? listings;

  UserPoint(
      {this.userId,
        this.listingId,
        this.totalPoints,
        this.redeemedPoints,
        this.actualPoints,
        this.user,
        this.listings});

  UserPoint.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    listingId = json['listing_id'];
    totalPoints = json['total_points'];
    redeemedPoints = json['redeemed_points'];
    actualPoints = json['actual_points'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    listings = json['listings'] != null
        ? new Listings.fromJson(json['listings'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['listing_id'] = this.listingId;
    data['total_points'] = this.totalPoints;
    data['redeemed_points'] = this.redeemedPoints;
    data['actual_points'] = this.actualPoints;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.listings != null) {
      data['listings'] = this.listings!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? fName;
  String? lName;
  String? phone;

  User({this.id, this.fName, this.lName, this.phone});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fName = json['f_name'];
    lName = json['l_name'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['f_name'] = this.fName;
    data['l_name'] = this.lName;
    data['phone'] = this.phone;
    return data;
  }
}

class Listings {
  int? id;
  String? listingTitle;
  int? vendorId;
  Vendor? vendor;

  Listings({this.id, this.listingTitle, this.vendorId, this.vendor});

  Listings.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    listingTitle = json['listing_title'];
    vendorId = json['vendor_id'];
    vendor =
    json['vendor'] != null ? new Vendor.fromJson(json['vendor']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['listing_title'] = this.listingTitle;
    data['vendor_id'] = this.vendorId;
    if (this.vendor != null) {
      data['vendor'] = this.vendor!.toJson();
    }
    return data;
  }
}

class Vendor {
  int? id;
  String? fName;
  String? lName;

  Vendor({this.id, this.fName, this.lName});

  Vendor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fName = json['f_name'];
    lName = json['l_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['f_name'] = this.fName;
    data['l_name'] = this.lName;
    return data;
  }
}
