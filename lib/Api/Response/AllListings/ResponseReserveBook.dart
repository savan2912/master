class ResponseReserveBook {
  String? result;
  String? message;
  HotelDesign? data;

  ResponseReserveBook({this.result, this.message, this.data});

  ResponseReserveBook.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    data = json['data'] != null ? HotelDesign.fromJson(json['data']) : null;
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

class HotelDesign {
  Hotel? hotel;
  AdditionalServices? additionalServices;
  List<Amenities>? amenities;
  List<Gallery>? gallery;
  Reviews? reviews;
  ContentProvider? contentProvider;
  ProviderDetails? providerDetails;
  SocialLinks? socialLinks;
  Stay? stay;
  List<Rooms>? rooms;

  HotelDesign({
    this.hotel,
    this.additionalServices,
    this.amenities,
    this.gallery,
    this.reviews,
    this.contentProvider,
    this.providerDetails,
    this.socialLinks,
    this.stay,
    this.rooms,
  });

  HotelDesign.fromJson(Map<String, dynamic> json) {
    hotel = json['hotel'] != null ? Hotel.fromJson(json['hotel']) : null;
    additionalServices = json['additional_services'] != null
        ? AdditionalServices.fromJson(json['additional_services'])
        : null;
    if (json['amenities'] != null) {
      amenities = <Amenities>[];
      json['amenities'].forEach((v) {
        amenities!.add(Amenities.fromJson(v));
      });
    }
    if (json['gallery'] != null) {
      gallery = <Gallery>[];
      json['gallery'].forEach((v) {
        gallery!.add(Gallery.fromJson(v));
      });
    }
    reviews =
    json['reviews'] != null ? Reviews.fromJson(json['reviews']) : null;
    contentProvider = json['content_provider'] != null
        ? ContentProvider.fromJson(json['content_provider'])
        : null;
    providerDetails = json['provider_details'] != null
        ? ProviderDetails.fromJson(json['provider_details'])
        : null;
    socialLinks = json['social_links'] != null
        ? SocialLinks.fromJson(json['social_links'])
        : null;
    stay = json['stay'] != null ? Stay.fromJson(json['stay']) : null;
    if (json['rooms'] != null) {
      rooms = <Rooms>[];
      json['rooms'].forEach((v) {
        rooms!.add(Rooms.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (hotel != null) {
      data['hotel'] = hotel!.toJson();
    }
    if (additionalServices != null) {
      data['additional_services'] = additionalServices!.toJson();
    }
    if (amenities != null) {
      data['amenities'] = amenities!.map((v) => v.toJson()).toList();
    }
    if (gallery != null) {
      data['gallery'] = gallery!.map((v) => v.toJson()).toList();
    }
    if (reviews != null) {
      data['reviews'] = reviews!.toJson();
    }
    if (contentProvider != null) {
      data['content_provider'] = contentProvider!.toJson();
    }
    if (providerDetails != null) {
      data['provider_details'] = providerDetails!.toJson();
    }
    if (socialLinks != null) {
      data['social_links'] = socialLinks!.toJson();
    }
    if (stay != null) {
      data['stay'] = stay!.toJson();
    }
    if (rooms != null) {
      data['rooms'] = rooms!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Hotel {
  int? listingId;
  int? hotelMasterId;
  String? title;
  String? hotelType;
  String? foodType;
  String? address;
  String? rulesAndRegulations;
  String? checkIn;
  String? checkOut;
  String? starRating;
  String? overview;
  String? startingPrice;

  Hotel({
    this.listingId,
    this.hotelMasterId,
    this.title,
    this.hotelType,
    this.foodType,
    this.address,
    this.rulesAndRegulations,
    this.checkIn,
    this.checkOut,
    this.starRating,
    this.overview,
    this.startingPrice,
  });

  Hotel.fromJson(Map<String, dynamic> json) {
    listingId = json['listing_id'];
    hotelMasterId = json['hotel_master_id'];
    title = json['title'];
    hotelType = json['hotel_type'];
    foodType = json['food_type'];
    address = json['address'];
    rulesAndRegulations = json['rules_and_regulations'];
    checkIn = json['check_in'];
    checkOut = json['check_out'];
    starRating = json['star_rating'];
    overview = json['overview'];
    startingPrice = json['starting_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['listing_id'] = listingId;
    data['hotel_master_id'] = hotelMasterId;
    data['title'] = title;
    data['hotel_type'] = hotelType;
    data['food_type'] = foodType;
    data['address'] = address;
    data['rules_and_regulations'] = rulesAndRegulations;
    data['check_in'] = checkIn;
    data['check_out'] = checkOut;
    data['star_rating'] = starRating;
    data['overview'] = overview;
    data['starting_price'] = startingPrice;
    return data;
  }
}

class AdditionalServices {
  List<HotelServices>? hotelServices;
  List<RoomServices>? roomServices;

  AdditionalServices({this.hotelServices, this.roomServices});

  AdditionalServices.fromJson(Map<String, dynamic> json) {
    if (json['hotel_services'] != null) {
      hotelServices = <HotelServices>[];
      json['hotel_services'].forEach((v) {
        hotelServices!.add(HotelServices.fromJson(v));
      });
    }
    if (json['room_services'] != null) {
      roomServices = <RoomServices>[];
      json['room_services'].forEach((v) {
        roomServices!.add(RoomServices.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (hotelServices != null) {
      data['hotel_services'] = hotelServices!.map((v) => v.toJson()).toList();
    }
    if (roomServices != null) {
      data['room_services'] = roomServices!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class HotelServices {
  int? id;
  String? title;
  String? description;
  String? price;

  HotelServices({this.id, this.title, this.description, this.price});

  HotelServices.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['price'] = price;
    return data;
  }
}

class RoomServices {
  int? id;
  String? title;
  String? description;
  String? price;

  RoomServices({this.id, this.title, this.description, this.price});

  RoomServices.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['price'] = price;
    return data;
  }
}

class Amenities {
  int? id;
  String? name;
  String? icon;

  Amenities({this.id, this.name, this.icon});

  Amenities.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['icon'] = icon;
    return data;
  }
}

class Gallery {
  int? id;
  String? image;

  Gallery({this.id, this.image});

  Gallery.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['image'] = image;
    return data;
  }
}

class Reviews {
  num? rating;
  int? totalReviews;
  List<dynamic>? reviewList;

  Reviews({this.rating, this.totalReviews, this.reviewList});

  Reviews.fromJson(Map<String, dynamic> json) {
    rating = json['rating'];
    totalReviews = json['total_reviews'];
    reviewList = json['review_list'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rating'] = rating;
    data['total_reviews'] = totalReviews;
    if (reviewList != null) {
      data['review_list'] = reviewList;
    }
    return data;
  }
}

class ContentProvider {
  String? name;
  num? rating;
  String? email;
  String? phone;
  String? gstNo;
  bool? showEmail;

  ContentProvider({
    this.name,
    this.rating,
    this.email,
    this.phone,
    this.gstNo,
    this.showEmail,
  });

  ContentProvider.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    rating = json['rating'];
    email = json['email'];
    phone = json['phone'];
    gstNo = json['gst_no'];
    showEmail = json['show_email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['rating'] = rating;
    data['email'] = email;
    data['phone'] = phone;
    data['gst_no'] = gstNo;
    data['show_email'] = showEmail;
    return data;
  }
}

class ProviderDetails {
  String? email;
  String? phone;
  String? address;
  String? latitude;
  String? longitude;
  String? googleMap;
  bool? viewEmail;
  bool? viewPhone;

  ProviderDetails({
    this.email,
    this.phone,
    this.address,
    this.latitude,
    this.longitude,
    this.googleMap,
    this.viewEmail,
    this.viewPhone,
  });

  ProviderDetails.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    googleMap = json['google_map'];
    viewEmail = json['view_email'];
    viewPhone = json['view_phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['phone'] = phone;
    data['address'] = address;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['google_map'] = googleMap;
    data['view_email'] = viewEmail;
    data['view_phone'] = viewPhone;
    return data;
  }
}

class SocialLinks {
  String? facebook;
  String? instagram;
  String? youtube;
  String? linkedin;

  SocialLinks({this.facebook, this.instagram, this.youtube, this.linkedin});

  SocialLinks.fromJson(Map<String, dynamic> json) {
    facebook = json['facebook'];
    instagram = json['instagram'];
    youtube = json['youtube'];
    linkedin = json['linkedin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['facebook'] = facebook;
    data['instagram'] = instagram;
    data['youtube'] = youtube;
    data['linkedin'] = linkedin;
    return data;
  }
}

class Stay {
  String? checkin;
  String? checkout;
  int? adults;
  int? childs;
  int? totalNights;

  Stay({
    this.checkin,
    this.checkout,
    this.adults,
    this.childs,
    this.totalNights,
  });

  Stay.fromJson(Map<String, dynamic> json) {
    checkin = json['checkin'];
    checkout = json['checkout'];
    adults = json['adults'];
    childs = json['childs'];
    totalNights = json['total_nights'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['checkin'] = checkin;
    data['checkout'] = checkout;
    data['adults'] = adults;
    data['childs'] = childs;
    data['total_nights'] = totalNights;
    return data;
  }
}

class Rooms {
  int? roomId;
  String? roomName;
  String? roomSize;
  String? roomType;
  String? description;
  String? bedType;
  String? viewType;
  int? numberOfBeds;
  int? maxAdults;
  int? maxChildren;
  int? requiredRooms;
  int? availableRooms;
  bool? isAvailable;
  int? extraBedAllowed;
  num? extraBedCharge;
  int? totalExtraBedNumber;
  List<MattressOptions>? mattressOptions;
  List<String>? images;
  List<Amenities>? amenities;
  List<Plans>? plans;

  Rooms({
    this.roomId,
    this.roomName,
    this.roomSize,
    this.roomType,
    this.description,
    this.bedType,
    this.viewType,
    this.numberOfBeds,
    this.maxAdults,
    this.maxChildren,
    this.requiredRooms,
    this.availableRooms,
    this.isAvailable,
    this.extraBedAllowed,
    this.extraBedCharge,
    this.totalExtraBedNumber,
    this.mattressOptions,
    this.images,
    this.amenities,
    this.plans,
  });

  Rooms.fromJson(Map<String, dynamic> json) {
    roomId = json['room_id'];
    roomName = json['room_name'];
    roomSize = json['room_size'];
    roomType = json['room_type'];
    description = json['description'];
    bedType = json['bed_type'];
    viewType = json['view_type'];
    numberOfBeds = json['number_of_beds'];
    maxAdults = json['max_adults'];
    maxChildren = json['max_children'];
    requiredRooms = json['required_rooms'];
    availableRooms = json['available_rooms'];
    isAvailable = json['is_available'];
    extraBedAllowed = json['extra_bed_allowed'];
    extraBedCharge = json['extra_bed_charge'];
    totalExtraBedNumber = json['total_extra_bed_number'];
    if (json['mattress_options'] != null) {
      mattressOptions = <MattressOptions>[];
      json['mattress_options'].forEach((v) {
        mattressOptions!.add(MattressOptions.fromJson(v));
      });
    }
    images = json['images'] != null ? List<String>.from(json['images']) : [];
    if (json['amenities'] != null) {
      amenities = <Amenities>[];
      json['amenities'].forEach((v) {
        amenities!.add(Amenities.fromJson(v));
      });
    }
    if (json['plans'] != null) {
      plans = <Plans>[];
      json['plans'].forEach((v) {
        plans!.add(Plans.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['room_id'] = roomId;
    data['room_name'] = roomName;
    data['room_size'] = roomSize;
    data['room_type'] = roomType;
    data['description'] = description;
    data['bed_type'] = bedType;
    data['view_type'] = viewType;
    data['number_of_beds'] = numberOfBeds;
    data['max_adults'] = maxAdults;
    data['max_children'] = maxChildren;
    data['required_rooms'] = requiredRooms;
    data['available_rooms'] = availableRooms;
    data['is_available'] = isAvailable;
    data['extra_bed_allowed'] = extraBedAllowed;
    data['extra_bed_charge'] = extraBedCharge;
    data['total_extra_bed_number'] = totalExtraBedNumber;
    if (mattressOptions != null) {
      data['mattress_options'] =
          mattressOptions!.map((v) => v.toJson()).toList();
    }
    data['images'] = images;
    if (amenities != null) {
      data['amenities'] = amenities!.map((v) => v.toJson()).toList();
    }
    if (plans != null) {
      data['plans'] = plans!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MattressOptions {
  int? quantity;
  num? pricePerNight;
  num? totalPrice;
  String? label;

  MattressOptions({
    this.quantity,
    this.pricePerNight,
    this.totalPrice,
    this.label,
  });

  MattressOptions.fromJson(Map<String, dynamic> json) {
    quantity = json['quantity'];
    pricePerNight = json['price_per_night'];
    totalPrice = json['total_price'];
    label = json['label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['quantity'] = quantity;
    data['price_per_night'] = pricePerNight;
    data['total_price'] = totalPrice;
    data['label'] = label;
    return data;
  }
}

class Plans {
  int? planId;
  String? planName;
  String? feature;
  String? description;
  int? stayNights;
  num? pricePerNight;
  Map<String, dynamic>? dateWisePrices;
  num? totalAmount;
  bool? isAvailable;
  Mattress? mattress;

  Plans({
    this.planId,
    this.planName,
    this.feature,
    this.description,
    this.stayNights,
    this.pricePerNight,
    this.dateWisePrices,
    this.totalAmount,
    this.isAvailable,
    this.mattress,
  });

  Plans.fromJson(Map<String, dynamic> json) {
    planId = json['plan_id'];
    planName = json['plan_name'];
    feature = json['feature'];
    description = json['description'];
    stayNights = json['stay_nights'];
    pricePerNight = json['price_per_night'];
    dateWisePrices = json['date_wise_prices'] != null
        ? Map<String, dynamic>.from(json['date_wise_prices'])
        : null;
    totalAmount = json['total_amount'];
    isAvailable = json['is_available'];
    mattress =
    json['mattress'] != null ? Mattress.fromJson(json['mattress']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['plan_id'] = planId;
    data['plan_name'] = planName;
    data['feature'] = feature;
    data['description'] = description;
    data['stay_nights'] = stayNights;
    data['price_per_night'] = pricePerNight;
    data['date_wise_prices'] = dateWisePrices;
    data['total_amount'] = totalAmount;
    data['is_available'] = isAvailable;
    if (mattress != null) {
      data['mattress'] = mattress!.toJson();
    }
    return data;
  }
}

class Mattress {
  int? allowed;
  num? pricePerUnitPerNight;
  int? maxQuantity;
  int? stayNights;
  String? calculation;

  Mattress({
    this.allowed,
    this.pricePerUnitPerNight,
    this.maxQuantity,
    this.stayNights,
    this.calculation,
  });

  Mattress.fromJson(Map<String, dynamic> json) {
    allowed = json['allowed'];
    pricePerUnitPerNight = json['price_per_unit_per_night'];
    maxQuantity = json['max_quantity'];
    stayNights = json['stay_nights'];
    calculation = json['calculation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['allowed'] = allowed;
    data['price_per_unit_per_night'] = pricePerUnitPerNight;
    data['max_quantity'] = maxQuantity;
    data['stay_nights'] = stayNights;
    data['calculation'] = calculation;
    return data;
  }
}