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
        listings!.add(new CollectionProductList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['message'] = this.message;
    if (this.listings != null) {
      data['listings'] = this.listings!.map((v) => v.toJson()).toList();
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

  CollectionProductList(
      {this.listingId,
        this.rating,
        this.listingTitle,
        this.address,
        this.categoryName,
        this.path,
        this.isFavourite});

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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['listing_id'] = this.listingId;
    data['rating'] = this.rating;
    data['listing_title'] = this.listingTitle;
    data['address'] = this.address;
    data['category_name'] = this.categoryName;
    data['path'] = this.path;
    data['is_favourite'] = this.isFavourite;
    return data;
  }
}
