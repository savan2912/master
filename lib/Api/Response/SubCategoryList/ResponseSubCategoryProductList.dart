class ResponseSubcategoryProductList {
  String? result;
  String? message;
  List<SubCategoryProductList>? data;

  ResponseSubcategoryProductList({this.result, this.message, this.data});

  ResponseSubcategoryProductList.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    if (json['data'] != null) {
      data = <SubCategoryProductList>[];
      json['data'].forEach((v) {
        data!.add(new SubCategoryProductList.fromJson(v));
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

class SubCategoryProductList {
  int? id;
  String? name;
  String? slug;
  String? thumbnail;
  String? discount;
  String? discountType;
  int? unitPrice;
  String? categoryId;
  dynamic discountedPrice;
  String? redirectionUrl;
  dynamic seller;

  SubCategoryProductList(
      {this.id,
        this.name,
        this.slug,
        this.thumbnail,
        this.discount,
        this.discountType,
        this.unitPrice,
        this.categoryId,
        this.discountedPrice,
        this.redirectionUrl,
        this.seller});

  SubCategoryProductList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    thumbnail = json['thumbnail'];
    discount = json['discount'];
    discountType = json['discount_type'];
    unitPrice = json['unit_price'];
    categoryId = json['category_id'];
    discountedPrice = json['discounted_price'];
    redirectionUrl = json['redirection_url'];
    seller = json['seller'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['thumbnail'] = this.thumbnail;
    data['discount'] = this.discount;
    data['discount_type'] = this.discountType;
    data['unit_price'] = this.unitPrice;
    data['category_id'] = this.categoryId;
    data['discounted_price'] = this.discountedPrice;
    data['redirection_url'] = this.redirectionUrl;
    data['seller'] = this.seller;
    return data;
  }
}
