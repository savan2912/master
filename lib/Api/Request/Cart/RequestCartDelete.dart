class RequestCartDelete {
  String? userId;
  String? id;

  RequestCartDelete({this.userId, this.id});

  RequestCartDelete.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['id'] = this.id;
    return data;
  }
}
