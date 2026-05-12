class RequestCartItem {
  String? listingId;
  String? userId;

  RequestCartItem({this.listingId, this.userId});

  RequestCartItem.fromJson(Map<String, dynamic> json) {
    listingId = json['listing_id'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['listing_id'] = this.listingId;
    data['user_id'] = this.userId;
    return data;
  }
}
