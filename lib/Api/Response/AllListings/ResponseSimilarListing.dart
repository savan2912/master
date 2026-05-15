class ResponseSimilarListing {
  String? result;
  String? message;
  List<SimilarListing>? data;

  ResponseSimilarListing({this.result, this.message, this.data});

  ResponseSimilarListing.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    if (json['data'] != null) {
      data = <SimilarListing>[];
      json['data'].forEach((v) {
        data!.add(new SimilarListing.fromJson(v));
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

class SimilarListing {
  int? id;
  String? listingTitle;
  String? address;
  String? image;

  SimilarListing({this.id, this.listingTitle, this.address, this.image});

  SimilarListing.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    listingTitle = json['listing_title'];
    address = json['address'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['listing_title'] = this.listingTitle;
    data['address'] = this.address;
    data['image'] = this.image;
    return data;
  }
}
