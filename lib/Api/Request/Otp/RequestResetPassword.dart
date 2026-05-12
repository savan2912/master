
class RequestResetPassword {
  String? phone;
  String? password;
  String? passwordConfirmation;

  RequestResetPassword({this.phone, this.password, this.passwordConfirmation});

  RequestResetPassword.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
    password = json['password'];
    passwordConfirmation = json['password_confirmation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phone'] = this.phone;
    data['password'] = this.password;
    data['password_confirmation'] = this.passwordConfirmation;
    return data;
  }
}
