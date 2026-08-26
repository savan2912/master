class RequestBookingCalender {
  String? listingId;
  String? staffId;
  String? serviceIds;
  String? date;

  RequestBookingCalender({this.listingId, this.staffId, this.serviceIds,this.date});

  RequestBookingCalender.fromJson(Map<String, dynamic> json) {
    listingId = json['listing_id'];
    staffId = json['staff_id'];
    serviceIds = json['service_ids'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['listing_id'] = this.listingId;
    data['staff_id'] = this.staffId;
    data['service_ids'] = this.serviceIds;
    data['date'] = this.date;
    return data;
  }
}
