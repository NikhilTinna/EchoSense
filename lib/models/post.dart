class Post {
  final String? id;
  final String? description;
  final String? imageurl;
  final String? createdAt;
  final String? updatedAt;
  final String? userId;
  final String? quotedPostId;
  final User? user;
  final Post? quotePost;

  Post({
    this.id,
    this.description,
    this.imageurl,
    this.createdAt,
    this.updatedAt,
    this.userId,
    this.quotedPostId,
    this.user,
    this.quotePost,
  });

  Post copyWith({
    String? id,
    String? description,
    String? imageurl,
    String? createdAt,
    String? updatedAt,
    String? userId,
    String? quotedPostId,
    User? user,
    Post? quotePost,
  }) =>
      Post(
        id: id ?? this.id,
        description: description ?? this.description,
        imageurl: imageurl ?? this.imageurl,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        userId: userId ?? this.userId,
        quotedPostId: quotedPostId ?? this.quotedPostId,
        user: user ?? this.user,
        quotePost: quotePost ?? this.quotePost,
      );
}

class User {
  final String? id;
  final String? name;
  final String? username;
  final String? email;
  final String? password;
  final String? createdAt;
  final String? updatedAt;

  User({
    this.id,
    this.name,
    this.username,
    this.email,
    this.password,
    this.createdAt,
    this.updatedAt,
  });

  User copyWith({
    String? id,
    String? name,
    String? username,
    String? email,
    String? password,
    String? createdAt,
    String? updatedAt,
  }) =>
      User(
        id: id ?? this.id,
        name: name ?? this.name,
        username: username ?? this.username,
        email: email ?? this.email,
        password: password ?? this.password,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
}
