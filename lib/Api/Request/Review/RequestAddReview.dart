class RequestAddReview {
  String? userId;
  String? title;
  String? review;
  String? rating;
  String? listingId;

  RequestAddReview(
      {this.userId, this.title, this.review, this.rating, this.listingId});

  RequestAddReview.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    title = json['title'];
    review = json['review'];
    rating = json['rating'];
    listingId = json['listing_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['title'] = this.title;
    data['review'] = this.review;
    data['rating'] = this.rating;
    data['listing_id'] = this.listingId;
    return data;
  }
}
