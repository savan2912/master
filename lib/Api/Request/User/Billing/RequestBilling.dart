class RequestBilling {
  String? userId;
  String? counter;
  String? search;
  String? startDate;
  String? endDate;

  RequestBilling(
      {this.userId, this.counter, this.search,
        this.startDate, this.endDate
      });

  RequestBilling.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    counter = json['counter'];
    search = json['search'];
    startDate = json['start_date'];
    endDate = json['end_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['counter'] = this.counter;
    data['search'] = this.search;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    return data;
  }
}
