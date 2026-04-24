class RequestAllListings {
  int? locationid;
  int? categoryid;
  int? counter;
  String? search;

  RequestAllListings({this.locationid, this.categoryid,this.counter,this.search});

  RequestAllListings.fromJson(Map<String, dynamic> json) {
    locationid = json['location_id'];
    categoryid = json['category_id'];
    counter = json['counter'];
    search = json['search'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['location_id'] = this.locationid;
    data['category_id'] = this.categoryid;
    data['counter'] = this.counter;
    data['search'] = this.search;
    return data;
  }
}
