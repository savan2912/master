class ResponseCrackedDeal {
  String? result;
  String? message;
  List<CrackedDeal>? data;

  ResponseCrackedDeal({this.result, this.message, this.data});

  ResponseCrackedDeal.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CrackedDeal>[];
      json['data'].forEach((v) {
        data!.add(new CrackedDeal.fromJson(v));
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

class CrackedDeal {
  String? listingTitle;
  String? dealName;
  String? couponCode;
  String? endDate;
  String? discountType;
  String? discountValue;
  int? status;

  CrackedDeal(
      {this.listingTitle,
        this.dealName,
        this.couponCode,
        this.endDate,
        this.discountType,
        this.discountValue,
        this.status});

  CrackedDeal.fromJson(Map<String, dynamic> json) {
    listingTitle = json['listing_title'];
    dealName = json['deal_name'];
    couponCode = json['coupon_code'];
    endDate = json['end_date'];
    discountType = json['discount_type'];
    discountValue = json['discount_value'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['listing_title'] = this.listingTitle;
    data['deal_name'] = this.dealName;
    data['coupon_code'] = this.couponCode;
    data['end_date'] = this.endDate;
    data['discount_type'] = this.discountType;
    data['discount_value'] = this.discountValue;
    data['status'] = this.status;
    return data;
  }
}
