class ResponseCollectionDetail {
  String? result;
  String? message;
  String? mainCategoryName;
  List<CollectionDetail>? collectionDetail;

  ResponseCollectionDetail({
    this.result,
    this.message,
    this.mainCategoryName,
    this.collectionDetail,
  });

  ResponseCollectionDetail.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    mainCategoryName = json['main_category_name'];
    if (json['child_categories'] != null) {
      collectionDetail = <CollectionDetail>[];
      json['child_categories'].forEach((v) {
        collectionDetail!.add(CollectionDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['result'] = result;
    data['message'] = message;
    data['main_category_name'] = mainCategoryName;
    if (collectionDetail != null) {
      data['child_categories'] = collectionDetail!
          .map((v) => v.toJson())
          .toList();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image_link'] = imageLink;
    data['parent_id'] = parentId;
    return data;
  }
}
