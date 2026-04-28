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
        data!.add(new Menu.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['message'] = this.message;
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

  Menu(
      {this.id,
        this.menuName,
        this.routeName,
        this.icon,
        this.position,
        this.status,
        this.createdAt,
        this.updatedAt});

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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['menu_name'] = this.menuName;
    data['route_name'] = this.routeName;
    data['icon'] = this.icon;
    data['position'] = this.position;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
