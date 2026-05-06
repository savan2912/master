class RequestSubCategoryListDetails {
  int? listId;
  int? userID;

  RequestSubCategoryListDetails({this.listId, this.userID});

  RequestSubCategoryListDetails.fromJson(Map<String, dynamic> json) {
    listId = json['list_id'];
    userID = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['list_id'] = listId;
    data['user_id'] = userID;
    return data;
  }
}
