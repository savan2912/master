class RequestSubCategoryList {
  String? search;
  int? counter;
  int? subCategoryId;
  int? cityID;

  RequestSubCategoryList({
    this.search,
    this.counter,
    this.subCategoryId,
    this.cityID,
  });

  RequestSubCategoryList.fromJson(Map<String, dynamic> json) {
    search = json['search'];
    counter = json['counter'];
    subCategoryId = json['subcategory_id'];
    cityID = json['city_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['search'] = search;
    data['counter'] = counter;
    data['city_id'] = cityID;
    data['subcategory_id'] = subCategoryId;
    return data;
  }
}
