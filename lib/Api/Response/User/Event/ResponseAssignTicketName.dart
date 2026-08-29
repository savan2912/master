class ResponseAssignTicketName {
  String? result;
  int? ticketId;
  String? userName;
  String? message;

  ResponseAssignTicketName(
      {this.result, this.ticketId, this.userName, this.message});

  ResponseAssignTicketName.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    ticketId = json['ticketId'];
    userName = json['user_name'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['ticketId'] = this.ticketId;
    data['user_name'] = this.userName;
    data['message'] = this.message;
    return data;
  }
}
