class RequestRegister {
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? password;
  String? confirmPassword;
  String? role;
  int? terms;

  RequestRegister({
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.password,
    this.terms,
    this.confirmPassword,
    this.role
  });

  RequestRegister.fromJson(Map<String, dynamic> json) {
    firstName = json['f_name'];
    lastName = json['l_name'];
    email = json['email'];
    phone = json['phone'];
    password = json['password'];
    role = json['role'];
    terms = json['terms'];
    confirmPassword = json['confirm_password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['f_name'] = this.firstName;
    data['l_name'] = this.lastName;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['password'] = this.password;
    data['role'] = this.role;
    data['terms'] = this.terms;
    data['confirm_password'] = this.confirmPassword;
    return data;
  }
}
