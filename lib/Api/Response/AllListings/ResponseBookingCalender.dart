class ResponseBookingCalender {
  String? result;
  String? message;
  List<Slots>? slots;

  ResponseBookingCalender({this.result, this.message, this.slots});

  ResponseBookingCalender.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    if (json['slots'] != null) {
      slots = <Slots>[];
      json['slots'].forEach((v) {
        slots!.add(new Slots.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['message'] = this.message;
    if (this.slots != null) {
      data['slots'] = this.slots!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Slots {
  String? from;
  String? to;
  bool? isFull;
  bool? isCustom;
  int? serviceId;
  String? serviceName;
  String? price;
  String? durationInfo;

  Slots(
      {this.from,
        this.to,
        this.isFull,
        this.isCustom,
        this.serviceId,
        this.serviceName,
        this.price,
        this.durationInfo});

  Slots.fromJson(Map<String, dynamic> json) {
    from = json['from'];
    to = json['to'];
    isFull = json['is_full'];
    isCustom = json['is_custom'];
    serviceId = json['service_id'];
    serviceName = json['service_name'];
    price = json['price'];
    durationInfo = json['duration_info'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['from'] = this.from;
    data['to'] = this.to;
    data['is_full'] = this.isFull;
    data['is_custom'] = this.isCustom;
    data['service_id'] = this.serviceId;
    data['service_name'] = this.serviceName;
    data['price'] = this.price;
    data['duration_info'] = this.durationInfo;
    return data;
  }
}
