class RequestSearch {
  String? search;

  RequestSearch({this.search});

  RequestSearch.fromJson(Map<String, dynamic> json) {
    search = json['search'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['search'] = search;
    return data;
  }
}
