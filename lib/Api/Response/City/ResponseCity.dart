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
        cities!.add(new Cities.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['message'] = this.message;
    if (this.cities != null) {
      data['cities'] = this.cities!.map((v) => v.toJson()).toList();
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

  Cities(
      {this.id,
        this.name,
        this.slug,
        this.image,
        this.stateId,
        this.longitude,
        this.latitude,
        this.priority,
        this.status,
        this.createdAt,
        this.updatedAt});

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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['image'] = this.image;
    data['state_id'] = this.stateId;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['priority'] = this.priority;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
