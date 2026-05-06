class ResponseAllListing {
  String? result;
  String? message;
  List<AllListingsData>? data;

  ResponseAllListing({this.result, this.message, this.data});

  ResponseAllListing.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    if (json['data'] != null) {
      data = <AllListingsData>[];
      json['data'].forEach((v) {
        data!.add(AllListingsData.fromJson(v));
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

class AllListingsData {
  int? id;
  String? listingTitle;
  int? categoryId;
  int? cityId;
  String? description;
  String? address;
  String? zipCode;
  int? status;
  int? isActive;
  String? serviceType;
  String? rating;
  String? imageUrl;
  String? cityName;
  String? categoryName;

  AllListingsData({
    this.id,
    this.listingTitle,
    this.categoryId,
    this.cityId,
    this.description,
    this.address,
    this.zipCode,
    this.status,
    this.isActive,
    this.serviceType,
    this.rating,
    this.imageUrl,
    this.cityName,
    this.categoryName,
  });

  AllListingsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    listingTitle = json['listing_title'];
    categoryId = json['category_id'];
    cityId = json['city_id'];
    description = json['description'];
    address = json['address'];
    zipCode = json['zip_code'];
    status = json['status'];
    isActive = json['is_active'];
    serviceType = json['service_type'];
    rating = json['rating'];
    imageUrl = json['image_url'];
    cityName = json['city_name'];
    categoryName = json['category_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['listing_title'] = listingTitle;
    data['category_id'] = categoryId;
    data['city_id'] = cityId;
    data['description'] = description;
    data['address'] = address;
    data['zip_code'] = zipCode;
    data['status'] = status;
    data['is_active'] = isActive;
    data['service_type'] = serviceType;
    data['rating'] = rating;
    data['image_url'] = imageUrl;
    data['city_name'] = cityName;
    data['category_name'] = categoryName;
    return data;
  }
}
