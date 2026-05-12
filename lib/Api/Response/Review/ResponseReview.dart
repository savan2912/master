class ResponseReview {
  String? result;
  String? message;
  List<ReviewData>? data;
  dynamic averageRating;

  ResponseReview({this.result, this.message, this.data, this.averageRating});

  ResponseReview.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ReviewData>[];
      json['data'].forEach((v) {
        data!.add(new ReviewData.fromJson(v));
      });
    }
    averageRating = json['average_rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['average_rating'] = this.averageRating;
    return data;
  }
}

class ReviewData {
  int? id;
  String? title;
  String? review;
  String? rating;
  int? listingId;
  int? userId;
  int? status;
  String? createdAt;
  String? updatedAt;

  ReviewData(
      {this.id,
        this.title,
        this.review,
        this.rating,
        this.listingId,
        this.userId,
        this.status,
        this.createdAt,
        this.updatedAt});

  ReviewData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    review = json['review'];
    rating = json['rating'];
    listingId = json['listing_id'];
    userId = json['user_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['review'] = this.review;
    data['rating'] = this.rating;
    data['listing_id'] = this.listingId;
    data['user_id'] = this.userId;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
