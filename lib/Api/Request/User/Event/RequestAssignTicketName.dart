class RequestAssignTicketName {
  String? userId;
  String? ticketId;
  String? userName;

  RequestAssignTicketName({this.userId, this.ticketId, this.userName});

  RequestAssignTicketName.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    ticketId = json['ticket_id'];
    userName = json['user_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['ticket_id'] = this.ticketId;
    data['user_name'] = this.userName;
    return data;
  }
}
