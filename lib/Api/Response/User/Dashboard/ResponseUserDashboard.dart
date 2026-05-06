class ResponseUserDashboard {
  String? result;
  String? message;
  Data? data;

  ResponseUserDashboard({this.result, this.message, this.data});

  ResponseUserDashboard.fromJson(Map<String, dynamic> json) {
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
  int? pendingPoints;
  int? billingPoints;
  int? totalPoints;
  List<RecentBilling>? recentBilling;
  List<Enquiries>? enquiries;
  List<Rewards>? rewards;
  List<BookingHistory>? bookingHistory;

  Data({
    this.pendingPoints,
    this.billingPoints,
    this.totalPoints,
    this.recentBilling,
    this.enquiries,
    this.rewards,
    this.bookingHistory,
  });

  Data.fromJson(Map<String, dynamic> json) {
    pendingPoints = json['pending_points'];
    billingPoints = json['billing_points'];
    totalPoints = json['total_points'];
    if (json['recent_billing'] != null) {
      recentBilling = <RecentBilling>[];
      json['recent_billing'].forEach((v) {
        recentBilling!.add(RecentBilling.fromJson(v));
      });
    }
    if (json['enquiries'] != null) {
      enquiries = <Enquiries>[];
      json['enquiries'].forEach((v) {
        enquiries!.add(Enquiries.fromJson(v));
      });
    }
    if (json['rewards'] != null) {
      rewards = <Rewards>[];
      json['rewards'].forEach((v) {
        rewards!.add(Rewards.fromJson(v));
      });
    }
    if (json['booking_history'] != null) {
      bookingHistory = <BookingHistory>[];
      json['booking_history'].forEach((v) {
        bookingHistory!.add(BookingHistory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pending_points'] = pendingPoints;
    data['billing_points'] = billingPoints;
    data['total_points'] = totalPoints;
    if (recentBilling != null) {
      data['recent_billing'] = recentBilling!.map((v) => v.toJson()).toList();
    }
    if (enquiries != null) {
      data['enquiries'] = enquiries!.map((v) => v.toJson()).toList();
    }
    if (rewards != null) {
      data['rewards'] = rewards!.map((v) => v.toJson()).toList();
    }
    if (bookingHistory != null) {
      data['booking_history'] = bookingHistory!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RecentBilling {
  int? id;
  int? cashierId;
  int? waiterId;
  int? vendorId;
  int? listingId;
  int? rewardId;
  int? userId;
  int? dealId;
  int? discountType;
  String? subTotal;
  String? taxPercent;
  String? taxAmount;
  String? total;
  String? discountAmount;
  dynamic couponCode;
  String? tag;
  dynamic customerDob;
  dynamic customerAnniversary;
  int? msgSent;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? customerPhone;
  String? billSourceType;
  String? listingTitle;
  String? cashiername;
  String? username;
  String? userphone;
  String? dealname;
  String? rewardTitle;
  String? paymentType;
  dynamic paymentId;
  List<BillProducts>? billProducts;

  RecentBilling({
    this.id,
    this.cashierId,
    this.waiterId,
    this.vendorId,
    this.listingId,
    this.rewardId,
    this.userId,
    this.dealId,
    this.discountType,
    this.subTotal,
    this.taxPercent,
    this.taxAmount,
    this.total,
    this.discountAmount,
    this.couponCode,
    this.tag,
    this.customerDob,
    this.customerAnniversary,
    this.msgSent,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.customerPhone,
    this.billSourceType,
    this.listingTitle,
    this.cashiername,
    this.username,
    this.userphone,
    this.dealname,
    this.rewardTitle,
    this.paymentType,
    this.paymentId,
    this.billProducts,
  });

  RecentBilling.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cashierId = json['cashier_id'];
    waiterId = json['waiter_id'];
    vendorId = json['vendor_id'];
    listingId = json['listing_id'];
    rewardId = json['reward_id'];
    userId = json['user_id'];
    dealId = json['deal_id'];
    discountType = json['discount_type'];
    subTotal = json['sub_total'];
    taxPercent = json['tax_percent'];
    taxAmount = json['tax_amount'];
    total = json['total'];
    discountAmount = json['discount_amount'];
    couponCode = json['coupon_code'];
    tag = json['tag'];
    customerDob = json['customer_dob'];
    customerAnniversary = json['customer_anniversary'];
    msgSent = json['msg_sent'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    customerPhone = json['customer_phone'];
    billSourceType = json['bill_source_type'];
    listingTitle = json['listing_title'];
    cashiername = json['cashiername'];
    username = json['username'];
    userphone = json['userphone'];
    dealname = json['dealname'];
    rewardTitle = json['reward_title'];
    paymentType = json['payment_type'];
    paymentId = json['payment_id'];
    if (json['bill_products'] != null) {
      billProducts = <BillProducts>[];
      json['bill_products'].forEach((v) {
        billProducts!.add(BillProducts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['cashier_id'] = cashierId;
    data['waiter_id'] = waiterId;
    data['vendor_id'] = vendorId;
    data['listing_id'] = listingId;
    data['reward_id'] = rewardId;
    data['user_id'] = userId;
    data['deal_id'] = dealId;
    data['discount_type'] = discountType;
    data['sub_total'] = subTotal;
    data['tax_percent'] = taxPercent;
    data['tax_amount'] = taxAmount;
    data['total'] = total;
    data['discount_amount'] = discountAmount;
    data['coupon_code'] = couponCode;
    data['tag'] = tag;
    data['customer_dob'] = customerDob;
    data['customer_anniversary'] = customerAnniversary;
    data['msg_sent'] = msgSent;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['customer_phone'] = customerPhone;
    data['bill_source_type'] = billSourceType;
    data['listing_title'] = listingTitle;
    data['cashiername'] = cashiername;
    data['username'] = username;
    data['userphone'] = userphone;
    data['dealname'] = dealname;
    data['reward_title'] = rewardTitle;
    data['payment_type'] = paymentType;
    data['payment_id'] = paymentId;
    if (billProducts != null) {
      data['bill_products'] = billProducts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BillProducts {
  int? id;
  int? cashierBillId;
  int? vendorProductId;
  dynamic storeProductId;
  String? platformType;
  String? qty;
  String? price;
  String? createdAt;
  String? updatedAt;
  StoreProduct? storeProduct;

  BillProducts({
    this.id,
    this.cashierBillId,
    this.vendorProductId,
    this.storeProductId,
    this.platformType,
    this.qty,
    this.price,
    this.createdAt,
    this.updatedAt,
    this.storeProduct,
  });

  BillProducts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cashierBillId = json['cashier_bill_id'];
    vendorProductId = json['vendor_product_id'];
    storeProductId = json['store_product_id'];
    platformType = json['platform_type'];
    qty = json['qty'];
    price = json['price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    storeProduct = json['store_product'] != null
        ? StoreProduct.fromJson(json['store_product'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['cashier_bill_id'] = cashierBillId;
    data['vendor_product_id'] = vendorProductId;
    data['store_product_id'] = storeProductId;
    data['platform_type'] = platformType;
    data['qty'] = qty;
    data['price'] = price;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (storeProduct != null) {
      data['store_product'] = storeProduct!.toJson();
    }
    return data;
  }
}

class StoreProduct {
  int? id;
  String? addedBy;
  dynamic gotiloListingId;
  dynamic gotiloCityId;
  int? userId;
  String? name;
  String? slug;
  String? productType;
  String? categoryIds;
  String? categoryId;
  dynamic subCategoryId;
  dynamic subSubCategoryId;
  dynamic brandId;
  String? unit;
  int? minQty;
  int? refundable;
  dynamic digitalProductType;
  String? digitalFileReady;
  dynamic digitalFileReadyStorageType;
  List<Images>? images;
  String? colorImage;
  String? thumbnail;
  String? thumbnailStorageType;
  String? previewFile;
  String? previewFileStorageType;
  dynamic featured;
  dynamic flashDeal;
  String? videoProvider;
  dynamic videoUrl;
  String? colors;
  int? variantProduct;
  String? attributes;
  String? choiceOptions;
  String? variation;
  String? digitalProductFileTypes;
  String? digitalProductExtensions;
  int? published;
  int? unitPrice;
  int? purchasePrice;
  String? tax;
  String? taxType;
  String? taxModel;
  String? discount;
  String? discountType;
  int? currentStock;
  int? minimumOrderQty;
  String? details;
  int? freeShipping;
  dynamic attachment;
  String? createdAt;
  String? updatedAt;
  int? status;
  int? featuredStatus;
  String? metaTitle;
  String? metaDescription;
  dynamic metaImage;
  int? requestStatus;
  dynamic deniedNote;
  int? shippingCost;
  int? multiplyQty;
  dynamic tempShippingCost;
  dynamic isShippingCostUpdated;
  String? code;
  int? discountedPrice;

  StoreProduct({
    this.id,
    this.addedBy,
    this.gotiloListingId,
    this.gotiloCityId,
    this.userId,
    this.name,
    this.slug,
    this.productType,
    this.categoryIds,
    this.categoryId,
    this.subCategoryId,
    this.subSubCategoryId,
    this.brandId,
    this.unit,
    this.minQty,
    this.refundable,
    this.digitalProductType,
    this.digitalFileReady,
    this.digitalFileReadyStorageType,
    this.images,
    this.colorImage,
    this.thumbnail,
    this.thumbnailStorageType,
    this.previewFile,
    this.previewFileStorageType,
    this.featured,
    this.flashDeal,
    this.videoProvider,
    this.videoUrl,
    this.colors,
    this.variantProduct,
    this.attributes,
    this.choiceOptions,
    this.variation,
    this.digitalProductFileTypes,
    this.digitalProductExtensions,
    this.published,
    this.unitPrice,
    this.purchasePrice,
    this.tax,
    this.taxType,
    this.taxModel,
    this.discount,
    this.discountType,
    this.currentStock,
    this.minimumOrderQty,
    this.details,
    this.freeShipping,
    this.attachment,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.featuredStatus,
    this.metaTitle,
    this.metaDescription,
    this.metaImage,
    this.requestStatus,
    this.deniedNote,
    this.shippingCost,
    this.multiplyQty,
    this.tempShippingCost,
    this.isShippingCostUpdated,
    this.code,
    this.discountedPrice,
  });

  StoreProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    addedBy = json['added_by'];
    gotiloListingId = json['gotilo_listing_id'];
    gotiloCityId = json['gotilo_city_id'];
    userId = json['user_id'];
    name = json['name'];
    slug = json['slug'];
    productType = json['product_type'];
    categoryIds = json['category_ids'];
    categoryId = json['category_id'];
    subCategoryId = json['sub_category_id'];
    subSubCategoryId = json['sub_sub_category_id'];
    brandId = json['brand_id'];
    unit = json['unit'];
    minQty = json['min_qty'];
    refundable = json['refundable'];
    digitalProductType = json['digital_product_type'];
    digitalFileReady = json['digital_file_ready'];
    digitalFileReadyStorageType = json['digital_file_ready_storage_type'];
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(Images.fromJson(v));
      });
    }
    colorImage = json['color_image'];
    thumbnail = json['thumbnail'];
    thumbnailStorageType = json['thumbnail_storage_type'];
    previewFile = json['preview_file'];
    previewFileStorageType = json['preview_file_storage_type'];
    featured = json['featured'];
    flashDeal = json['flash_deal'];
    videoProvider = json['video_provider'];
    videoUrl = json['video_url'];
    colors = json['colors'];
    variantProduct = json['variant_product'];
    attributes = json['attributes'];
    choiceOptions = json['choice_options'];
    variation = json['variation'];
    digitalProductFileTypes = json['digital_product_file_types'];
    digitalProductExtensions = json['digital_product_extensions'];
    published = json['published'];
    unitPrice = json['unit_price'];
    purchasePrice = json['purchase_price'];
    tax = json['tax'];
    taxType = json['tax_type'];
    taxModel = json['tax_model'];
    discount = json['discount'];
    discountType = json['discount_type'];
    currentStock = json['current_stock'];
    minimumOrderQty = json['minimum_order_qty'];
    details = json['details'];
    freeShipping = json['free_shipping'];
    attachment = json['attachment'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
    featuredStatus = json['featured_status'];
    metaTitle = json['meta_title'];
    metaDescription = json['meta_description'];
    metaImage = json['meta_image'];
    requestStatus = json['request_status'];
    deniedNote = json['denied_note'];
    shippingCost = json['shipping_cost'];
    multiplyQty = json['multiply_qty'];
    tempShippingCost = json['temp_shipping_cost'];
    isShippingCostUpdated = json['is_shipping_cost_updated'];
    code = json['code'];
    discountedPrice = json['discounted_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['added_by'] = addedBy;
    data['gotilo_listing_id'] = gotiloListingId;
    data['gotilo_city_id'] = gotiloCityId;
    data['user_id'] = userId;
    data['name'] = name;
    data['slug'] = slug;
    data['product_type'] = productType;
    data['category_ids'] = categoryIds;
    data['category_id'] = categoryId;
    data['sub_category_id'] = subCategoryId;
    data['sub_sub_category_id'] = subSubCategoryId;
    data['brand_id'] = brandId;
    data['unit'] = unit;
    data['min_qty'] = minQty;
    data['refundable'] = refundable;
    data['digital_product_type'] = digitalProductType;
    data['digital_file_ready'] = digitalFileReady;
    data['digital_file_ready_storage_type'] = digitalFileReadyStorageType;
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }
    data['color_image'] = colorImage;
    data['thumbnail'] = thumbnail;
    data['thumbnail_storage_type'] = thumbnailStorageType;
    data['preview_file'] = previewFile;
    data['preview_file_storage_type'] = previewFileStorageType;
    data['featured'] = featured;
    data['flash_deal'] = flashDeal;
    data['video_provider'] = videoProvider;
    data['video_url'] = videoUrl;
    data['colors'] = colors;
    data['variant_product'] = variantProduct;
    data['attributes'] = attributes;
    data['choice_options'] = choiceOptions;
    data['variation'] = variation;
    data['digital_product_file_types'] = digitalProductFileTypes;
    data['digital_product_extensions'] = digitalProductExtensions;
    data['published'] = published;
    data['unit_price'] = unitPrice;
    data['purchase_price'] = purchasePrice;
    data['tax'] = tax;
    data['tax_type'] = taxType;
    data['tax_model'] = taxModel;
    data['discount'] = discount;
    data['discount_type'] = discountType;
    data['current_stock'] = currentStock;
    data['minimum_order_qty'] = minimumOrderQty;
    data['details'] = details;
    data['free_shipping'] = freeShipping;
    data['attachment'] = attachment;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['status'] = status;
    data['featured_status'] = featuredStatus;
    data['meta_title'] = metaTitle;
    data['meta_description'] = metaDescription;
    data['meta_image'] = metaImage;
    data['request_status'] = requestStatus;
    data['denied_note'] = deniedNote;
    data['shipping_cost'] = shippingCost;
    data['multiply_qty'] = multiplyQty;
    data['temp_shipping_cost'] = tempShippingCost;
    data['is_shipping_cost_updated'] = isShippingCostUpdated;
    data['code'] = code;
    data['discounted_price'] = discountedPrice;
    return data;
  }
}

class Images {
  String? imageName;
  String? storage;
  String? url;

  Images({this.imageName, this.storage, this.url});

  Images.fromJson(Map<String, dynamic> json) {
    imageName = json['image_name'];
    storage = json['storage'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image_name'] = imageName;
    data['storage'] = storage;
    data['url'] = url;
    return data;
  }
}

class Enquiries {
  int? id;
  int? userId;
  String? fName;
  String? lName;
  String? email;
  String? phoneNumber;
  String? enquiry;
  int? status;
  String? enquiryTime;
  dynamic enquiryResTime;
  dynamic comment;
  int? vendorId;
  int? listingId;
  int? vendorSubscriptionId;
  int? vendorShow;
  String? createdAt;
  String? updatedAt;
  EnquiryListing? enquiryListing;

  Enquiries({
    this.id,
    this.userId,
    this.fName,
    this.lName,
    this.email,
    this.phoneNumber,
    this.enquiry,
    this.status,
    this.enquiryTime,
    this.enquiryResTime,
    this.comment,
    this.vendorId,
    this.listingId,
    this.vendorSubscriptionId,
    this.vendorShow,
    this.createdAt,
    this.updatedAt,
    this.enquiryListing,
  });

  Enquiries.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    fName = json['f_name'];
    lName = json['l_name'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    enquiry = json['enquiry'];
    status = json['status'];
    enquiryTime = json['enquiry_time'];
    enquiryResTime = json['enquiry_res_time'];
    comment = json['comment'];
    vendorId = json['vendor_id'];
    listingId = json['listing_id'];
    vendorSubscriptionId = json['vendor_subscription_id'];
    vendorShow = json['vendor_show'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    enquiryListing = json['enquiry_listing'] != null
        ? EnquiryListing.fromJson(json['enquiry_listing'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['f_name'] = fName;
    data['l_name'] = lName;
    data['email'] = email;
    data['phone_number'] = phoneNumber;
    data['enquiry'] = enquiry;
    data['status'] = status;
    data['enquiry_time'] = enquiryTime;
    data['enquiry_res_time'] = enquiryResTime;
    data['comment'] = comment;
    data['vendor_id'] = vendorId;
    data['listing_id'] = listingId;
    data['vendor_subscription_id'] = vendorSubscriptionId;
    data['vendor_show'] = vendorShow;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (enquiryListing != null) {
      data['enquiry_listing'] = enquiryListing!.toJson();
    }
    return data;
  }
}

class EnquiryListing {
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
  dynamic countryId;
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
  String? rewardHeaderImg;
  dynamic rewardLogoImg;
  String? rating;
  int? listingType;
  String? standyImg;
  int? standyStatus;
  dynamic facebookLink;
  dynamic instaLink;
  dynamic youtubeLink;
  dynamic linkdinLink;
  String? gst;
  String? taxPercent;
  String? adminApproveDate;
  dynamic seoData;
  String? metaTitle;
  String? metaDescription;
  String? metaKeywords;
  String? createdAt;
  String? updatedAt;

  EnquiryListing({
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
  });

  EnquiryListing.fromJson(Map<String, dynamic> json) {
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
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
    return data;
  }
}

class Rewards {
  int? userId;
  int? listingId;
  int? totalPoints;
  int? redeemedPoints;
  int? actualPoints;
  User? user;
  dynamic listings;
  RewardsListings? rewardsListings;
  RewardsVendor? rewardsVendor;

  Rewards({
    this.userId,
    this.listingId,
    this.totalPoints,
    this.redeemedPoints,
    this.actualPoints,
    this.user,
    this.listings,
    this.rewardsListings,
    this.rewardsVendor,
  });

  Rewards.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    listingId = json['listing_id'];
    totalPoints = json['total_points'];
    redeemedPoints = json['redeemed_points'];
    actualPoints = json['actual_points'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    listings = json['listings'];
    rewardsListings = json['rewards_listings'] != null
        ? RewardsListings.fromJson(json['rewards_listings'])
        : null;
    rewardsVendor = json['rewards_vendor'] != null
        ? RewardsVendor.fromJson(json['rewards_vendor'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['listing_id'] = listingId;
    data['total_points'] = totalPoints;
    data['redeemed_points'] = redeemedPoints;
    data['actual_points'] = actualPoints;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['listings'] = listings;
    if (rewardsListings != null) {
      data['rewards_listings'] = rewardsListings!.toJson();
    }
    if (rewardsVendor != null) {
      data['rewards_vendor'] = rewardsVendor!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? fName;
  String? lName;
  String? phone;

  User({this.id, this.fName, this.lName, this.phone});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fName = json['f_name'];
    lName = json['l_name'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['f_name'] = fName;
    data['l_name'] = lName;
    data['phone'] = phone;
    return data;
  }
}

class RewardsListings {
  int? id;
  String? listingTitle;
  int? vendorId;

  RewardsListings({this.id, this.listingTitle, this.vendorId});

  RewardsListings.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    listingTitle = json['listing_title'];
    vendorId = json['vendor_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['listing_title'] = listingTitle;
    data['vendor_id'] = vendorId;
    return data;
  }
}

class RewardsVendor {
  int? id;
  String? fName;
  String? lName;

  RewardsVendor({this.id, this.fName, this.lName});

  RewardsVendor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fName = json['f_name'];
    lName = json['l_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['f_name'] = fName;
    data['l_name'] = lName;
    return data;
  }
}

class BookingHistory {
  int? id;
  int? vendorId;
  int? listingId;
  int? staffId;
  int? vendorCategoryServiceId;
  int? userId;
  String? name;
  String? email;
  String? phone;
  String? address;
  String? description;
  String? startTime;
  String? endTime;
  String? bookingDate;
  String? totalAmount;
  int? status;
  String? type;
  String? createdAt;
  String? updatedAt;
  List<BookingService>? bookingService;
  BookingListing? bookingListing;
  BookingVendor? bookingVendor;

  BookingHistory({
    this.id,
    this.vendorId,
    this.listingId,
    this.staffId,
    this.vendorCategoryServiceId,
    this.userId,
    this.name,
    this.email,
    this.phone,
    this.address,
    this.description,
    this.startTime,
    this.endTime,
    this.bookingDate,
    this.totalAmount,
    this.status,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.bookingService,
    this.bookingListing,
    this.bookingVendor,
  });

  BookingHistory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vendorId = json['vendor_id'];
    listingId = json['listing_id'];
    staffId = json['staff_id'];
    vendorCategoryServiceId = json['vendor_category_service_id'];
    userId = json['user_id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
    description = json['description'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    bookingDate = json['booking_date'];
    totalAmount = json['total_amount'];
    status = json['status'];
    type = json['type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['booking_service'] != null) {
      bookingService = <BookingService>[];
      json['booking_service'].forEach((v) {
        bookingService!.add(BookingService.fromJson(v));
      });
    }
    bookingListing = json['booking_listing'] != null
        ? BookingListing.fromJson(json['booking_listing'])
        : null;
    bookingVendor = json['booking_vendor'] != null
        ? BookingVendor.fromJson(json['booking_vendor'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['vendor_id'] = vendorId;
    data['listing_id'] = listingId;
    data['staff_id'] = staffId;
    data['vendor_category_service_id'] = vendorCategoryServiceId;
    data['user_id'] = userId;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['address'] = address;
    data['description'] = description;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['booking_date'] = bookingDate;
    data['total_amount'] = totalAmount;
    data['status'] = status;
    data['type'] = type;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (bookingService != null) {
      data['booking_service'] = bookingService!.map((v) => v.toJson()).toList();
    }
    if (bookingListing != null) {
      data['booking_listing'] = bookingListing!.toJson();
    }
    if (bookingVendor != null) {
      data['booking_vendor'] = bookingVendor!.toJson();
    }
    return data;
  }
}

class BookingService {
  int? id;
  int? userBookingId;
  int? vendorListingServiceId;
  String? serviceTitle;
  String? servicePrice;
  int? duration;
  dynamic description;
  int? status;
  String? createdAt;
  String? updatedAt;

  BookingService({
    this.id,
    this.userBookingId,
    this.vendorListingServiceId,
    this.serviceTitle,
    this.servicePrice,
    this.duration,
    this.description,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  BookingService.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userBookingId = json['user_booking_id'];
    vendorListingServiceId = json['vendor_listing_service_id'];
    serviceTitle = json['service_title'];
    servicePrice = json['service_price'];
    duration = json['duration'];
    description = json['description'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_booking_id'] = userBookingId;
    data['vendor_listing_service_id'] = vendorListingServiceId;
    data['service_title'] = serviceTitle;
    data['service_price'] = servicePrice;
    data['duration'] = duration;
    data['description'] = description;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class BookingListing {
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
  String? rewardHeaderImg;
  dynamic rewardLogoImg;
  String? rating;
  int? listingType;
  String? standyImg;
  int? standyStatus;
  dynamic facebookLink;
  dynamic instaLink;
  dynamic youtubeLink;
  dynamic linkdinLink;
  String? gst;
  String? taxPercent;
  String? adminApproveDate;
  dynamic seoData;
  String? metaTitle;
  String? metaDescription;
  String? metaKeywords;
  String? createdAt;
  String? updatedAt;

  BookingListing({
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
  });

  BookingListing.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}

class BookingVendor {
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
  dynamic image;
  int? status;
  dynamic firebaseToken;
  String? authToken;
  dynamic fcmTokenWeb;
  dynamic name;
  dynamic rowId;
  dynamic website;
  dynamic address;
  dynamic cityId;
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

  BookingVendor({
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

  BookingVendor.fromJson(Map<String, dynamic> json) {
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
