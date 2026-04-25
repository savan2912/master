class ResponsePrisePlan {
  String? result;
  String? message;
  List<PrisePlan>? data;

  ResponsePrisePlan({this.result, this.message, this.data});

  ResponsePrisePlan.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    if (json['data'] != null) {
      data = <PrisePlan>[];
      json['data'].forEach((v) {
        data!.add(new PrisePlan.fromJson(v));
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

class PrisePlan {
  int? id;
  String? planName;
  int? validityDays;
  String? price;
  int? status;
  String? createdAt;
  String? updatedAt;
  List<Features>? features;

  PrisePlan(
      {this.id,
        this.planName,
        this.validityDays,
        this.price,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.features});

  PrisePlan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    planName = json['plan_name'];
    validityDays = json['validity_days'];
    price = json['price'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['features'] != null) {
      features = <Features>[];
      json['features'].forEach((v) {
        features!.add(new Features.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['plan_name'] = this.planName;
    data['validity_days'] = this.validityDays;
    data['price'] = this.price;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.features != null) {
      data['features'] = this.features!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Features {
  int? id;
  int? subscriptionPlanId;
  String? featureName;
  String? fieldKey;
  String? fieldValue;
  int? status;
  String? createdAt;
  String? updatedAt;

  Features(
      {this.id,
        this.subscriptionPlanId,
        this.featureName,
        this.fieldKey,
        this.fieldValue,
        this.status,
        this.createdAt,
        this.updatedAt});

  Features.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subscriptionPlanId = json['subscription_plan_id'];
    featureName = json['feature_name'];
    fieldKey = json['field_key'];
    fieldValue = json['field_value'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['subscription_plan_id'] = this.subscriptionPlanId;
    data['feature_name'] = this.featureName;
    data['field_key'] = this.fieldKey;
    data['field_value'] = this.fieldValue;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
