class RequestSimilarListing {
  int? listId;
  int? userId;

  RequestSimilarListing({this.listId, this.userId});

  RequestSimilarListing.fromJson(Map<String, dynamic> json) {
    listId = json['list_id'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['list_id'] = this.listId;
    data['user_id'] = this.userId;
    return data;
  }
}
