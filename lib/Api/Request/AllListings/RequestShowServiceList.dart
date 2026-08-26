class RequestShowServiceList {
  String? listingId;
  String? staffId;
  String? serviceIds;
  String? date;
  String? slotFrom;
  String? slotTo;

  RequestShowServiceList(
      {this.listingId,
        this.staffId,
        this.serviceIds,
        this.date,
        this.slotFrom,
        this.slotTo});

  RequestShowServiceList.fromJson(Map<String, dynamic> json) {
    listingId = json['listing_id'];
    staffId = json['staff_id'];
    serviceIds = json['service_ids'];
    date = json['date'];
    slotFrom = json['slot_from'];
    slotTo = json['slot_to'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['listing_id'] = this.listingId;
    data['staff_id'] = this.staffId;
    data['service_ids'] = this.serviceIds;
    data['date'] = this.date;
    data['slot_from'] = this.slotFrom;
    data['slot_to'] = this.slotTo;
    return data;
  }
}
