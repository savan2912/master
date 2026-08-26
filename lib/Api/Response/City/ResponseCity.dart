class ResponseCity {
  String? result;
  String? message;
  List<Cities>? cities;

  ResponseCity({
    this.result,
    this.message,
    this.cities,
  });

  ResponseCity.fromJson(Map<String, dynamic> json) {
    result = json['result']?.toString();
    message = json['message']?.toString();

    if (json['cities'] != null && json['cities'] is List) {
      cities = <Cities>[];
      for (var v in json['cities']) {
        cities!.add(Cities.fromJson(v));
      }
    } else {
      cities = [];
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
  dynamic longitude;
  dynamic latitude;
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
    id = json['id'] is int ? json['id'] : int.tryParse(json['id'].toString());
    name = json['name']?.toString();
    slug = json['slug']?.toString();
    image = json['image']?.toString();
    stateId = json['state_id'] is int
        ? json['state_id']
        : int.tryParse(json['state_id'].toString());
    longitude = json['longitude'];
    latitude = json['latitude'];
    priority = json['priority'] is int
        ? json['priority']
        : int.tryParse(json['priority'].toString());
    status = json['status'] is int
        ? json['status']
        : int.tryParse(json['status'].toString());
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'image': image,
      'state_id': stateId,
      'longitude': longitude,
      'latitude': latitude,
      'priority': priority,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}