class ResponseShare {
  String? result;
  String? message;
  ShareData? data;

  ResponseShare({this.result, this.message, this.data});

  ResponseShare.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    data = json['data'] != null ? new ShareData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ShareData {
  String? webUrl;
  String? appUrl;
  String? shareMessage;

  ShareData({this.webUrl, this.appUrl, this.shareMessage});

  ShareData.fromJson(Map<String, dynamic> json) {
    webUrl = json['web_url'];
    appUrl = json['app_url'];
    shareMessage = json['share_message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['web_url'] = this.webUrl;
    data['app_url'] = this.appUrl;
    data['share_message'] = this.shareMessage;
    return data;
  }
}
