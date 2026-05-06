class ResponseMyOrderDetail {
  String? result;
  String? message;
  MyOrderDetail? data;

  ResponseMyOrderDetail({this.result, this.message, this.data});

  ResponseMyOrderDetail.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    data = json['data'] != null ? new MyOrderDetail.fromJson(json['data']) : null;
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

class MyOrderDetail {
  User? user;
  List<Products>? products;
  String? subtotal;
  String? discount;
  String? tax;
  String? total;
  String? paymentType;
  String? sourceType;

  MyOrderDetail(
      {this.user,
        this.products,
        this.subtotal,
        this.discount,
        this.tax,
        this.total,
        this.paymentType,
        this.sourceType});

  MyOrderDetail.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
    subtotal = json['subtotal'];
    discount = json['discount'];
    tax = json['tax'];
    total = json['total'];
    paymentType = json['payment_type'];
    sourceType = json['source_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    data['subtotal'] = this.subtotal;
    data['discount'] = this.discount;
    data['tax'] = this.tax;
    data['total'] = this.total;
    data['payment_type'] = this.paymentType;
    data['source_type'] = this.sourceType;
    return data;
  }
}

class User {
  String? fName;
  String? lName;
  String? email;
  String? phone;

  User({this.fName, this.lName, this.email, this.phone});

  User.fromJson(Map<String, dynamic> json) {
    fName = json['f_name'];
    lName = json['l_name'];
    email = json['email'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['f_name'] = this.fName;
    data['l_name'] = this.lName;
    data['email'] = this.email;
    data['phone'] = this.phone;
    return data;
  }
}

class Products {
  int? productId;
  String? name;
  int? quantity;
  String? price;
  String? total;
  String? image;

  Products(
      {this.productId,
        this.name,
        this.quantity,
        this.price,
        this.total,
        this.image});

  Products.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    name = json['name'];
    quantity = json['quantity'];
    price = json['price'];
    total = json['total'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['name'] = this.name;
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    data['total'] = this.total;
    data['image'] = this.image;
    return data;
  }
}
