class RequestUpdateCart {
  String? cartId;
  String? action;
  String? quantity;

  RequestUpdateCart({this.cartId, this.action, this.quantity});

  RequestUpdateCart.fromJson(Map<String, dynamic> json) {
    cartId = json['cart_id'];
    action = json['action'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cart_id'] = this.cartId;
    data['action'] = this.action;
    data['quantity'] = this.quantity;
    return data;
  }
}
