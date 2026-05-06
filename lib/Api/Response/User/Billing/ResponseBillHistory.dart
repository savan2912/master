class ResponseBillHistory {
  String? result;
  String? message;
  BillHistory? data;

  ResponseBillHistory({this.result, this.message, this.data});

  ResponseBillHistory.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    data = json['data'] != null ? new BillHistory.fromJson(json['data']) : null;
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

class BillHistory {
  String? username;
  String? dealname;
  String? rewardTitle;
  // String? tags;
  String? subtotal;
  String? discount;
  String? tax;
  String? paymentType;
  String? total;
  String? product;

  BillHistory(
      {this.username,
        this.dealname,
        this.rewardTitle,
        // this.tags,
        this.subtotal,
        this.discount,
        this.tax,
        this.paymentType,
        this.total,
        this.product
      });

  BillHistory.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    dealname = json['dealname'];
    rewardTitle = json['reward_title'];
    // tags = json['tags'];
    subtotal = json['subtotal'];
    discount = json['discount'];
    tax = json['tax'];
    paymentType = json['payment_type'];
    total = json['total'];
    product = json['product'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['dealname'] = this.dealname;
    data['reward_title'] = this.rewardTitle;
    // data['tags'] = this.tags;
    data['subtotal'] = this.subtotal;
    data['discount'] = this.discount;
    data['tax'] = this.tax;
    data['payment_type'] = this.paymentType;
    data['total'] = this.total;
    data['product'] = this.product;
    return data;
  }
}
