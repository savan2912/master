
class RequestAddEnquiry {
  String? userId;
  int? listingId;
  String? fName;
  String? lName;
  String? email;
  String? phone;
  String? enquiry;

  RequestAddEnquiry(
      {this.userId,
        this.listingId,
        this.fName,
        this.lName,
        this.email,
        this.phone,
        this.enquiry});

  RequestAddEnquiry.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    listingId = json['listing_id'];
    fName = json['f_name'];
    lName = json['l_name'];
    email = json['email'];
    phone = json['phone'];
    enquiry = json['enquiry'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['listing_id'] = this.listingId;
    data['f_name'] = this.fName;
    data['l_name'] = this.lName;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['enquiry'] = this.enquiry;
    return data;
  }
}
