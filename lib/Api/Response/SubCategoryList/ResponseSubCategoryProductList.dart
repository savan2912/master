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
        data!.add(SubCategoryProductList.fromJson(v));
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

  SubCategoryProductList({
    this.id,
    this.name,
    this.slug,
    this.thumbnail,
    this.discount,
    this.discountType,
    this.unitPrice,
    this.categoryId,
    this.discountedPrice,
    this.redirectionUrl,
    this.seller,
  });

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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['thumbnail'] = thumbnail;
    data['discount'] = discount;
    data['discount_type'] = discountType;
    data['unit_price'] = unitPrice;
    data['category_id'] = categoryId;
    data['discounted_price'] = discountedPrice;
    data['redirection_url'] = redirectionUrl;
    data['seller'] = seller;
    return data;
  }
}
