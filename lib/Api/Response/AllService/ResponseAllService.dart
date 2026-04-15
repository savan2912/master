class ResponseAllService {
  String? result;
  String? message;
  List<AllService>? data;

  ResponseAllService({this.result, this.message, this.data});

  ResponseAllService.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    if (json['data'] != null) {
      data = <AllService>[];
      json['data'].forEach((v) {
        data!.add(new AllService.fromJson(v));
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

class AllService {
  int? id;
  String? name;
  String? slug;
  String? icon;
  String? serviceImage;
  String? image;

  AllService(
      {this.id,
        this.name,
        this.slug,
        this.icon,
        this.serviceImage,
        this.image});

  AllService.fromJson(Map<String, dynamic> json) {
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
