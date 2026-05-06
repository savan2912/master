class ResponseMyOrder {
  String? result;
  String? message;
  List<MyOrder>? data;

  ResponseMyOrder({this.result, this.message, this.data});

  ResponseMyOrder.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    if (json['data'] != null) {
      data = <MyOrder>[];
      json['data'].forEach((v) {
        data!.add(new MyOrder.fromJson(v));
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

class MyOrder {
  String? tokenNumber;
  String? orderDate;
  int? totalItems;
  int? totalAmount;
  String? paymentType;
  String? status;
  String? listingTitle;
  String? pincode;
  String? address;

  MyOrder(
      {this.tokenNumber,
        this.orderDate,
        this.totalItems,
        this.totalAmount,
        this.paymentType,
        this.status,
        this.listingTitle,
        this.pincode,
        this.address});

  MyOrder.fromJson(Map<String, dynamic> json) {
    tokenNumber = json['token_number'];
    orderDate = json['order_date'];
    totalItems = json['total_items'];
    totalAmount = json['total_amount'];
    paymentType = json['payment_type'];
    status = json['status'];
    listingTitle = json['listing_title'];
    pincode = json['pincode'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token_number'] = this.tokenNumber;
    data['order_date'] = this.orderDate;
    data['total_items'] = this.totalItems;
    data['total_amount'] = this.totalAmount;
    data['payment_type'] = this.paymentType;
    data['status'] = this.status;
    data['listing_title'] = this.listingTitle;
    data['pincode'] = this.pincode;
    data['address'] = this.address;
    return data;
  }
}
