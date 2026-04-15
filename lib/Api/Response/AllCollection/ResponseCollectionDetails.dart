class ResponseCollectionDetail {
  String? result;
  String? message;
  String? mainCategoryName;
  List<CollectionDetail>? collectionDetail;

  ResponseCollectionDetail(
      {this.result, this.message, this.mainCategoryName, this.collectionDetail});

  ResponseCollectionDetail.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    mainCategoryName = json['main_category_name'];
    if (json['child_categories'] != null) {
      collectionDetail = <CollectionDetail>[];
      json['child_categories'].forEach((v) {
        collectionDetail!.add(new CollectionDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['message'] = this.message;
    data['main_category_name'] = this.mainCategoryName;
    if (this.collectionDetail != null) {
      data['child_categories'] =
          this.collectionDetail!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CollectionDetail {
  int? id;
  String? name;
  String? imageLink;
  int? parentId;

  CollectionDetail({this.id, this.name, this.imageLink, this.parentId});

  CollectionDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    imageLink = json['image_link'];
    parentId = json['parent_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image_link'] = this.imageLink;
    data['parent_id'] = this.parentId;
    return data;
  }
}
