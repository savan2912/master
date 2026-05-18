import 'dart:math';

class ResponsePrisePlan {
  String? result;
  String? message;
  String? number;
  String? email;
  List<PrisePlan>? data;

  ResponsePrisePlan({this.result, this.message, this.data,this.number,this.email});

  ResponsePrisePlan.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    number = json['company_number'];
    email = json['company_email'];
    if (json['data'] != null) {
      data = <PrisePlan>[];
      json['data'].forEach((v) {
        data!.add(PrisePlan.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['result'] = result;
    data['message'] = message;
    data['company_number'] = number;
    data['company_email'] = email;
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

  PrisePlan({
    this.id,
    this.planName,
    this.validityDays,
    this.price,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.features,
  });

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
        features!.add(Features.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['plan_name'] = planName;
    data['validity_days'] = validityDays;
    data['price'] = price;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (features != null) {
      data['features'] = features!.map((v) => v.toJson()).toList();
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

  Features({
    this.id,
    this.subscriptionPlanId,
    this.featureName,
    this.fieldKey,
    this.fieldValue,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['subscription_plan_id'] = subscriptionPlanId;
    data['feature_name'] = featureName;
    data['field_key'] = fieldKey;
    data['field_value'] = fieldValue;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
