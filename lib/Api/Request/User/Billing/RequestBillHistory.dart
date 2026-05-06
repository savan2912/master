class RequestBillHistory {
  String? cashierBillsId;

  RequestBillHistory({this.cashierBillsId});

  RequestBillHistory.fromJson(Map<String, dynamic> json) {
    cashierBillsId = json['cashier_bills_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cashier_bills_id'] = this.cashierBillsId;
    return data;
  }
}
