class ResponseAllDeals {
  String? result;
  String? message;
  AllDeals? data;

  ResponseAllDeals({this.result, this.message, this.data});

  ResponseAllDeals.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    data = json['data'] != null ? new AllDeals.fromJson(json['data']) : null;
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

class AllDeals {
  List<Deals>? deals;
  List<NearbyDeals>? nearbyDealsData;

  AllDeals({this.deals, this.nearbyDealsData});

  AllDeals.fromJson(Map<String, dynamic> json) {
    if (json['deals'] != null) {
      deals = <Deals>[];
      json['deals'].forEach((v) {
        deals!.add(new Deals.fromJson(v));
      });
    }
    if (json['nearbyDeals'] != null) {
      nearbyDealsData = <NearbyDeals>[];
      json['nearbyDeals'].forEach((v) {
        nearbyDealsData!.add(new NearbyDeals.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.deals != null) {
      data['deals'] = this.deals!.map((v) => v.toJson()).toList();
    }
    if (this.nearbyDealsData != null) {
      data['nearbyDeals'] = this.nearbyDealsData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Deals {
  int? id;
  int? vendorId;
  int? listingId;
  int? dealTempId;
  String? dealName;
  String? dealDesc;
  String? startDate;
  String? endDate;
  int? status;
  int? autopilotStatus;
  String? couponCode;
  String? discountType;
  int? dealPoint;
  int? noOfUser;
  String? discountValue;
  int? msgSent;
  int? pushNotifyStatus;
  int? autopilotId;
  dynamic image;
  String? createdAt;
  String? updatedAt;
  int? cityId;
  String? cityName;
  String? templateImage;
  String? listingImage;

  Deals(
      {this.id,
        this.vendorId,
        this.listingId,
        this.dealTempId,
        this.dealName,
        this.dealDesc,
        this.startDate,
        this.endDate,
        this.status,
        this.autopilotStatus,
        this.couponCode,
        this.discountType,
        this.dealPoint,
        this.noOfUser,
        this.discountValue,
        this.msgSent,
        this.pushNotifyStatus,
        this.autopilotId,
        this.image,
        this.createdAt,
        this.updatedAt,
        this.cityId,
        this.cityName,
        this.templateImage,
        this.listingImage});

  Deals.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vendorId = json['vendor_id'];
    listingId = json['listing_id'];
    dealTempId = json['deal_temp_id'];
    dealName = json['deal_name'];
    dealDesc = json['deal_desc'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    status = json['status'];
    autopilotStatus = json['autopilot_status'];
    couponCode = json['coupon_code'];
    discountType = json['discount_type'];
    dealPoint = json['deal_point'];
    noOfUser = json['no_of_user'];
    discountValue = json['discount_value'];
    msgSent = json['msg_sent'];
    pushNotifyStatus = json['push_notify_status'];
    autopilotId = json['autopilot_id'];
    image = json['image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    cityId = json['city_id'];
    cityName = json['city_name'];
    templateImage = json['template_image'];
    listingImage = json['listing_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['vendor_id'] = this.vendorId;
    data['listing_id'] = this.listingId;
    data['deal_temp_id'] = this.dealTempId;
    data['deal_name'] = this.dealName;
    data['deal_desc'] = this.dealDesc;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['status'] = this.status;
    data['autopilot_status'] = this.autopilotStatus;
    data['coupon_code'] = this.couponCode;
    data['discount_type'] = this.discountType;
    data['deal_point'] = this.dealPoint;
    data['no_of_user'] = this.noOfUser;
    data['discount_value'] = this.discountValue;
    data['msg_sent'] = this.msgSent;
    data['push_notify_status'] = this.pushNotifyStatus;
    data['autopilot_id'] = this.autopilotId;
    data['image'] = this.image;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['city_id'] = this.cityId;
    data['city_name'] = this.cityName;
    data['template_image'] = this.templateImage;
    data['listing_image'] = this.listingImage;
    return data;
  }
}

class NearbyDeals {
  int? id;
  int? vendorId;
  int? listingId;
  int? dealTempId;
  String? dealName;
  String? dealDesc;
  String? startDate;
  String? endDate;
  int? status;
  int? autopilotStatus;
  String? couponCode;
  String? discountType;
  int? dealPoint;
  int? noOfUser;
  String? discountValue;
  int? msgSent;
  int? pushNotifyStatus;
  int? autopilotId;
  dynamic image;
  String? createdAt;
  String? updatedAt;
  int? cityId;
  String? cityName;
  String? templateImage;
  String? listingImage;
  double? distance;

  NearbyDeals(
      {this.id,
        this.vendorId,
        this.listingId,
        this.dealTempId,
        this.dealName,
        this.dealDesc,
        this.startDate,
        this.endDate,
        this.status,
        this.autopilotStatus,
        this.couponCode,
        this.discountType,
        this.dealPoint,
        this.noOfUser,
        this.discountValue,
        this.msgSent,
        this.pushNotifyStatus,
        this.autopilotId,
        this.image,
        this.createdAt,
        this.updatedAt,
        this.cityId,
        this.cityName,
        this.templateImage,
        this.listingImage,
        this.distance});

  NearbyDeals.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vendorId = json['vendor_id'];
    listingId = json['listing_id'];
    dealTempId = json['deal_temp_id'];
    dealName = json['deal_name'];
    dealDesc = json['deal_desc'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    status = json['status'];
    autopilotStatus = json['autopilot_status'];
    couponCode = json['coupon_code'];
    discountType = json['discount_type'];
    dealPoint = json['deal_point'];
    noOfUser = json['no_of_user'];
    discountValue = json['discount_value'];
    msgSent = json['msg_sent'];
    pushNotifyStatus = json['push_notify_status'];
    autopilotId = json['autopilot_id'];
    image = json['image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    cityId = json['city_id'];
    cityName = json['city_name'];
    templateImage = json['template_image'];
    listingImage = json['listing_image'];
    distance = json['distance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['vendor_id'] = this.vendorId;
    data['listing_id'] = this.listingId;
    data['deal_temp_id'] = this.dealTempId;
    data['deal_name'] = this.dealName;
    data['deal_desc'] = this.dealDesc;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['status'] = this.status;
    data['autopilot_status'] = this.autopilotStatus;
    data['coupon_code'] = this.couponCode;
    data['discount_type'] = this.discountType;
    data['deal_point'] = this.dealPoint;
    data['no_of_user'] = this.noOfUser;
    data['discount_value'] = this.discountValue;
    data['msg_sent'] = this.msgSent;
    data['push_notify_status'] = this.pushNotifyStatus;
    data['autopilot_id'] = this.autopilotId;
    data['image'] = this.image;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['city_id'] = this.cityId;
    data['city_name'] = this.cityName;
    data['template_image'] = this.templateImage;
    data['listing_image'] = this.listingImage;
    data['distance'] = this.distance;
    return data;
  }
}
