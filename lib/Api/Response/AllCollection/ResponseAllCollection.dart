class ResponseAllCollection {
  String? result;
  String? message;
  List<AllCollectionData>? data;

  ResponseAllCollection({this.result, this.message, this.data});

  ResponseAllCollection.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    if (json['data'] != null) {
      data = <AllCollectionData>[];
      json['data'].forEach((v) {
        data!.add(AllCollectionData.fromJson(v));
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

class AllCollectionData {
  int? id;
  String? name;
  String? image;
  String? icon;
  String? bannerImage;
  String? serviceImage;

  AllCollectionData({
    this.id,
    this.name,
    this.image,
    this.icon,
    this.bannerImage,
    this.serviceImage,
  });

  AllCollectionData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    icon = json['icon'];
    bannerImage = json['banner_image'];
    serviceImage = json['service_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['icon'] = icon;
    data['banner_image'] = bannerImage;
    data['service_image'] = serviceImage;
    return data;
  }
}
