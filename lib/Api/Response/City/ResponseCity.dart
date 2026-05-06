class ResponseCity {
  String? result;
  String? message;
  List<Cities>? cities;

  ResponseCity({this.result, this.message, this.cities});

  ResponseCity.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    if (json['cities'] != null) {
      cities = <Cities>[];
      json['cities'].forEach((v) {
        cities!.add(Cities.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['result'] = result;
    data['message'] = message;
    if (cities != null) {
      data['cities'] = cities!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Cities {
  int? id;
  String? name;
  String? slug;
  String? image;
  int? stateId;
  String? longitude;
  String? latitude;
  int? priority;
  int? status;
  String? createdAt;
  String? updatedAt;

  Cities({
    this.id,
    this.name,
    this.slug,
    this.image,
    this.stateId,
    this.longitude,
    this.latitude,
    this.priority,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  Cities.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    image = json['image'];
    stateId = json['state_id'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    priority = json['priority'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['image'] = image;
    data['state_id'] = stateId;
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    data['priority'] = priority;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
