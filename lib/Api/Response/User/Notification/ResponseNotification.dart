class ResponseNotification {
  String? result;
  String? message;
  List<NotificationData>? data;

  ResponseNotification({this.result, this.message, this.data});

  ResponseNotification.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    if (json['data'] != null) {
      data = <NotificationData>[];
      json['data'].forEach((v) {
        data!.add(NotificationData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['result'] = result;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NotificationData {
  int? id;
  String? senderType;
  int? senderId;
  List<String>? listingId;
  String? targetType;
  String? notificationTitle;
  String? notificationDesc;
  String? priority;
  String? image;
  String? buttonText;
  String? buttonLink;
  String? sendDate;
  String? status;
  int? notifyStatus;
  String? createdAt;
  String? updatedAt;
  int? userId;
  int? notificationId;
  int? readId;
  String? readAt;
  int? readFlag;

  NotificationData({
    this.id,
    this.senderType,
    this.senderId,
    this.listingId,
    this.targetType,
    this.notificationTitle,
    this.notificationDesc,
    this.priority,
    this.image,
    this.buttonText,
    this.buttonLink,
    this.sendDate,
    this.status,
    this.notifyStatus,
    this.createdAt,
    this.updatedAt,
    this.userId,
    this.notificationId,
    this.readId,
    this.readAt,
    this.readFlag,
  });

  NotificationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    senderType = json['sender_type'];
    senderId = json['sender_id'];
    listingId = json['listing_id'].cast<String>();
    targetType = json['target_type'];
    notificationTitle = json['notification_title'];
    notificationDesc = json['notification_desc'];
    priority = json['priority'];
    image = json['image'];
    buttonText = json['button_text'];
    buttonLink = json['button_link'];
    sendDate = json['send_date'];
    status = json['status'];
    notifyStatus = json['notify_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    userId = json['user_id'];
    notificationId = json['notification_id'];
    readId = json['read_id'];
    readAt = json['read_at'];
    readFlag = json['read_flag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sender_type'] = senderType;
    data['sender_id'] = senderId;
    data['listing_id'] = listingId;
    data['target_type'] = targetType;
    data['notification_title'] = notificationTitle;
    data['notification_desc'] = notificationDesc;
    data['priority'] = priority;
    data['image'] = image;
    data['button_text'] = buttonText;
    data['button_link'] = buttonLink;
    data['send_date'] = sendDate;
    data['status'] = status;
    data['notify_status'] = notifyStatus;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['user_id'] = userId;
    data['notification_id'] = notificationId;
    data['read_id'] = readId;
    data['read_at'] = readAt;
    data['read_flag'] = readFlag;
    return data;
  }
}
