class RequestPlaceOrder {
  String? userId;
  String? address;
  String? listingId;

  RequestPlaceOrder({this.userId, this.address, this.listingId});

  RequestPlaceOrder.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    address = json['address'];
    listingId = json['listing_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['address'] = this.address;
    data['listing_id'] = this.listingId;
    return data;
  }
}
