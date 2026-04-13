class ResponseBanner {
  String? result;
  String? message;
  List<BannerData>? data;

  ResponseBanner({this.result, this.message, this.data});

  ResponseBanner.fromJson(Map<String, dynamic> json) {
    result = json['result']?.toString();
    message = json['message']?.toString();

    if (json['data'] != null && json['data'] is List) {
      data = [];
      for (var v in json['data']) {
        data!.add(BannerData.fromJson(v));
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> dataMap = {};
    dataMap['result'] = result;
    dataMap['message'] = message;

    if (data != null) {
      dataMap['data'] = data!.map((v) => v.toJson()).toList();
    }

    return dataMap;
  }
}

class BannerData {
  int? id;
  String? type;
  int? status;
  String? image;
  String? createdAt;
  String? updatedAt;

  BannerData({
    this.id,
    this.type,
    this.status,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  BannerData.fromJson(Map<String, dynamic> json) {
    id = json['id'] is int
        ? json['id']
        : int.tryParse(json['id']?.toString() ?? '');

    type = json['type']?.toString();

    status = json['status'] is int
        ? json['status']
        : int.tryParse(json['status']?.toString() ?? '');

    image = json['image']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> dataMap = {};
    dataMap['id'] = id;
    dataMap['type'] = type;
    dataMap['status'] = status;
    dataMap['image'] = image;
    dataMap['created_at'] = createdAt;
    dataMap['updated_at'] = updatedAt;

    return dataMap;
  }
}