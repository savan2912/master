class RequestSubCategoryProductList {
  int? listingId;
  String? search;
  int? counter;

  RequestSubCategoryProductList({this.listingId, this.search, this.counter});

  RequestSubCategoryProductList.fromJson(Map<String, dynamic> json) {
    listingId = json['listing_id'];
    search = json['search'];
    counter = json['counter'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['listing_id'] = listingId;
    data['search'] = search;
    data['counter'] = counter;
    return data;
  }
}
