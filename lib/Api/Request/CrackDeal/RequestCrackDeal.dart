
class RequestCrackDeal {
  String? userId;
  String? dealId;

  RequestCrackDeal({this.userId, this.dealId});

  RequestCrackDeal.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    dealId = json['deal_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['deal_id'] = this.dealId;
    return data;
  }
}
