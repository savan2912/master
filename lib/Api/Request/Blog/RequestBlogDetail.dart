class RequestBlogDetail {
  int? blogId;

  RequestBlogDetail({this.blogId});

  RequestBlogDetail.fromJson(Map<String, dynamic> json) {
    blogId = json['blog_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['blog_id'] = this.blogId;
    return data;
  }
}
