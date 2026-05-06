class ResponseBilling {
  String? result;
  String? message;
  List<UserBilling>? data;

  ResponseBilling({this.result, this.message, this.data});

  ResponseBilling.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    if (json['data'] != null) {
      data = <UserBilling>[];
      json['data'].forEach((v) {
        data!.add(new UserBilling.fromJson(v));
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

class UserBilling {
  String? billDate;
  String? listingTitle;
  String? paymentMode;
  String? paidAmount;
  int? action;

  UserBilling(
      {this.billDate,
        this.listingTitle,
        this.paymentMode,
        this.paidAmount,
        this.action});

  UserBilling.fromJson(Map<String, dynamic> json) {
    billDate = json['bill_date'];
    listingTitle = json['listing_title'];
    paymentMode = json['payment_mode'];
    paidAmount = json['paid_amount'];
    action = json['action'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bill_date'] = this.billDate;
    data['listing_title'] = this.listingTitle;
    data['payment_mode'] = this.paymentMode;
    data['paid_amount'] = this.paidAmount;
    data['action'] = this.action;
    return data;
  }
}
