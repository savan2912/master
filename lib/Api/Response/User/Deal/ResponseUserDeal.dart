class ResponseUserDeal {
  String? result;
  String? message;
  List<UserDeal>? data;

  ResponseUserDeal({this.result, this.message, this.data});

  ResponseUserDeal.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    if (json['data'] != null) {
      data = <UserDeal>[];
      json['data'].forEach((v) {
        data!.add(new UserDeal.fromJson(v));
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

class UserDeal {
  int? userDealId;
  int? id;
  String? endDate;
  String? dealName;
  String? listingTitle;
  String? couponCode;
  String? dealDesc;
  String? discountType;
  String? discountValue;
  int? points;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? dealDate;

  UserDeal(
      {this.userDealId,
        this.id,
        this.endDate,
        this.dealName,
        this.listingTitle,
        this.couponCode,
        this.dealDesc,
        this.discountType,
        this.discountValue,
        this.points,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.dealDate});

  UserDeal.fromJson(Map<String, dynamic> json) {
    userDealId = json['user_deal_id'];
    id = json['id'];
    endDate = json['end_date'];
    dealName = json['deal_name'];
    listingTitle = json['listing_title'];
    couponCode = json['coupon_code'];
    dealDesc = json['deal_desc'];
    discountType = json['discount_type'];
    discountValue = json['discount_value'];
    points = json['points'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    dealDate = json['deal_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_deal_id'] = this.userDealId;
    data['id'] = this.id;
    data['end_date'] = this.endDate;
    data['deal_name'] = this.dealName;
    data['listing_title'] = this.listingTitle;
    data['coupon_code'] = this.couponCode;
    data['deal_desc'] = this.dealDesc;
    data['discount_type'] = this.discountType;
    data['discount_value'] = this.discountValue;
    data['points'] = this.points;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deal_date'] = this.dealDate;
    return data;
  }
}
