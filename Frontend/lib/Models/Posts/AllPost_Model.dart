class AllPostModel {
  bool? success;
  int? postsCount;
  List<Post>? post;

  AllPostModel({this.success, this.postsCount, this.post});

  AllPostModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    postsCount = json['postsCount'];
    if (json['post'] != null) {
      post = <Post>[];
      json['post'].forEach((v) {
        post!.add(new Post.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['postsCount'] = this.postsCount;
    if (this.post != null) {
      data['post'] = this.post!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Post {
  String? sId;
  List<String>? imageUrl;
  List<String>? fileName;
  String? createdAt;
  String? updatedAt;

  Post(
      {this.sId, this.imageUrl, this.fileName, this.createdAt, this.updatedAt});

  Post.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    imageUrl = json['imageUrl'].cast<String>();
    fileName = json['fileName'].cast<String>();
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['imageUrl'] = this.imageUrl;
    data['fileName'] = this.fileName;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
