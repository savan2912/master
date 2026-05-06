class ResponseSubCategoryList {
  String? result;
  String? message;
  List<SubCategoryList>? data;

  ResponseSubCategoryList({this.result, this.message, this.data});

  ResponseSubCategoryList.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    if (json['data'] != null) {
      data = <SubCategoryList>[];
      json['data'].forEach((v) {
        data!.add(SubCategoryList.fromJson(v));
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

class SubCategoryList {
  int? id;
  String? title;
  String? listAddress;
  String? rating;
  String? categoryName;
  String? cityName;
  String? imageLink;
  int? isFavourite;

  SubCategoryList({
    this.id,
    this.title,
    this.listAddress,
    this.rating,
    this.categoryName,
    this.cityName,
    this.imageLink,
    this.isFavourite,
  });

  SubCategoryList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    listAddress = json['list_address'];
    rating = json['rating'];
    categoryName = json['category_name'];
    cityName = json['city_name'];
    imageLink = json['image_link'];
    isFavourite = json['is_favourite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['list_address'] = listAddress;
    data['rating'] = rating;
    data['category_name'] = categoryName;
    data['city_name'] = cityName;
    data['image_link'] = imageLink;
    data['is_favourite'] = isFavourite;
    return data;
  }
}
