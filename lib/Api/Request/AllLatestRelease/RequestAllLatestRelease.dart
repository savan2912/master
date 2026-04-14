class RequestAllLatestRelease {
  String? search;
  String? counter;

  RequestAllLatestRelease({this.search, this.counter});

  RequestAllLatestRelease.fromJson(Map<String, dynamic> json) {
    search = json['search'];
    counter = json['counter'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['search'] = this.search;
    data['counter'] = this.counter;
    return data;
  }
}
