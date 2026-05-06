class ResponseSearchData {
  String? result;
  String? message;
  List<SearchData>? data;

  ResponseSearchData({this.result, this.message, this.data});

  ResponseSearchData.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    if (json['data'] != null) {
      data = <SearchData>[];
      json['data'].forEach((v) {
        data!.add(SearchData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['result'] = result;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SearchData {
  int? listingId;
  String? categoryName;
  String? listingTitle;
  String? imageUrl;

  SearchData({
    this.listingId,
    this.categoryName,
    this.listingTitle,
    this.imageUrl,
  });

  SearchData.fromJson(Map<String, dynamic> json) {
    listingId = json['listing_id'];
    categoryName = json['category_name'];
    listingTitle = json['listing_title'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['listing_id'] = listingId;
    data['category_name'] = categoryName;
    data['listing_title'] = listingTitle;
    data['image_url'] = imageUrl;
    return data;
  }
}
