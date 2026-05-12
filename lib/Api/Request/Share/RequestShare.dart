
class RequestShare {
  String? listId;

  RequestShare({this.listId});

  RequestShare.fromJson(Map<String, dynamic> json) {
    listId = json['list_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['list_id'] = this.listId;
    return data;
  }
}
