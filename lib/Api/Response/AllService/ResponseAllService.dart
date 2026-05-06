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
        data!.add(AllService.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['result'] = result;
    data['message'] = message;
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

  AllService({
    this.id,
    this.name,
    this.slug,
    this.icon,
    this.serviceImage,
    this.image,
  });

  AllService.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    icon = json['icon'];
    serviceImage = json['service_image'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['icon'] = icon;
    data['service_image'] = serviceImage;
    data['image'] = image;
    return data;
  }
}
