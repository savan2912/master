class RequestPointDetail {
  String? userId;
  String? listingId;
  String? search;
  String? counter;

  RequestPointDetail({this.userId, this.listingId, this.search, this.counter});

  RequestPointDetail.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    listingId = json['listing_id'];
    search = json['search'];
    counter = json['counter'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['listing_id'] = this.listingId;
    data['search'] = this.search;
    data['counter'] = this.counter;
    return data;
  }
}
