class ResponseFavData {
  String? result;
  String? message;
  List<FavData>? data;

  ResponseFavData({this.result, this.message, this.data});

  ResponseFavData.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    if (json['data'] != null) {
      data = <FavData>[];
      json['data'].forEach((v) {
        data!.add(new FavData.fromJson(v));
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

class FavData {
  int? listingId;
  String? listingName;
  String? address;
  String? rating;
  String? city;
  String? image;

  FavData(
      {this.listingId,
        this.listingName,
        this.address,
        this.rating,
        this.city,
        this.image});

  FavData.fromJson(Map<String, dynamic> json) {
    listingId = json['listing_id'];
    listingName = json['listing_name'];
    address = json['address'];
    rating = json['rating'];
    city = json['city'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['listing_id'] = this.listingId;
    data['listing_name'] = this.listingName;
    data['address'] = this.address;
    data['rating'] = this.rating;
    data['city'] = this.city;
    data['image'] = this.image;
    return data;
  }
}
