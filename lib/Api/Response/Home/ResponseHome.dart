class ResponseHome {
  String? result;
  String? message;
  Home? data;

  ResponseHome({this.result, this.message, this.data});

  ResponseHome.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    data = json['data'] != null ? new Home.fromJson(json['data']) : null;
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

class Home {
  List<Sliders>? sliders;
  List<Categories>? categories;
  List<NearbyListings>? nearbyListings;
  List<LatestListings>? latestListings;
  List<Services>? services;
  List<NearbyDeals>? nearbyDeals;

  Home(
      {this.sliders,
        this.categories,
        this.nearbyListings,
        this.latestListings,
        this.services,
        this.nearbyDeals});

  Home.fromJson(Map<String, dynamic> json) {
    if (json['sliders'] != null) {
      sliders = <Sliders>[];
      json['sliders'].forEach((v) {
        sliders!.add(new Sliders.fromJson(v));
      });
    }
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(new Categories.fromJson(v));
      });
    }
    if (json['nearbyListings'] != null) {
      nearbyListings = <NearbyListings>[];
      json['nearbyListings'].forEach((v) {
        nearbyListings!.add(new NearbyListings.fromJson(v));
      });
    }
    if (json['latestListings'] != null) {
      latestListings = <LatestListings>[];
      json['latestListings'].forEach((v) {
        latestListings!.add(new LatestListings.fromJson(v));
      });
    }
    if (json['services'] != null) {
      services = <Services>[];
      json['services'].forEach((v) {
        services!.add(new Services.fromJson(v));
      });
    }
    if (json['nearbyDeals'] != null) {
      nearbyDeals = <NearbyDeals>[];
      json['nearbyDeals'].forEach((v) {
        nearbyDeals!.add(new NearbyDeals.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.sliders != null) {
      data['sliders'] = this.sliders!.map((v) => v.toJson()).toList();
    }
    if (this.categories != null) {
      data['categories'] = this.categories!.map((v) => v.toJson()).toList();
    }
    if (this.nearbyListings != null) {
      data['nearbyListings'] =
          this.nearbyListings!.map((v) => v.toJson()).toList();
    }
    if (this.latestListings != null) {
      data['latestListings'] =
          this.latestListings!.map((v) => v.toJson()).toList();
    }
    if (this.services != null) {
      data['services'] = this.services!.map((v) => v.toJson()).toList();
    }
    if (this.nearbyDeals != null) {
      data['nearbyDeals'] = this.nearbyDeals!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['title'] = this.title;
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

  Categories(
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

class NearbyListings {
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

  NearbyListings(
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
        this.listingImage});

  NearbyListings.fromJson(Map<String, dynamic> json) {
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
    data['amenities'] = this.amenities;
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
    data['city_name'] = this.cityName;
    data['listing_image'] = this.listingImage;
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

  LatestListings(
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
        this.listingImage});

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
    data['amenities'] = this.amenities;
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
    data['city_name'] = this.cityName;
    data['listing_image'] = this.listingImage;
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

  Services(
      {this.id,
        this.name,
        this.slug,
        this.icon,
        this.serviceImage,
        this.image});

  Services.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    icon = json['icon'];
    serviceImage = json['service_image'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['icon'] = this.icon;
    data['service_image'] = this.serviceImage;
    data['image'] = this.image;
    return data;
  }
}

class NearbyDeals {
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
  int? cityId;
  String? cityName;
  String? templateImage;
  String? listingImage;
  double? distance;

  NearbyDeals(
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
        this.updatedAt,
        this.cityId,
        this.cityName,
        this.templateImage,
        this.listingImage,
        this.distance});

  NearbyDeals.fromJson(Map<String, dynamic> json) {
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
    cityId = json['city_id'];
    cityName = json['city_name'];
    templateImage = json['template_image'];
    listingImage = json['listing_image'];
    distance = json['distance'];
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
    data['city_id'] = this.cityId;
    data['city_name'] = this.cityName;
    data['template_image'] = this.templateImage;
    data['listing_image'] = this.listingImage;
    data['distance'] = this.distance;
    return data;
  }
}
