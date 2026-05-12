class ResponseCartItem {
  String? result;
  List<Items>? data;
  String? total;

  ResponseCartItem({this.result, this.data, this.total});

  ResponseCartItem.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    if (json['data'] != null) {
      data = <Items>[];
      json['data'].forEach((v) {
        data!.add(new Items.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    return data;
  }
}

class Items {
  int? id;
  int? userId;
  int? vendorId;
  int? listingId;
  int? productId;
  String? productName;
  String? price;
  int? quantity;
  String? createdAt;
  String? updatedAt;
  String? thumbnail;

  Items(
      {this.id,
        this.userId,
        this.vendorId,
        this.listingId,
        this.productId,
        this.productName,
        this.price,
        this.quantity,
        this.createdAt,
        this.updatedAt,
        this.thumbnail});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    vendorId = json['vendor_id'];
    listingId = json['listing_id'];
    productId = json['product_id'];
    productName = json['product_name'];
    price = json['price'];
    quantity = json['quantity'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    thumbnail = json['thumbnail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['vendor_id'] = this.vendorId;
    data['listing_id'] = this.listingId;
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['thumbnail'] = this.thumbnail;
    return data;
  }
}
