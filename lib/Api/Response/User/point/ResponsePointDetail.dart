class ResponsePointDetail {
  String? result;
  String? message;
  List<PointDetail>? data;

  ResponsePointDetail({this.result, this.message, this.data});

  ResponsePointDetail.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    if (json['data'] != null) {
      data = <PointDetail>[];
      json['data'].forEach((v) {
        data!.add(new PointDetail.fromJson(v));
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

class PointDetail {
  String? date;
  String? listingName;
  String? paidAmount;
  int? earnedPoints;
  int? redeemedPoints;
  String? rewardTitle;
  String? rewardDiscount;
  int? billId;

  PointDetail(
      {
        this.date,
        this.listingName,
        this.paidAmount,
        this.earnedPoints,
        this.redeemedPoints,
        this.rewardTitle,
        this.rewardDiscount,
        this.billId
      });

  PointDetail.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    listingName = json['listing_name'];
    paidAmount = json['paid_amount'];
    earnedPoints = json['earned_points'];
    redeemedPoints = json['redeemed_points'];
    rewardTitle = json['reward_title'];
    rewardDiscount = json['reward_discount'];
    billId = json['bill_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['listing_name'] = this.listingName;
    data['paid_amount'] = this.paidAmount;
    data['earned_points'] = this.earnedPoints;
    data['redeemed_points'] = this.redeemedPoints;
    data['reward_title'] = this.rewardTitle;
    data['reward_discount'] = this.rewardDiscount;
    data['bill_id'] = this.billId;
    return data;
  }
}
