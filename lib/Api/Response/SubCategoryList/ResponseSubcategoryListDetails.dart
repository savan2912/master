class ResponseSubcategoryListDetails {
  String? result;
  String? message;
  Data? data;

  ResponseSubcategoryListDetails({this.result, this.message, this.data});

  ResponseSubcategoryListDetails.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['result'] = result;
    data['message'] = message;
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

  Data({
    this.listDetail,
    this.vendorDetails,
    this.detailImages,
    this.lisitngdeals,
    this.keywords,
    this.amenities,
  });

  Data.fromJson(Map<String, dynamic> json) {
    listDetail = json['listDetail'] != null
        ? ListDetail.fromJson(json['listDetail'])
        : null;
    vendorDetails = json['vendorDetails'] != null
        ? VendorDetails.fromJson(json['vendorDetails'])
        : null;

    if (json['detailImages'] != null && json['detailImages'] is List) {
      detailImages = (json['detailImages'] as List)
          .map((v) => DetailImages.fromJson(v))
          .toList();
    } else {
      detailImages = [];
    }

    if (json['lisitngdeals'] != null && json['lisitngdeals'] is List) {
      lisitngdeals = (json['lisitngdeals'] as List)
          .map((v) => Lisitngdeals.fromJson(v))
          .toList();
    } else {
      lisitngdeals = [];
    }

    if (json['keywords'] != null && json['keywords'] is List) {
      keywords = (json['keywords'] as List)
          .map((v) => Keywords.fromJson(v))
          .toList();
    } else {
      keywords = [];
    }

    if (json['amenities'] != null && json['amenities'] is List) {
      amenities = (json['amenities'] as List)
          .map((v) => Amenities.fromJson(v))
          .toList();
    } else {
      amenities = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (listDetail != null) {
      data['listDetail'] = listDetail!.toJson();
    }
    if (vendorDetails != null) {
      data['vendorDetails'] = vendorDetails!.toJson();
    }
    if (detailImages != null) {
      data['detailImages'] = detailImages!.map((v) => v.toJson()).toList();
    }
    if (lisitngdeals != null) {
      data['lisitngdeals'] = lisitngdeals!.map((v) => v.toJson()).toList();
    }
    if (keywords != null) {
      data['keywords'] = keywords!.map((v) => v.toJson()).toList();
    }
    if (amenities != null) {
      data['amenities'] = amenities!.map((v) => v.toJson()).toList();
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

  ListDetail({
    this.id,
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
    this.isFavourite,
  });

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

    if (json['deals'] != null && json['deals'] is List) {
      deals = (json['deals'] as List).map((v) => Deals.fromJson(v)).toList();
    } else {
      deals = [];
    }

    category = json['category'] != null
        ? Category.fromJson(json['category'])
        : null;
    vendor = json['vendor'] != null ? Vendor.fromJson(json['vendor']) : null;
    imgS3Path = json['img_s3_path'];
    isFavourite = json['is_favourite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['live_media_status'] = liveMediaStatus;
    data['listing_title'] = listingTitle;
    data['mobile_no'] = mobileNo;
    data['verify_code'] = verifyCode;
    data['phone_extra'] = phoneExtra;
    data['logo_image'] = logoImage;
    data['vendor_id'] = vendorId;
    data['admin_id'] = adminId;
    data['category_id'] = categoryId;
    data['country_id'] = countryId;
    data['state_id'] = stateId;
    data['city_id'] = cityId;
    data['keywords'] = keywords;
    data['chatgpt_description'] = chatgptDescription;
    data['description'] = description;
    data['address'] = address;
    data['zip_code'] = zipCode;
    data['status'] = status;
    data['is_active'] = isActive;
    data['service_type'] = serviceType;
    data['row_id'] = rowId;
    data['open_close'] = openClose;
    data['map_link'] = mapLink;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['social_medias_link'] = socialMediasLink;
    data['reward_header_img'] = rewardHeaderImg;
    data['reward_logo_img'] = rewardLogoImg;
    data['rating'] = rating;
    data['listing_type'] = listingType;
    data['standy_img'] = standyImg;
    data['standy_status'] = standyStatus;
    data['facebook_link'] = facebookLink;
    data['insta_link'] = instaLink;
    data['youtube_link'] = youtubeLink;
    data['linkdin_link'] = linkdinLink;
    data['gst'] = gst;
    data['tax_percent'] = taxPercent;
    data['admin_approve_date'] = adminApproveDate;
    data['seo_data'] = seoData;
    data['meta_title'] = metaTitle;
    data['meta_description'] = metaDescription;
    data['meta_keywords'] = metaKeywords;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (deals != null) {
      data['deals'] = deals!.map((v) => v.toJson()).toList();
    }
    if (category != null) {
      data['category'] = category!.toJson();
    }
    if (vendor != null) {
      data['vendor'] = vendor!.toJson();
    }
    data['img_s3_path'] = imgS3Path;
    data['is_favourite'] = isFavourite;
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

  Deals({
    this.id,
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
    this.updatedAt,
  });

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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['vendor_id'] = vendorId;
    data['listing_id'] = listingId;
    data['deal_temp_id'] = dealTempId;
    data['deal_name'] = dealName;
    data['deal_desc'] = dealDesc;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['status'] = status;
    data['autopilot_status'] = autopilotStatus;
    data['coupon_code'] = couponCode;
    data['discount_type'] = discountType;
    data['deal_point'] = dealPoint;
    data['no_of_user'] = noOfUser;
    data['discount_value'] = discountValue;
    data['msg_sent'] = msgSent;
    data['push_notify_status'] = pushNotifyStatus;
    data['autopilot_id'] = autopilotId;
    data['image'] = image;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
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

  Category({
    this.id,
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
    this.updatedAt,
  });

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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['image'] = image;
    data['icon'] = icon;
    data['banner_image'] = bannerImage;
    data['service_image'] = serviceImage;
    data['parent_id'] = parentId;
    data['position'] = position;
    data['status'] = status;
    data['service_status'] = serviceStatus;
    data['priority'] = priority;
    data['amenity_id'] = amenityId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
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

  Vendor({
    this.id,
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
    this.customerAutoDetails,
  });

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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['admin_id'] = adminId;
    data['store_added_status'] = storeAddedStatus;
    data['f_name'] = fName;
    data['l_name'] = lName;
    data['phone'] = phone;
    data['email'] = email;
    data['email_verified_at'] = emailVerifiedAt;
    data['password'] = password;
    data['password_str'] = passwordStr;
    data['remember_token'] = rememberToken;
    data['otp'] = otp;
    data['phone_verified_status'] = phoneVerifiedStatus;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['bank_name'] = bankName;
    data['branch'] = branch;
    data['holder_name'] = holderName;
    data['account_no'] = accountNo;
    data['image'] = image;
    data['status'] = status;
    data['firebase_token'] = firebaseToken;
    data['auth_token'] = authToken;
    data['fcm_token_web'] = fcmTokenWeb;
    data['name'] = name;
    data['row_id'] = rowId;
    data['website'] = website;
    data['address'] = address;
    data['city_id'] = cityId;
    data['from_website'] = fromWebsite;
    data['no_of_enquiry'] = noOfEnquiry;
    data['emails'] = emails;
    data['reward_rate'] = rewardRate;
    data['autopilot_working_status'] = autopilotWorkingStatus;
    data['plan_type'] = planType;
    data['no_of_listing'] = noOfListing;
    data['no_of_messages'] = noOfMessages;
    data['listing_module_status'] = listingModuleStatus;
    data['platform'] = platform;
    data['customer_auto_details'] = customerAutoDetails;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['vendor_id'] = vendorId;
    data['vendor_name'] = vendorName;
    data['vendor_email'] = vendorEmail;
    data['phone'] = phone;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image_path'] = imagePath;
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

  Lisitngdeals({
    this.id,
    this.dealName,
    this.dealDesc,
    this.startDate,
    this.endDate,
    this.image,
  });

  Lisitngdeals.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dealName = json['deal_name'];
    dealDesc = json['deal_desc'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['deal_name'] = dealName;
    data['deal_desc'] = dealDesc;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['image'] = image;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['keyword'] = keyword;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}