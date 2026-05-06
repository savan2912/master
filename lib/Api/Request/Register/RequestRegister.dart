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
    this.role,
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['f_name'] = firstName;
    data['l_name'] = lastName;
    data['email'] = email;
    data['phone'] = phone;
    data['password'] = password;
    data['role'] = role;
    data['terms'] = terms;
    data['confirm_password'] = confirmPassword;
    return data;
  }
}
