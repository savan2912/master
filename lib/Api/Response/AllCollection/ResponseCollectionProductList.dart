class ResponseCollectionProductList {
  String? result;
  String? message;
  List<CollectionProductList>? listings;

  ResponseCollectionProductList({this.result, this.message, this.listings});

  ResponseCollectionProductList.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    if (json['listings'] != null) {
      listings = <CollectionProductList>[];
      json['listings'].forEach((v) {
        listings!.add(CollectionProductList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['result'] = result;
    data['message'] = message;
    if (listings != null) {
      data['listings'] = listings!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CollectionProductList {
  int? listingId;
  String? rating;
  String? listingTitle;
  String? address;
  String? categoryName;
  String? path;
  int? isFavourite;

  CollectionProductList({
    this.listingId,
    this.rating,
    this.listingTitle,
    this.address,
    this.categoryName,
    this.path,
    this.isFavourite,
  });

  CollectionProductList.fromJson(Map<String, dynamic> json) {
    listingId = json['listing_id'];
    rating = json['rating'];
    listingTitle = json['listing_title'];
    address = json['address'];
    categoryName = json['category_name'];
    path = json['path'];
    isFavourite = json['is_favourite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['listing_id'] = listingId;
    data['rating'] = rating;
    data['listing_title'] = listingTitle;
    data['address'] = address;
    data['category_name'] = categoryName;
    data['path'] = path;
    data['is_favourite'] = isFavourite;
    return data;
  }
}
