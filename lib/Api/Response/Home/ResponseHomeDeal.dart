class ResponseHomeDeal {
  String? result;
  String? message;
  List<HomeDeal>? data;

  ResponseHomeDeal({this.result, this.message, this.data});

  ResponseHomeDeal.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    if (json['data'] != null) {
      data = <HomeDeal>[];
      json['data'].forEach((v) {
        data!.add(HomeDeal.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['result'] = result;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class HomeDeal {
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

  HomeDeal({
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

  HomeDeal.fromJson(Map<String, dynamic> json) {
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
