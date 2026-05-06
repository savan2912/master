class RequestEditAddress {
  String? addressId;
  String? userId;
  String? address;
  String? latitude;
  String? longitude;
  String? pincode;

  RequestEditAddress(
      {this.addressId,
        this.userId,
        this.address,
        this.latitude,
        this.longitude,
        this.pincode});

  RequestEditAddress.fromJson(Map<String, dynamic> json) {
    addressId = json['address_id'];
    userId = json['user_id'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    pincode = json['pincode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address_id'] = this.addressId;
    data['user_id'] = this.userId;
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['pincode'] = this.pincode;
    return data;
  }
}
