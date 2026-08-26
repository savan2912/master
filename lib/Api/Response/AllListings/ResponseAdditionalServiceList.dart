class ResponseAdditionalServiceList {
  String? result;
  String? message;
  List<AdditionalServiceList>? data;

  ResponseAdditionalServiceList({this.result, this.message, this.data});

  ResponseAdditionalServiceList.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    if (json['data'] != null) {
      data = <AdditionalServiceList>[];
      json['data'].forEach((v) {
        data!.add(new AdditionalServiceList.fromJson(v));
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

class AdditionalServiceList {
  int? id;
  int? vendorId;
  int? listingId;
  int? vendorCategoryServiceId;
  String? serviceTitle;
  String? basePrice;
  String? duration;
  String? description;
  int? status;
  String? createdAt;
  String? updatedAt;

  AdditionalServiceList(
      {this.id,
        this.vendorId,
        this.listingId,
        this.vendorCategoryServiceId,
        this.serviceTitle,
        this.basePrice,
        this.duration,
        this.description,
        this.status,
        this.createdAt,
        this.updatedAt});

  AdditionalServiceList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vendorId = json['vendor_id'];
    listingId = json['listing_id'];
    vendorCategoryServiceId = json['vendor_category_service_id'];
    serviceTitle = json['service_title'];
    basePrice = json['base_price'];
    duration = json['duration'];
    description = json['description'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['vendor_id'] = this.vendorId;
    data['listing_id'] = this.listingId;
    data['vendor_category_service_id'] = this.vendorCategoryServiceId;
    data['service_title'] = this.serviceTitle;
    data['base_price'] = this.basePrice;
    data['duration'] = this.duration;
    data['description'] = this.description;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
