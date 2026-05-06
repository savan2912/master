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
        data!.add(HomeCollection.fromJson(v));
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

class HomeCollection {
  int? id;
  String? name;
  String? slug;
  String? image;
  String? icon;
  String? bannerImage;
  String? serviceImage;
  Null parentId;
  int? position;
  int? status;
  int? serviceStatus;
  int? priority;
  String? amenityId;
  String? createdAt;
  String? updatedAt;

  HomeCollection({
    this.id,
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
    this.updatedAt,
  });

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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['image'] = image;
    data['icon'] = icon;
    data['banner_image'] = bannerImage;
    data['service_image'] = serviceImage;
    data['parent_id'] = parentId;
    data['position'] = position;
    data['status'] = status;
    data['service_status'] = serviceStatus;
    data['priority'] = priority;
    data['amenity_id'] = amenityId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
