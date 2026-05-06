class ResponseProductDetail {
  String? result;
  String? message;
  ProductDetail? data;

  ResponseProductDetail({this.result, this.message, this.data});

  ResponseProductDetail.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    data = json['data'] != null ? new ProductDetail.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ProductDetail {
  String? id;
  String? name;
  String? slug;
  String? thumbnail;
  String? details;
  String? discount;
  String? discountType;
  int? unitPrice;
  String? categoryName;

  ProductDetail(
      {this.id,
        this.name,
        this.slug,
        this.thumbnail,
        this.details,
        this.discount,
        this.discountType,
        this.unitPrice,
        this.categoryName});

  ProductDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    thumbnail = json['thumbnail'];
    details = json['details'];
    discount = json['discount'];
    discountType = json['discount_type'];
    unitPrice = json['unit_price'];
    categoryName = json['category_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['thumbnail'] = this.thumbnail;
    data['details'] = this.details;
    data['discount'] = this.discount;
    data['discount_type'] = this.discountType;
    data['unit_price'] = this.unitPrice;
    data['category_name'] = this.categoryName;
    return data;
  }
}
