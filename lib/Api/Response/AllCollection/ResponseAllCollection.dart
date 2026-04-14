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
        data!.add(new AllCollectionData.fromJson(v));
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

class AllCollectionData {
  int? id;
  String? name;
  String? image;
  String? icon;
  String? bannerImage;
  String? serviceImage;

  AllCollectionData(
      {this.id,
        this.name,
        this.image,
        this.icon,
        this.bannerImage,
        this.serviceImage});

  AllCollectionData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    icon = json['icon'];
    bannerImage = json['banner_image'];
    serviceImage = json['service_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['icon'] = this.icon;
    data['banner_image'] = this.bannerImage;
    data['service_image'] = this.serviceImage;
    return data;
  }
}
