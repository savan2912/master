class ResponseProfile {
  String? result;
  String? message;
  ProfileData? data;

  ResponseProfile({this.result, this.message, this.data});

  ResponseProfile.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    data = json['data'] != null ? new ProfileData.fromJson(json['data']) : null;
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

class ProfileData {
  int? id;
  String? fName;
  String? lName;
  String? email;
  String? mobile;
  String? createdAt;
  String? image;

  ProfileData(
      {this.id,
        this.fName,
        this.lName,
        this.email,
        this.mobile,
        this.createdAt,
        this.image});

  ProfileData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fName = json['f_name'];
    lName = json['l_name'];
    email = json['email'];
    mobile = json['mobile'];
    createdAt = json['created_at'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['f_name'] = this.fName;
    data['l_name'] = this.lName;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['created_at'] = this.createdAt;
    data['image'] = this.image;
    return data;
  }
}
