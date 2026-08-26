class ResponseShowServiceList {
  String? result;
  String? message;
  ShowServiceList? data;

  ResponseShowServiceList({this.result, this.message, this.data});

  ResponseShowServiceList.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    data = json['data'] != null ? new ShowServiceList.fromJson(json['data']) : null;
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

class ShowServiceList {
  List<Services>? services;
  int? totalMinutes;
  int? totalPrice;
  String? date;
  Slot? slot;

  ShowServiceList(
      {this.services,
        this.totalMinutes,
        this.totalPrice,
        this.date,
        this.slot});

  ShowServiceList.fromJson(Map<String, dynamic> json) {
    if (json['services'] != null) {
      services = <Services>[];
      json['services'].forEach((v) {
        services!.add(new Services.fromJson(v));
      });
    }
    totalMinutes = json['total_minutes'];
    totalPrice = json['total_price'];
    date = json['date'];
    slot = json['slot'] != null ? new Slot.fromJson(json['slot']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.services != null) {
      data['services'] = this.services!.map((v) => v.toJson()).toList();
    }
    data['total_minutes'] = this.totalMinutes;
    data['total_price'] = this.totalPrice;
    data['date'] = this.date;
    if (this.slot != null) {
      data['slot'] = this.slot!.toJson();
    }
    return data;
  }
}

class Services {
  String? id;
  String? name;
  int? minutes;
  int? price;
  String? durationRaw;

  Services({this.id, this.name, this.minutes, this.price, this.durationRaw});

  Services.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    minutes = json['minutes'];
    price = json['price'];
    durationRaw = json['duration_raw'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['minutes'] = this.minutes;
    data['price'] = this.price;
    data['duration_raw'] = this.durationRaw;
    return data;
  }
}

class Slot {
  String? from;
  String? to;
  String? staffServiceId;
  String? staffServiceName;
  int? staffServicePrice;
  String? staffServiceDuration;

  Slot(
      {this.from,
        this.to,
        this.staffServiceId,
        this.staffServiceName,
        this.staffServicePrice,
        this.staffServiceDuration});

  Slot.fromJson(Map<String, dynamic> json) {
    from = json['from'];
    to = json['to'];
    staffServiceId = json['staff_service_id'];
    staffServiceName = json['staff_service_name'];
    staffServicePrice = json['staff_service_price'];
    staffServiceDuration = json['staff_service_duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['from'] = this.from;
    data['to'] = this.to;
    data['staff_service_id'] = this.staffServiceId;
    data['staff_service_name'] = this.staffServiceName;
    data['staff_service_price'] = this.staffServicePrice;
    data['staff_service_duration'] = this.staffServiceDuration;
    return data;
  }
}
