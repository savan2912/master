class RequestAllDeals {
  String? search;
  String? counter;
  String? latitude;
  String? longitude;

  RequestAllDeals({this.search, this.counter,this.latitude,this.longitude});

  RequestAllDeals.fromJson(Map<String, dynamic> json) {
    search = json['search'];
    counter = json['counter'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['search'] = this.search;
    data['counter'] = this.counter;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}
