class RequestCollectionDetail {
  int? categoryId;

  RequestCollectionDetail({this.categoryId});

  RequestCollectionDetail.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category_id'] = categoryId;
    return data;
  }
}
