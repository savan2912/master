
class RequestAddCart {
  String? userId;
  int? listingId;
  int? productId;
  String? productName;
  int? productPrice;
  int? quantity;

  RequestAddCart(
      {this.userId,
        this.listingId,
        this.productId,
        this.productName,
        this.productPrice,
        this.quantity});

  RequestAddCart.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    listingId = json['listing_id'];
    productId = json['productId'];
    productName = json['productName'];
    productPrice = json['productPrice'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['listing_id'] = this.listingId;
    data['productId'] = this.productId;
    data['productName'] = this.productName;
    data['productPrice'] = this.productPrice;
    data['quantity'] = this.quantity;
    return data;
  }
}
