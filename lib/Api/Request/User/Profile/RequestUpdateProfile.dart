class RequestUpdateProfile {
  int? id;
  String? fName;
  String? lName;
  String? email;
  String? phone;

  RequestUpdateProfile(
      {this.id, this.fName, this.lName, this.email, this.phone});

  RequestUpdateProfile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fName = json['f_name'];
    lName = json['l_name'];
    email = json['email'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['f_name'] = this.fName;
    data['l_name'] = this.lName;
    data['email'] = this.email;
    data['phone'] = this.phone;
    return data;
  }
}
