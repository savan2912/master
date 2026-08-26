class RequestEventBookingList {
  String? listingId;

  RequestEventBookingList({this.listingId});

  RequestEventBookingList.fromJson(Map<String, dynamic> json) {
    listingId = json['listing_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['listing_id'] = this.listingId;
    return data;
  }
}
