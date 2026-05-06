class ResponseAllLatestRelease {
  String? result;
  String? message;
  List<AllLatestRelease>? data;

  ResponseAllLatestRelease({this.result, this.message, this.data});

  ResponseAllLatestRelease.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    if (json['data'] != null) {
      data = <AllLatestRelease>[];
      json['data'].forEach((v) {
        data!.add(AllLatestRelease.fromJson(v));
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

class AllLatestRelease {
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

  AllLatestRelease({
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

  AllLatestRelease.fromJson(Map<String, dynamic> json) {
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
