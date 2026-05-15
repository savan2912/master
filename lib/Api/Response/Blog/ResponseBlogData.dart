class ResponseBlogsData {
  String? result;
  String? message;
  BlogsData? data;

  ResponseBlogsData({this.result, this.message, this.data});

  ResponseBlogsData.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    data = json['data'] != null ? new BlogsData.fromJson(json['data']) : null;
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

class BlogsData {
  int? total;
  List<Blogs>? blogs;

  BlogsData({this.total, this.blogs});

  BlogsData.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    if (json['blogs'] != null) {
      blogs = <Blogs>[];
      json['blogs'].forEach((v) {
        blogs!.add(new Blogs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    if (this.blogs != null) {
      data['blogs'] = this.blogs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Blogs {
  int? id;
  String? blogTitle;
  String? slug;
  String? blogDesc;
  String? blogImage;
  int? status;
  String? createdAt;
  String? updatedAt;

  Blogs(
      {this.id,
        this.blogTitle,
        this.slug,
        this.blogDesc,
        this.blogImage,
        this.status,
        this.createdAt,
        this.updatedAt});

  Blogs.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    blogTitle = json['blog_title'];
    slug = json['slug'];
    blogDesc = json['blog_desc'];
    blogImage = json['blog_image'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['blog_title'] = this.blogTitle;
    data['slug'] = this.slug;
    data['blog_desc'] = this.blogDesc;
    data['blog_image'] = this.blogImage;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
