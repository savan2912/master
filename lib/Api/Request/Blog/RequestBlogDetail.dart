class RequestBlogDetail {
  int? blogId;

  RequestBlogDetail({this.blogId});

  RequestBlogDetail.fromJson(Map<String, dynamic> json) {
    blogId = json['blog_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['blog_id'] = blogId;
    return data;
  }
}
