class Post {
  String? id;
  String? description;
  String? imageurl;
  String? userId;
  Null? quotedPostId;
  User? user;
  Null? quotePost;

  Post(
      {this.id,
      this.description,
      this.imageurl,
      this.userId,
      this.quotedPostId,
      this.user,
      this.quotePost});

  Post.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    imageurl = json['imageurl'];
    userId = json['userId'];
    quotedPostId = json['quotedPostId'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    quotePost = json['quotePost'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['description'] = this.description;
    data['imageurl'] = this.imageurl;
    data['userId'] = this.userId;
    data['quotedPostId'] = this.quotedPostId;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['quotePost'] = this.quotePost;
    return data;
  }
}

class User {
  String? id;
  String? name;
  String? username;
  String? email;
  String? password;
  String? createdAt;
  String? updatedAt;

  User(
      {this.id,
      this.name,
      this.username,
      this.email,
      this.password,
      this.createdAt,
      this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    username = json['username'];
    email = json['email'];
    password = json['password'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['username'] = this.username;
    data['email'] = this.email;
    data['password'] = this.password;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
