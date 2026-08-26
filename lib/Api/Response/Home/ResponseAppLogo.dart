class ResponseAppLogo {
  String? result;
  String? message;
  List<AppLogo>? data;

  ResponseAppLogo({this.result, this.message, this.data});

  ResponseAppLogo.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    if (json['data'] != null) {
      data = <AppLogo>[];
      json['data'].forEach((v) {
        data!.add(new AppLogo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AppLogo {
  int? id;
  String? name;
  String? logo;
  int? status;

  AppLogo({this.id, this.name, this.logo, this.status});

  AppLogo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    logo = json['logo'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['logo'] = this.logo;
    data['status'] = this.status;
    return data;
  }
}
