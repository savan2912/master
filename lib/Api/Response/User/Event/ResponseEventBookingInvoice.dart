class ResponseEventBookingInvoice {
  String? result;
  String? message;
  EventBookingInvoice? data;

  ResponseEventBookingInvoice({this.result, this.message, this.data});

  ResponseEventBookingInvoice.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    data = json['data'] != null ? new EventBookingInvoice.fromJson(json['data']) : null;
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

class EventBookingInvoice {
  Event? event;
  Receipt? receipt;
  List<Items>? items;
  FinancialTotals? financialTotals;

  EventBookingInvoice({this.event, this.receipt, this.items, this.financialTotals});

  EventBookingInvoice.fromJson(Map<String, dynamic> json) {
    event = json['event'] != null ? new Event.fromJson(json['event']) : null;
    receipt =
    json['receipt'] != null ? new Receipt.fromJson(json['receipt']) : null;
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
    financialTotals = json['financial_totals'] != null
        ? new FinancialTotals.fromJson(json['financial_totals'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.event != null) {
      data['event'] = this.event!.toJson();
    }
    if (this.receipt != null) {
      data['receipt'] = this.receipt!.toJson();
    }
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    if (this.financialTotals != null) {
      data['financial_totals'] = this.financialTotals!.toJson();
    }
    return data;
  }
}

class Event {
  String? title;
  String? address;
  String? eventDate;
  String? eventTime;

  Event({this.title, this.address, this.eventDate, this.eventTime});

  Event.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    address = json['address'];
    eventDate = json['event_date'];
    eventTime = json['event_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['address'] = this.address;
    data['event_date'] = this.eventDate;
    data['event_time'] = this.eventTime;
    return data;
  }
}

class Receipt {
  dynamic receiptNo;
  String? bookingDate;
  String? bookingTime;
  String? userName;

  Receipt({this.receiptNo, this.bookingDate, this.bookingTime, this.userName});

  Receipt.fromJson(Map<String, dynamic> json) {
    receiptNo = json['receipt_no'];
    bookingDate = json['booking_date'];
    bookingTime = json['booking_time'];
    userName = json['user_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['receipt_no'] = this.receiptNo;
    data['booking_date'] = this.bookingDate;
    data['booking_time'] = this.bookingTime;
    data['user_name'] = this.userName;
    return data;
  }
}

class Items {
  String? categoryName;
  String? slotName;
  int? quantity;
  int? price;
  int? total;

  Items(
      {this.categoryName,
        this.slotName,
        this.quantity,
        this.price,
        this.total});

  Items.fromJson(Map<String, dynamic> json) {
    categoryName = json['category_name'];
    slotName = json['slot_name'];
    quantity = json['quantity'];
    price = json['price'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_name'] = this.categoryName;
    data['slot_name'] = this.slotName;
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    data['total'] = this.total;
    return data;
  }
}

class FinancialTotals {
  int? subtotal;
  int? gstRate;
  int? gstAmount;
  int? total;

  FinancialTotals({this.subtotal, this.gstRate, this.gstAmount, this.total});

  FinancialTotals.fromJson(Map<String, dynamic> json) {
    subtotal = json['subtotal'];
    gstRate = json['gst_rate'];
    gstAmount = json['gst_amount'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subtotal'] = this.subtotal;
    data['gst_rate'] = this.gstRate;
    data['gst_amount'] = this.gstAmount;
    data['total'] = this.total;
    return data;
  }
}
