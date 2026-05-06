class RequestAllDeals {
  String? search;
  String? counter;
  String? latitude;
  String? longitude;

  RequestAllDeals({this.search, this.counter, this.latitude, this.longitude});

  RequestAllDeals.fromJson(Map<String, dynamic> json) {
    search = json['search'];
    counter = json['counter'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['search'] = search;
    data['counter'] = counter;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}
