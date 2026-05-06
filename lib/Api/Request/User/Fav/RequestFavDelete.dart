class RequestFavDelete {
  String? userId;
  String? listingId;

  RequestFavDelete({this.userId, this.listingId});

  RequestFavDelete.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    listingId = json['listing_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['listing_id'] = this.listingId;
    return data;
  }
}
