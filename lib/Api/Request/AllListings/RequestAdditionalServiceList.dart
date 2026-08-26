class RequestAdditionalServiceList {
  String? listingId;
  String? staffId;

  RequestAdditionalServiceList({this.listingId, this.staffId});

  RequestAdditionalServiceList.fromJson(Map<String, dynamic> json) {
    listingId = json['listing_id'];
    staffId = json['staff_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['listing_id'] = this.listingId;
    data['staff_id'] = this.staffId;
    return data;
  }
}
