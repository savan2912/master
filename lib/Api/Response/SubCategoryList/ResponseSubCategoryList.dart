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
        data!.add(new SubCategoryList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['message'] = this.message;
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

  SubCategoryList(
      {this.id,
        this.title,
        this.listAddress,
        this.rating,
        this.categoryName,
        this.cityName,
        this.imageLink,
        this.isFavourite});

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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['list_address'] = this.listAddress;
    data['rating'] = this.rating;
    data['category_name'] = this.categoryName;
    data['city_name'] = this.cityName;
    data['image_link'] = this.imageLink;
    data['is_favourite'] = this.isFavourite;
    return data;
  }
}
