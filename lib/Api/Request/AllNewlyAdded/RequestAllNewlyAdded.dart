class RequestAllNewlyAdded {
  String? search;
  String? counter;

  RequestAllNewlyAdded({this.search, this.counter});

  RequestAllNewlyAdded.fromJson(Map<String, dynamic> json) {
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
