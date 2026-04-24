class RequestSubCategoryList {
  String? search;
  int? counter;
  int? subCategoryId;
  int? cityID;

  RequestSubCategoryList({
    this.search,
    this.counter,
    this.subCategoryId,
    this.cityID
  });

  RequestSubCategoryList.fromJson(Map<String, dynamic> json) {
    search = json['search'];
    counter = json['counter'];
    subCategoryId = json['subcategory_id'];
    cityID = json['city_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['search'] = this.search;
    data['counter'] = this.counter;
    data['city_id'] = this.cityID;
    data['subcategory_id'] = this.subCategoryId;
    return data;
  }
}
