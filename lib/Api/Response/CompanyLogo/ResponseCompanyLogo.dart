class ResponseCompanyLogo {
  String? result;
  String? message;
  CompanyLogo? data;

  ResponseCompanyLogo({this.result, this.message, this.data});

  ResponseCompanyLogo.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    data = json['data'] != null ? CompanyLogo.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['result'] = result;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class CompanyLogo {
  String? siteLogo;
  String? logoSmall;

  CompanyLogo({this.siteLogo, this.logoSmall});

  CompanyLogo.fromJson(Map<String, dynamic> json) {
    siteLogo = json['site_logo'];
    logoSmall = json['logo_small'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['site_logo'] = siteLogo;
    data['logo_small'] = logoSmall;
    return data;
  }
}
