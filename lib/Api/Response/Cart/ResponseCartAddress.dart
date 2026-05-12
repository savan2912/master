class ResponseCartAddress {
  String? result;
  List<CartAddress>? data;

  ResponseCartAddress({this.result, this.data});

  ResponseCartAddress.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    if (json['data'] != null) {
      data = <CartAddress>[];
      json['data'].forEach((v) {
        data!.add(new CartAddress.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CartAddress {
  int? id;
  String? addressLine;
  String? city;
  String? pincode;
  String? type;

  CartAddress({this.id, this.addressLine, this.city, this.pincode, this.type});

  CartAddress.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    addressLine = json['address_line'];
    city = json['city'];
    pincode = json['pincode'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['address_line'] = this.addressLine;
    data['city'] = this.city;
    data['pincode'] = this.pincode;
    data['type'] = this.type;
    return data;
  }
}
