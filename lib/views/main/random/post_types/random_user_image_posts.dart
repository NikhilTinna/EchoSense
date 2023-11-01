import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:social_media/views/main/random/post_types/random_image_post_details.dart';

import '../../../../constants/REST_api.dart';
import '../../../../constants/global.dart';
import '../../../../controllers/authController.dart';

class RandomUserImagePosts extends StatefulWidget {
  final String userId;
  final List userPosts;
  const RandomUserImagePosts(
      {required this.userId, required this.userPosts, super.key});

  @override
  State<RandomUserImagePosts> createState() => _RandomUserImagePostsState();
}

class _RandomUserImagePostsState extends State<RandomUserImagePosts> {
  AuthController authController = Get.put(AuthController());
  var likes = [];
  var isLikedByUser = [];
  var isLoading = false;
  var imagePosts = [];
  void getPostsData() async {
    setState(() {
      isLoading = true;
    });
    imagePosts = widget.userPosts
        .where((element) =>
            element["imageurl"] != null && element["quotedPostId"] == null)
        .toList();

    for (var element in imagePosts) {
      http.Response res = await get("$url/likes/post/${element["id"]}");
      http.Response likedByUserRes = await get(
          "$url/likes/post/likedByUser/${authController.userId.value}/${element["id"]}");

      likes.add(res.body);
      isLikedByUser.add(likedByUserRes.body);
    }
    setState(() {
      isLoading = false;
    });
  }

  void likePost(int index) async {
    http.Response resLike = await post(
        endpoint: "$url/likes/post",
        body: jsonEncode({
          "userId": authController.userId.value,
          "postId": imagePosts[index]["id"]
        }),
        success: () {});

    http.Response res = await get("$url/likes/post/${imagePosts[index]["id"]}");

    likes[index] = res.body;

    http.Response likedByUserRes = await get(
        "$url/likes/post/likedByUser/${authController.userId.value}/${imagePosts[index]["id"]}");
    isLikedByUser[index] = likedByUserRes.body;

    setState(() {});
  }

  void dislikePost(int index) async {
    http.Response resLike = await post(
        endpoint: "$url/likes/post/remove",
        body: jsonEncode({
          "userId": authController.userId.value,
          "postId": imagePosts[index]["id"]
        }),
        success: () {});

    http.Response res = await get("$url/likes/post/${imagePosts[index]["id"]}");

    likes[index] = res.body;

    http.Response likedByUserRes = await get(
        "$url/likes/post/likedByUser/${authController.userId.value}/${imagePosts[index]["id"]}");
    isLikedByUser[index] = likedByUserRes.body;

    setState(() {});
  }

  @override
  void initState() {
    getPostsData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.grey,
              ),
            )
          : SafeArea(
              child: Container(
              margin: const EdgeInsets.only(top: 10),
              child: GridView.builder(
                  itemCount: imagePosts.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return RandomImagePostDetails(
                              userId: widget.userId,
                              imagePosts: imagePosts,
                              count: index);
                        }));
                      },
                      child: Container(
                        margin: const EdgeInsets.only(
                            top: 3, bottom: 3, left: 1.5, right: 1.5),
                        child: Image.network(
                          imagePosts[index][
                              "imageurl"], // Replace with the path to your image
                          fit: BoxFit
                              .fill, // Use BoxFit.fill to force the image to fill the container
                        ),
                      ),
                    );
                  }),
            )),
    );
  }
}
