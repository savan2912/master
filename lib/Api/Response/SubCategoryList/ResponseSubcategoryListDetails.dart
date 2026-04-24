class ResponseSubcategoryListDetails {
  String? result;
  String? message;
  Data? data;

  ResponseSubcategoryListDetails({this.result, this.message, this.data});

  ResponseSubcategoryListDetails.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  ListDetail? listDetail;
  VendorDetails? vendorDetails;
  List<DetailImages>? detailImages;
  List<Lisitngdeals>? lisitngdeals;
  List<Keywords>? keywords;
  List<Amenities>? amenities;

  Data(
      {this.listDetail,
        this.vendorDetails,
        this.detailImages,
        this.lisitngdeals,
        this.keywords,
        this.amenities});

  Data.fromJson(Map<String, dynamic> json) {
    listDetail = json['listDetail'] != null
        ? new ListDetail.fromJson(json['listDetail'])
        : null;
    vendorDetails = json['vendorDetails'] != null
        ? new VendorDetails.fromJson(json['vendorDetails'])
        : null;
    if (json['detailImages'] != null) {
      detailImages = <DetailImages>[];
      json['detailImages'].forEach((v) {
        detailImages!.add(new DetailImages.fromJson(v));
      });
    }
    if (json['lisitngdeals'] != null) {
      lisitngdeals = <Lisitngdeals>[];
      json['lisitngdeals'].forEach((v) {
        lisitngdeals!.add(new Lisitngdeals.fromJson(v));
      });
    }
    if (json['keywords'] != null) {
      keywords = <Keywords>[];
      json['keywords'].forEach((v) {
        keywords!.add(new Keywords.fromJson(v));
      });
    }
    if (json['amenities'] != null) {
      amenities = <Amenities>[];
      json['amenities'].forEach((v) {
        amenities!.add(new Amenities.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.listDetail != null) {
      data['listDetail'] = this.listDetail!.toJson();
    }
    if (this.vendorDetails != null) {
      data['vendorDetails'] = this.vendorDetails!.toJson();
    }
    if (this.detailImages != null) {
      data['detailImages'] = this.detailImages!.map((v) => v.toJson()).toList();
    }
    if (this.lisitngdeals != null) {
      data['lisitngdeals'] = this.lisitngdeals!.map((v) => v.toJson()).toList();
    }
    if (this.keywords != null) {
      data['keywords'] = this.keywords!.map((v) => v.toJson()).toList();
    }
    if (this.amenities != null) {
      data['amenities'] = this.amenities!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ListDetail {
  int? id;
  int? liveMediaStatus;
  String? listingTitle;
  String? mobileNo;
  dynamic verifyCode;
  dynamic phoneExtra;
  String? logoImage;
  int? vendorId;
  int? adminId;
  int? categoryId;
  int? countryId;
  int? stateId;
  int? cityId;
  String? keywords;
  int? chatgptDescription;
  String? description;
  String? address;
  String? zipCode;
  int? status;
  int? isActive;
  String? serviceType;
  dynamic rowId;
  String? openClose;
  String? mapLink;
  String? latitude;
  String? longitude;
  dynamic socialMediasLink;
  dynamic rewardHeaderImg;
  dynamic rewardLogoImg;
  String? rating;
  int? listingType;
  dynamic standyImg;
  int? standyStatus;
  dynamic facebookLink;
  dynamic instaLink;
  dynamic youtubeLink;
  dynamic linkdinLink;
  dynamic gst;
  String? taxPercent;
  dynamic adminApproveDate;
  dynamic seoData;
  String? metaTitle;
  String? metaDescription;
  String? metaKeywords;
  String? createdAt;
  String? updatedAt;
  List<Deals>? deals;
  Category? category;
  Vendor? vendor;
  String? imgS3Path;
  int? isFavourite;

  ListDetail(
      {this.id,
        this.liveMediaStatus,
        this.listingTitle,
        this.mobileNo,
        this.verifyCode,
        this.phoneExtra,
        this.logoImage,
        this.vendorId,
        this.adminId,
        this.categoryId,
        this.countryId,
        this.stateId,
        this.cityId,
        this.keywords,
        this.chatgptDescription,
        this.description,
        this.address,
        this.zipCode,
        this.status,
        this.isActive,
        this.serviceType,
        this.rowId,
        this.openClose,
        this.mapLink,
        this.latitude,
        this.longitude,
        this.socialMediasLink,
        this.rewardHeaderImg,
        this.rewardLogoImg,
        this.rating,
        this.listingType,
        this.standyImg,
        this.standyStatus,
        this.facebookLink,
        this.instaLink,
        this.youtubeLink,
        this.linkdinLink,
        this.gst,
        this.taxPercent,
        this.adminApproveDate,
        this.seoData,
        this.metaTitle,
        this.metaDescription,
        this.metaKeywords,
        this.createdAt,
        this.updatedAt,
        this.deals,
        this.category,
        this.vendor,
        this.imgS3Path,
        this.isFavourite});

  ListDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    liveMediaStatus = json['live_media_status'];
    listingTitle = json['listing_title'];
    mobileNo = json['mobile_no'];
    verifyCode = json['verify_code'];
    phoneExtra = json['phone_extra'];
    logoImage = json['logo_image'];
    vendorId = json['vendor_id'];
    adminId = json['admin_id'];
    categoryId = json['category_id'];
    countryId = json['country_id'];
    stateId = json['state_id'];
    cityId = json['city_id'];
    keywords = json['keywords'];
    chatgptDescription = json['chatgpt_description'];
    description = json['description'];
    address = json['address'];
    zipCode = json['zip_code'];
    status = json['status'];
    isActive = json['is_active'];
    serviceType = json['service_type'];
    rowId = json['row_id'];
    openClose = json['open_close'];
    mapLink = json['map_link'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    socialMediasLink = json['social_medias_link'];
    rewardHeaderImg = json['reward_header_img'];
    rewardLogoImg = json['reward_logo_img'];
    rating = json['rating'];
    listingType = json['listing_type'];
    standyImg = json['standy_img'];
    standyStatus = json['standy_status'];
    facebookLink = json['facebook_link'];
    instaLink = json['insta_link'];
    youtubeLink = json['youtube_link'];
    linkdinLink = json['linkdin_link'];
    gst = json['gst'];
    taxPercent = json['tax_percent'];
    adminApproveDate = json['admin_approve_date'];
    seoData = json['seo_data'];
    metaTitle = json['meta_title'];
    metaDescription = json['meta_description'];
    metaKeywords = json['meta_keywords'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['deals'] != null) {
      deals = <Deals>[];
      json['deals'].forEach((v) {
        deals!.add(new Deals.fromJson(v));
      });
    }
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    vendor =
    json['vendor'] != null ? new Vendor.fromJson(json['vendor']) : null;
    imgS3Path = json['img_s3_path'];
    isFavourite = json['is_favourite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['live_media_status'] = this.liveMediaStatus;
    data['listing_title'] = this.listingTitle;
    data['mobile_no'] = this.mobileNo;
    data['verify_code'] = this.verifyCode;
    data['phone_extra'] = this.phoneExtra;
    data['logo_image'] = this.logoImage;
    data['vendor_id'] = this.vendorId;
    data['admin_id'] = this.adminId;
    data['category_id'] = this.categoryId;
    data['country_id'] = this.countryId;
    data['state_id'] = this.stateId;
    data['city_id'] = this.cityId;
    data['keywords'] = this.keywords;
    data['chatgpt_description'] = this.chatgptDescription;
    data['description'] = this.description;
    data['address'] = this.address;
    data['zip_code'] = this.zipCode;
    data['status'] = this.status;
    data['is_active'] = this.isActive;
    data['service_type'] = this.serviceType;
    data['row_id'] = this.rowId;
    data['open_close'] = this.openClose;
    data['map_link'] = this.mapLink;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['social_medias_link'] = this.socialMediasLink;
    data['reward_header_img'] = this.rewardHeaderImg;
    data['reward_logo_img'] = this.rewardLogoImg;
    data['rating'] = this.rating;
    data['listing_type'] = this.listingType;
    data['standy_img'] = this.standyImg;
    data['standy_status'] = this.standyStatus;
    data['facebook_link'] = this.facebookLink;
    data['insta_link'] = this.instaLink;
    data['youtube_link'] = this.youtubeLink;
    data['linkdin_link'] = this.linkdinLink;
    data['gst'] = this.gst;
    data['tax_percent'] = this.taxPercent;
    data['admin_approve_date'] = this.adminApproveDate;
    data['seo_data'] = this.seoData;
    data['meta_title'] = this.metaTitle;
    data['meta_description'] = this.metaDescription;
    data['meta_keywords'] = this.metaKeywords;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.deals != null) {
      data['deals'] = this.deals!.map((v) => v.toJson()).toList();
    }
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    if (this.vendor != null) {
      data['vendor'] = this.vendor!.toJson();
    }
    data['img_s3_path'] = this.imgS3Path;
    data['is_favourite'] = this.isFavourite;
    return data;
  }
}

class Deals {
  int? id;
  int? vendorId;
  int? listingId;
  int? dealTempId;
  String? dealName;
  String? dealDesc;
  String? startDate;
  String? endDate;
  int? status;
  int? autopilotStatus;
  String? couponCode;
  String? discountType;
  int? dealPoint;
  int? noOfUser;
  String? discountValue;
  int? msgSent;
  int? pushNotifyStatus;
  int? autopilotId;
  dynamic image;
  String? createdAt;
  String? updatedAt;

  Deals(
      {this.id,
        this.vendorId,
        this.listingId,
        this.dealTempId,
        this.dealName,
        this.dealDesc,
        this.startDate,
        this.endDate,
        this.status,
        this.autopilotStatus,
        this.couponCode,
        this.discountType,
        this.dealPoint,
        this.noOfUser,
        this.discountValue,
        this.msgSent,
        this.pushNotifyStatus,
        this.autopilotId,
        this.image,
        this.createdAt,
        this.updatedAt});

  Deals.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vendorId = json['vendor_id'];
    listingId = json['listing_id'];
    dealTempId = json['deal_temp_id'];
    dealName = json['deal_name'];
    dealDesc = json['deal_desc'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    status = json['status'];
    autopilotStatus = json['autopilot_status'];
    couponCode = json['coupon_code'];
    discountType = json['discount_type'];
    dealPoint = json['deal_point'];
    noOfUser = json['no_of_user'];
    discountValue = json['discount_value'];
    msgSent = json['msg_sent'];
    pushNotifyStatus = json['push_notify_status'];
    autopilotId = json['autopilot_id'];
    image = json['image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['vendor_id'] = this.vendorId;
    data['listing_id'] = this.listingId;
    data['deal_temp_id'] = this.dealTempId;
    data['deal_name'] = this.dealName;
    data['deal_desc'] = this.dealDesc;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['status'] = this.status;
    data['autopilot_status'] = this.autopilotStatus;
    data['coupon_code'] = this.couponCode;
    data['discount_type'] = this.discountType;
    data['deal_point'] = this.dealPoint;
    data['no_of_user'] = this.noOfUser;
    data['discount_value'] = this.discountValue;
    data['msg_sent'] = this.msgSent;
    data['push_notify_status'] = this.pushNotifyStatus;
    data['autopilot_id'] = this.autopilotId;
    data['image'] = this.image;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Category {
  int? id;
  String? name;
  String? slug;
  String? image;
  String? icon;
  String? bannerImage;
  dynamic serviceImage;
  dynamic parentId;
  int? position;
  int? status;
  int? serviceStatus;
  int? priority;
  String? amenityId;
  String? createdAt;
  String? updatedAt;

  Category(
      {this.id,
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
        this.updatedAt});

  Category.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['image'] = this.image;
    data['icon'] = this.icon;
    data['banner_image'] = this.bannerImage;
    data['service_image'] = this.serviceImage;
    data['parent_id'] = this.parentId;
    data['position'] = this.position;
    data['status'] = this.status;
    data['service_status'] = this.serviceStatus;
    data['priority'] = this.priority;
    data['amenity_id'] = this.amenityId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Vendor {
  int? id;
  int? adminId;
  int? storeAddedStatus;
  String? fName;
  String? lName;
  String? phone;
  String? email;
  dynamic emailVerifiedAt;
  String? password;
  String? passwordStr;
  dynamic rememberToken;
  int? otp;
  int? phoneVerifiedStatus;
  String? createdAt;
  String? updatedAt;
  dynamic bankName;
  dynamic branch;
  dynamic holderName;
  dynamic accountNo;
  String? image;
  int? status;
  dynamic firebaseToken;
  dynamic authToken;
  dynamic fcmTokenWeb;
  String? name;
  dynamic rowId;
  dynamic website;
  String? address;
  int? cityId;
  dynamic fromWebsite;
  int? noOfEnquiry;
  dynamic emails;
  int? rewardRate;
  int? autopilotWorkingStatus;
  int? planType;
  int? noOfListing;
  int? noOfMessages;
  int? listingModuleStatus;
  String? platform;
  int? customerAutoDetails;

  Vendor(
      {this.id,
        this.adminId,
        this.storeAddedStatus,
        this.fName,
        this.lName,
        this.phone,
        this.email,
        this.emailVerifiedAt,
        this.password,
        this.passwordStr,
        this.rememberToken,
        this.otp,
        this.phoneVerifiedStatus,
        this.createdAt,
        this.updatedAt,
        this.bankName,
        this.branch,
        this.holderName,
        this.accountNo,
        this.image,
        this.status,
        this.firebaseToken,
        this.authToken,
        this.fcmTokenWeb,
        this.name,
        this.rowId,
        this.website,
        this.address,
        this.cityId,
        this.fromWebsite,
        this.noOfEnquiry,
        this.emails,
        this.rewardRate,
        this.autopilotWorkingStatus,
        this.planType,
        this.noOfListing,
        this.noOfMessages,
        this.listingModuleStatus,
        this.platform,
        this.customerAutoDetails});

  Vendor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    adminId = json['admin_id'];
    storeAddedStatus = json['store_added_status'];
    fName = json['f_name'];
    lName = json['l_name'];
    phone = json['phone'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    password = json['password'];
    passwordStr = json['password_str'];
    rememberToken = json['remember_token'];
    otp = json['otp'];
    phoneVerifiedStatus = json['phone_verified_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    bankName = json['bank_name'];
    branch = json['branch'];
    holderName = json['holder_name'];
    accountNo = json['account_no'];
    image = json['image'];
    status = json['status'];
    firebaseToken = json['firebase_token'];
    authToken = json['auth_token'];
    fcmTokenWeb = json['fcm_token_web'];
    name = json['name'];
    rowId = json['row_id'];
    website = json['website'];
    address = json['address'];
    cityId = json['city_id'];
    fromWebsite = json['from_website'];
    noOfEnquiry = json['no_of_enquiry'];
    emails = json['emails'];
    rewardRate = json['reward_rate'];
    autopilotWorkingStatus = json['autopilot_working_status'];
    planType = json['plan_type'];
    noOfListing = json['no_of_listing'];
    noOfMessages = json['no_of_messages'];
    listingModuleStatus = json['listing_module_status'];
    platform = json['platform'];
    customerAutoDetails = json['customer_auto_details'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['admin_id'] = this.adminId;
    data['store_added_status'] = this.storeAddedStatus;
    data['f_name'] = this.fName;
    data['l_name'] = this.lName;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['password'] = this.password;
    data['password_str'] = this.passwordStr;
    data['remember_token'] = this.rememberToken;
    data['otp'] = this.otp;
    data['phone_verified_status'] = this.phoneVerifiedStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['bank_name'] = this.bankName;
    data['branch'] = this.branch;
    data['holder_name'] = this.holderName;
    data['account_no'] = this.accountNo;
    data['image'] = this.image;
    data['status'] = this.status;
    data['firebase_token'] = this.firebaseToken;
    data['auth_token'] = this.authToken;
    data['fcm_token_web'] = this.fcmTokenWeb;
    data['name'] = this.name;
    data['row_id'] = this.rowId;
    data['website'] = this.website;
    data['address'] = this.address;
    data['city_id'] = this.cityId;
    data['from_website'] = this.fromWebsite;
    data['no_of_enquiry'] = this.noOfEnquiry;
    data['emails'] = this.emails;
    data['reward_rate'] = this.rewardRate;
    data['autopilot_working_status'] = this.autopilotWorkingStatus;
    data['plan_type'] = this.planType;
    data['no_of_listing'] = this.noOfListing;
    data['no_of_messages'] = this.noOfMessages;
    data['listing_module_status'] = this.listingModuleStatus;
    data['platform'] = this.platform;
    data['customer_auto_details'] = this.customerAutoDetails;
    return data;
  }
}

class VendorDetails {
  int? vendorId;
  String? vendorName;
  String? vendorEmail;
  String? phone;

  VendorDetails({this.vendorId, this.vendorName, this.vendorEmail, this.phone});

  VendorDetails.fromJson(Map<String, dynamic> json) {
    vendorId = json['vendor_id'];
    vendorName = json['vendor_name'];
    vendorEmail = json['vendor_email'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vendor_id'] = this.vendorId;
    data['vendor_name'] = this.vendorName;
    data['vendor_email'] = this.vendorEmail;
    data['phone'] = this.phone;
    return data;
  }
}

class DetailImages {
  String? imagePath;

  DetailImages({this.imagePath});

  DetailImages.fromJson(Map<String, dynamic> json) {
    imagePath = json['image_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image_path'] = this.imagePath;
    return data;
  }
}

class Lisitngdeals {
  int? id;
  String? dealName;
  String? dealDesc;
  String? startDate;
  String? endDate;
  String? image;

  Lisitngdeals(
      {this.id,
        this.dealName,
        this.dealDesc,
        this.startDate,
        this.endDate,
        this.image});

  Lisitngdeals.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dealName = json['deal_name'];
    dealDesc = json['deal_desc'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['deal_name'] = this.dealName;
    data['deal_desc'] = this.dealDesc;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['image'] = this.image;
    return data;
  }
}

class Keywords {
  int? id;
  String? keyword;

  Keywords({this.id, this.keyword});

  Keywords.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    keyword = json['keyword'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['keyword'] = this.keyword;
    return data;
  }
}

class Amenities {
  int? id;
  String? name;

  Amenities({this.id, this.name});

  Amenities.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
