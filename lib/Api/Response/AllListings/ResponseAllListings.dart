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
        data!.add(new AllListingsData.fromJson(v));
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

  AllListingsData(
      {this.id,
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
        this.categoryName});

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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['listing_title'] = this.listingTitle;
    data['category_id'] = this.categoryId;
    data['city_id'] = this.cityId;
    data['description'] = this.description;
    data['address'] = this.address;
    data['zip_code'] = this.zipCode;
    data['status'] = this.status;
    data['is_active'] = this.isActive;
    data['service_type'] = this.serviceType;
    data['rating'] = this.rating;
    data['image_url'] = this.imageUrl;
    data['city_name'] = this.cityName;
    data['category_name'] = this.categoryName;
    return data;
  }
}
