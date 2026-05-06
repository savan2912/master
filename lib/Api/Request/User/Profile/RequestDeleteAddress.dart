class RequestDeleteAddress {
  String? addressId;
  String? userId;

  RequestDeleteAddress({this.addressId, this.userId});

  RequestDeleteAddress.fromJson(Map<String, dynamic> json) {
    addressId = json['address_id'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address_id'] = this.addressId;
    data['user_id'] = this.userId;
    return data;
  }
}
