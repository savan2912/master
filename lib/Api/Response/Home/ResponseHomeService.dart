class ResponseHomeService {
  String? result;
  String? message;
  List<HomeService>? data;

  ResponseHomeService({this.result, this.message, this.data});

  ResponseHomeService.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    if (json['data'] != null) {
      data = <HomeService>[];
      json['data'].forEach((v) {
        data!.add(new HomeService.fromJson(v));
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

class HomeService {
  int? id;
  String? name;
  String? slug;
  dynamic icon;
  String? serviceImage;
  String? image;

  HomeService(
      {this.id,
        this.name,
        this.slug,
        this.icon,
        this.serviceImage,
        this.image});

  HomeService.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    icon = json['icon'];
    serviceImage = json['service_image'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['icon'] = this.icon;
    data['service_image'] = this.serviceImage;
    data['image'] = this.image;
    return data;
  }
}
