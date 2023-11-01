import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../constants/REST_api.dart';
import '../../../../constants/global.dart';
import '../../../../controllers/authController.dart';

class RandomUserTextPosts extends StatefulWidget {
  final String userId;
  final List userPosts;
  const RandomUserTextPosts(
      {required this.userId, required this.userPosts, super.key});

  @override
  State<RandomUserTextPosts> createState() => _RandomUserTextPostsState();
}

class _RandomUserTextPostsState extends State<RandomUserTextPosts> {
  AuthController authController = Get.put(AuthController());
  var likes = [];
  var isLikedByUser = [];
  var isLoading = false;
  var textPosts = [];
  void getPostsData() async {
    setState(() {
      isLoading = true;
    });
    textPosts = widget.userPosts
        .where((element) =>
            element["imageurl"] == null && element["quotedPostId"] == null)
        .toList();

    for (var element in textPosts) {
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
          "postId": textPosts[index]["id"]
        }),
        success: () {});

    http.Response res = await get("$url/likes/post/${textPosts[index]["id"]}");

    likes[index] = res.body;

    http.Response likedByUserRes = await get(
        "$url/likes/post/likedByUser/${authController.userId.value}/${textPosts[index]["id"]}");
    isLikedByUser[index] = likedByUserRes.body;

    setState(() {});
  }

  void dislikePost(int index) async {
    http.Response resLike = await post(
        endpoint: "$url/likes/post/remove",
        body: jsonEncode({
          "userId": authController.userId.value,
          "postId": textPosts[index]["id"]
        }),
        success: () {});

    http.Response res = await get("$url/likes/post/${textPosts[index]["id"]}");

    likes[index] = res.body;

    http.Response likedByUserRes = await get(
        "$url/likes/post/likedByUser/${authController.userId.value}/${textPosts[index]["id"]}");
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
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.grey,
              ),
            )
          : SafeArea(
              child: Container(
              margin: EdgeInsets.only(top: 10),
              child: ListView.builder(
                  itemCount: textPosts.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10)),
                                  width: Get.width * 0.12,
                                  child: textPosts[index]["user"]["picture"] ==
                                          null
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.asset(
                                            'assets/images/profile_picture.png', // Replace with the path to your image
                                            fit: BoxFit
                                                .fill, // Use BoxFit.fill to force the image to fill the container
                                          ),
                                        )
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.network(textPosts[index]
                                              ["user"]["picture"]),
                                        )),
                              SizedBox(
                                width: Get.width * 0.04,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    textPosts[index]["user"]["name"],
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium,
                                  ),
                                  Text(
                                    "@${textPosts[index]["user"]["username"]}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall,
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: Get.height * 0.01,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: Get.width * 0.17),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        textPosts[index]["description"],
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    InkWell(
                                        onTap: () async {
                                          isLikedByUser[index] == "false"
                                              ? likePost(index)
                                              : dislikePost(index);
                                        },
                                        child: Icon(
                                            isLikedByUser[index] == "false"
                                                ? Icons.favorite_outline
                                                : Icons.favorite)),
                                    const SizedBox(
                                      width: 3,
                                    ),
                                    Text(
                                      likes[index],
                                    ),
                                    SizedBox(
                                      width: Get.width * 0.1,
                                    ),
                                    const Icon(Icons.chat_bubble_outline),
                                    const SizedBox(
                                      width: 3,
                                    ),
                                    const Text(
                                      "0",
                                    ),
                                    SizedBox(
                                      width: Get.width * 0.1,
                                    ),
                                    const Icon(Icons.replay_outlined),
                                    const SizedBox(
                                      width: 3,
                                    ),
                                    const Text(
                                      "0",
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const Divider(
                            color: Colors.grey,
                          )
                        ],
                      ),
                    );
                  }),
            )),
    );
  }
}
