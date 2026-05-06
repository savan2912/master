class ResponseMenu {
  String? result;
  String? message;
  List<Menu>? data;

  ResponseMenu({this.result, this.message, this.data});

  ResponseMenu.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Menu>[];
      json['data'].forEach((v) {
        data!.add(Menu.fromJson(v));
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

class Menu {
  int? id;
  String? menuName;
  String? routeName;
  String? icon;
  int? position;
  int? status;
  String? createdAt;
  String? updatedAt;

  Menu({
    this.id,
    this.menuName,
    this.routeName,
    this.icon,
    this.position,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  Menu.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    menuName = json['menu_name'];
    routeName = json['route_name'];
    icon = json['icon'];
    position = json['position'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['menu_name'] = menuName;
    data['route_name'] = routeName;
    data['icon'] = icon;
    data['position'] = position;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
