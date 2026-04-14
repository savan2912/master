class ResponseAllNewlyAdded {
  String? result;
  String? message;
  List<AllNewlyAdded>? data;

  ResponseAllNewlyAdded({this.result, this.message, this.data});

  ResponseAllNewlyAdded.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    if (json['data'] != null) {
      data = <AllNewlyAdded>[];
      json['data'].forEach((v) {
        data!.add(new AllNewlyAdded.fromJson(v));
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

class AllNewlyAdded {
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
  String? keywords;
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
  String? gst;
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

  AllNewlyAdded(
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

  AllNewlyAdded.fromJson(Map<String, dynamic> json) {
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
