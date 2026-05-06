class RequestBlogs {
  int? counter;

  RequestBlogs({this.counter});

  RequestBlogs.fromJson(Map<String, dynamic> json) {
    counter = json['counter'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['counter'] = counter;
    return data;
  }
}
