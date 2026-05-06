class ResponseAllDeals {
  String? result;
  String? message;
  AllDeals? data;

  ResponseAllDeals({this.result, this.message, this.data});

  ResponseAllDeals.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    data = json['data'] != null ? AllDeals.fromJson(json['data']) : null;
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

class AllDeals {
  List<Deals>? deals;
  List<NearbyDeals>? nearbyDealsData;

  AllDeals({this.deals, this.nearbyDealsData});

  AllDeals.fromJson(Map<String, dynamic> json) {
    if (json['deals'] != null) {
      deals = <Deals>[];
      json['deals'].forEach((v) {
        deals!.add(Deals.fromJson(v));
      });
    }
    if (json['nearbyDeals'] != null) {
      nearbyDealsData = <NearbyDeals>[];
      json['nearbyDeals'].forEach((v) {
        nearbyDealsData!.add(NearbyDeals.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (deals != null) {
      data['deals'] = deals!.map((v) => v.toJson()).toList();
    }
    if (nearbyDealsData != null) {
      data['nearbyDeals'] = nearbyDealsData!.map((v) => v.toJson()).toList();
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

  Deals({
    this.id,
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
  });

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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['vendor_id'] = vendorId;
    data['listing_id'] = listingId;
    data['deal_temp_id'] = dealTempId;
    data['deal_name'] = dealName;
    data['deal_desc'] = dealDesc;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['status'] = status;
    data['autopilot_status'] = autopilotStatus;
    data['coupon_code'] = couponCode;
    data['discount_type'] = discountType;
    data['deal_point'] = dealPoint;
    data['no_of_user'] = noOfUser;
    data['discount_value'] = discountValue;
    data['msg_sent'] = msgSent;
    data['push_notify_status'] = pushNotifyStatus;
    data['autopilot_id'] = autopilotId;
    data['image'] = image;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['city_id'] = cityId;
    data['city_name'] = cityName;
    data['template_image'] = templateImage;
    data['listing_image'] = listingImage;
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

  NearbyDeals({
    this.id,
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
    this.distance,
  });

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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['vendor_id'] = vendorId;
    data['listing_id'] = listingId;
    data['deal_temp_id'] = dealTempId;
    data['deal_name'] = dealName;
    data['deal_desc'] = dealDesc;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['status'] = status;
    data['autopilot_status'] = autopilotStatus;
    data['coupon_code'] = couponCode;
    data['discount_type'] = discountType;
    data['deal_point'] = dealPoint;
    data['no_of_user'] = noOfUser;
    data['discount_value'] = discountValue;
    data['msg_sent'] = msgSent;
    data['push_notify_status'] = pushNotifyStatus;
    data['autopilot_id'] = autopilotId;
    data['image'] = image;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['city_id'] = cityId;
    data['city_name'] = cityName;
    data['template_image'] = templateImage;
    data['listing_image'] = listingImage;
    data['distance'] = distance;
    return data;
  }
}
