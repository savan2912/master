class ResponseHome {
  String? result;
  String? message;
  Home? data;

  ResponseHome({this.result, this.message, this.data});

  ResponseHome.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    data = json['data'] != null ? Home.fromJson(json['data']) : null;
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

class Home {
  List<Sliders>? sliders;
  List<Categories>? categories;
  List<NearbyListings>? nearbyListings;
  List<LatestListings>? latestListings;
  List<Services>? services;
  List<NearbyDeals>? nearbyDeals;

  Home({
    this.sliders,
    this.categories,
    this.nearbyListings,
    this.latestListings,
    this.services,
    this.nearbyDeals,
  });

  Home.fromJson(Map<String, dynamic> json) {
    if (json['sliders'] != null) {
      sliders = <Sliders>[];
      json['sliders'].forEach((v) {
        sliders!.add(Sliders.fromJson(v));
      });
    }
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(Categories.fromJson(v));
      });
    }
    if (json['nearbyListings'] != null) {
      nearbyListings = <NearbyListings>[];
      json['nearbyListings'].forEach((v) {
        nearbyListings!.add(NearbyListings.fromJson(v));
      });
    }
    if (json['latestListings'] != null) {
      latestListings = <LatestListings>[];
      json['latestListings'].forEach((v) {
        latestListings!.add(LatestListings.fromJson(v));
      });
    }
    if (json['services'] != null) {
      services = <Services>[];
      json['services'].forEach((v) {
        services!.add(Services.fromJson(v));
      });
    }
    if (json['nearbyDeals'] != null) {
      nearbyDeals = <NearbyDeals>[];
      json['nearbyDeals'].forEach((v) {
        nearbyDeals!.add(NearbyDeals.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (sliders != null) {
      data['sliders'] = sliders!.map((v) => v.toJson()).toList();
    }
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    if (nearbyListings != null) {
      data['nearbyListings'] = nearbyListings!.map((v) => v.toJson()).toList();
    }
    if (latestListings != null) {
      data['latestListings'] = latestListings!.map((v) => v.toJson()).toList();
    }
    if (services != null) {
      data['services'] = services!.map((v) => v.toJson()).toList();
    }
    if (nearbyDeals != null) {
      data['nearbyDeals'] = nearbyDeals!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Sliders {
  int? id;
  String? image;
  dynamic title;

  Sliders({this.id, this.image, this.title});

  Sliders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['image'] = image;
    data['title'] = title;
    return data;
  }
}

class Categories {
  int? id;
  String? name;
  String? slug;
  String? image;
  String? icon;
  String? bannerImage;
  String? serviceImage;
  dynamic parentId;
  int? position;
  int? status;
  int? serviceStatus;
  int? priority;
  String? amenityId;
  String? createdAt;
  String? updatedAt;

  Categories({
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

  Categories.fromJson(Map<String, dynamic> json) {
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

class NearbyListings {
  int? id;
  String? dealName;
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
  List<String>? amenities;
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
  String? standyImg;
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
  String? cityName;
  String? listingImage;

  NearbyListings({
    this.id,
    this.dealName,
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
    this.amenities,
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
    this.cityName,
    this.listingImage,
  });

  NearbyListings.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dealName = json['deal_name'];
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
    amenities = json['amenities'].cast<String>();
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
    cityName = json['city_name'];
    listingImage = json['listing_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['deal_name'] = dealName;
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
    data['amenities'] = amenities;
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
    data['city_name'] = cityName;
    data['listing_image'] = listingImage;
    return data;
  }
}

class LatestListings {
  int? id;

  int? liveMediaStatus;
  String? listingTitle;
  String? mobileNo;
  dynamic verifyCode;
  dynamic phoneExtra;
  dynamic logoImage;
  int? vendorId;
  int? adminId;
  int? categoryId;
  int? countryId;
  int? stateId;
  int? cityId;
  dynamic keywords;
  int? chatgptDescription;
  String? description;
  String? address;
  String? zipCode;
  List<String>? amenities;
  int? status;
  int? isActive;
  dynamic serviceType;
  dynamic rowId;
  dynamic openClose;
  dynamic mapLink;
  String? latitude;
  String? longitude;
  dynamic socialMediasLink;
  dynamic rewardHeaderImg;
  dynamic rewardLogoImg;
  String? rating;
  int? listingType;
  dynamic standyImg;
  int? standyStatus;
  String? facebookLink;
  String? instaLink;
  String? youtubeLink;
  String? linkdinLink;
  dynamic gst;
  String? taxPercent;
  String? adminApproveDate;
  dynamic seoData;
  String? metaTitle;
  String? metaDescription;
  String? metaKeywords;
  String? createdAt;
  String? updatedAt;
  String? cityName;
  String? listingImage;

  LatestListings({
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
    this.amenities,
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
    this.cityName,
    this.listingImage,
  });

  LatestListings.fromJson(Map<String, dynamic> json) {
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
    amenities = json['amenities'].cast<String>();
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
    cityName = json['city_name'];
    listingImage = json['listing_image'];
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
    data['amenities'] = amenities;
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
    data['city_name'] = cityName;
    data['listing_image'] = listingImage;
    return data;
  }
}

class Services {
  int? id;
  String? name;
  String? slug;
  dynamic icon;
  String? serviceImage;
  String? image;

  Services({
    this.id,
    this.name,
    this.slug,
    this.icon,
    this.serviceImage,
    this.image,
  });

  Services.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    icon = json['icon'];
    serviceImage = json['service_image'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['icon'] = icon;
    data['service_image'] = serviceImage;
    data['image'] = image;
    return data;
  }
}

class NearbyDeals {
  int? id;
  String? listingTitle;
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
  int? cityId;
  String? cityName;
  String? templateImage;
  String? listingImage;
  double? distance;

  NearbyDeals({
    this.id,
    this.listingTitle,
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
    this.cityId,
    this.cityName,
    this.templateImage,
    this.listingImage,
    this.distance,
  });

  NearbyDeals.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    listingTitle = json['listing_title'];
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
    cityId = json['city_id'];
    cityName = json['city_name'];
    templateImage = json['template_image'];
    listingImage = json['listing_image'];
    distance = json['distance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['listing_title'] = listingTitle;
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
    data['city_id'] = cityId;
    data['city_name'] = cityName;
    data['template_image'] = templateImage;
    data['listing_image'] = listingImage;
    data['distance'] = distance;
    return data;
  }
}
