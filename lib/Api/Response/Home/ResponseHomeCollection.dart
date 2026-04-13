class ResponseHomeCollection {
  String? result;
  String? message;
  List<HomeCollection>? data;

  ResponseHomeCollection({this.result, this.message, this.data});

  ResponseHomeCollection.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    if (json['data'] != null) {
      data = <HomeCollection>[];
      json['data'].forEach((v) {
        data!.add(new HomeCollection.fromJson(v));
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

class HomeCollection {
  int? id;
  String? name;
  String? slug;
  String? image;
  String? icon;
  String? bannerImage;
  String? serviceImage;
  Null? parentId;
  int? position;
  int? status;
  int? serviceStatus;
  int? priority;
  String? amenityId;
  String? createdAt;
  String? updatedAt;

  HomeCollection(
      {this.id,
        this.name,
        this.slug,
        this.image,
        this.icon,
        this.bannerImage,
        this.serviceImage,
        this.parentId,
        this.position,
        this.status,
        this.serviceStatus,
        this.priority,
        this.amenityId,
        this.createdAt,
        this.updatedAt});

  HomeCollection.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    image = json['image'];
    icon = json['icon'];
    bannerImage = json['banner_image'];
    serviceImage = json['service_image'];
    parentId = json['parent_id'];
    position = json['position'];
    status = json['status'];
    serviceStatus = json['service_status'];
    priority = json['priority'];
    amenityId = json['amenity_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['image'] = this.image;
    data['icon'] = this.icon;
    data['banner_image'] = this.bannerImage;
    data['service_image'] = this.serviceImage;
    data['parent_id'] = this.parentId;
    data['position'] = this.position;
    data['status'] = this.status;
    data['service_status'] = this.serviceStatus;
    data['priority'] = this.priority;
    data['amenity_id'] = this.amenityId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
