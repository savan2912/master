class RequestBlogs {
  int? counter;

  RequestBlogs({
    this.counter,
  });

  RequestBlogs.fromJson(Map<String, dynamic> json) {
    counter = json['counter'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['counter'] = this.counter;
    return data;
  }
}
