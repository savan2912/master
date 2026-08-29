class ResponseEventBookingItem {
  String? result;
  String? message;
  EventBookingItem? data;

  ResponseEventBookingItem({this.result, this.message, this.data});

  ResponseEventBookingItem.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    data = json['data'] != null ? new EventBookingItem.fromJson(json['data']) : null;
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

class EventBookingItem {
  String? eventId;
  dynamic eventBookingNumber;
  List<Items>? items;
  PaymentSummary? paymentSummary;

  EventBookingItem(
      {this.eventId, this.eventBookingNumber, this.items, this.paymentSummary});

  EventBookingItem.fromJson(Map<String, dynamic> json) {
    eventId = json['event_id'];
    eventBookingNumber = json['event_booking_number'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
    paymentSummary = json['payment_summary'] != null
        ? new PaymentSummary.fromJson(json['payment_summary'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['event_id'] = this.eventId;
    data['event_booking_number'] = this.eventBookingNumber;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    if (this.paymentSummary != null) {
      data['payment_summary'] = this.paymentSummary!.toJson();
    }
    return data;
  }
}

class Items {
  String? eventName;
  String? categoryName;
  String? slotName;
  int? quantity;
  int? price;
  int? total;

  Items(
      {this.eventName,
        this.categoryName,
        this.slotName,
        this.quantity,
        this.price,
        this.total});

  Items.fromJson(Map<String, dynamic> json) {
    eventName = json['event_name'];
    categoryName = json['category_name'];
    slotName = json['slot_name'];
    quantity = json['quantity'];
    price = json['price'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['event_name'] = this.eventName;
    data['category_name'] = this.categoryName;
    data['slot_name'] = this.slotName;
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    data['total'] = this.total;
    return data;
  }
}

class PaymentSummary {
  int? subtotal;
  int? gstRate;
  int? gstAmount;
  int? totalAmount;

  PaymentSummary(
      {this.subtotal, this.gstRate, this.gstAmount, this.totalAmount});

  PaymentSummary.fromJson(Map<String, dynamic> json) {
    subtotal = json['subtotal'];
    gstRate = json['gst_rate'];
    gstAmount = json['gst_amount'];
    totalAmount = json['total_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subtotal'] = this.subtotal;
    data['gst_rate'] = this.gstRate;
    data['gst_amount'] = this.gstAmount;
    data['total_amount'] = this.totalAmount;
    return data;
  }
}
