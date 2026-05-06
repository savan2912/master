class RequestAllService {
  String? search;
  String? counter;

  RequestAllService({this.search, this.counter});

  RequestAllService.fromJson(Map<String, dynamic> json) {
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
