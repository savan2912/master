class RequestReserveBook {
  String? userId;
  int? listingId;
  String? checkin;
  String? checkout;
  int? adults;
  int? childs;

  RequestReserveBook(
      {this.userId,
        this.listingId,
        this.checkin,
        this.checkout,
        this.adults,
        this.childs});

  RequestReserveBook.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    listingId = json['listing_id'];
    checkin = json['checkin'];
    checkout = json['checkout'];
    adults = json['adults'];
    childs = json['childs'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['listing_id'] = this.listingId;
    data['checkin'] = this.checkin;
    data['checkout'] = this.checkout;
    data['adults'] = this.adults;
    data['childs'] = this.childs;
    return data;
  }
}
