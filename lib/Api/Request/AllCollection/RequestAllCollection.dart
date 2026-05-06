class RequestAllCollection {
  String? search;
  String? counter;

  RequestAllCollection({this.search, this.counter});

  RequestAllCollection.fromJson(Map<String, dynamic> json) {
    search = json['search'];
    counter = json['counter'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['search'] = search;
    data['counter'] = counter;
    return data;
  }
}
