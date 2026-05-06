class RequestCollectionProductListings {
  int? categoryId;
  int? cityId;

  RequestCollectionProductListings({this.categoryId, this.cityId});

  RequestCollectionProductListings.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    cityId = json['city_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category_id'] = categoryId;
    data['city_id'] = cityId;
    return data;
  }
}
