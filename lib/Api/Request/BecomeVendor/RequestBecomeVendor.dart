class RequestBecomeVendor {
  String? name;
  String? email;
  String? phone;

  RequestBecomeVendor({this.name, this.email, this.phone});

  RequestBecomeVendor.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    return data;
  }
}
