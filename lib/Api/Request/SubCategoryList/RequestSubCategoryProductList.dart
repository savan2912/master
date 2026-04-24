class RequestSubCategoryProductList {
  int? listingId;
  String? search;
  int? counter;

  RequestSubCategoryProductList({
    this.listingId,
    this.search,
    this.counter,
  });

  RequestSubCategoryProductList.fromJson(Map<String, dynamic> json) {
    listingId = json['listing_id'];
    search = json['search'];
    counter = json['counter'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['listing_id'] = this.listingId;
    data['search'] = this.search;
    data['counter'] = this.counter;
    return data;
  }
}
