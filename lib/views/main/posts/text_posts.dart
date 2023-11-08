import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media/controllers/authController.dart';
import 'package:http/http.dart' as http;
import 'package:social_media/controllers/mainController.dart';
import 'package:social_media/views/main/random/post_comments.dart';

import '../../../constants/REST_api.dart';
import '../../../constants/global.dart';
import '../../../controllers/userController.dart';

class TextPosts extends StatefulWidget {
  const TextPosts({super.key});

  @override
  State<TextPosts> createState() => _TextPostsState();
}

class _TextPostsState extends State<TextPosts> {
  UserController userController = Get.put(UserController());
  AuthController authController = Get.put(AuthController());
  MainController mainController = Get.put(MainController());
  List<dynamic> textPosts = [];
  var isLoading = false;

  void getTextLikes() async {
    setState(() {
      isLoading = true;
    });
    mainController.postCommentsCount = [].obs;
    userController.likes.value = [];
    userController.isLikedByUser.value = [];
    for (int i = 0; i < userController.currentUserPosts.value.length; i++) {
      if (userController.currentUserPosts.value[i]["imageurl"] == null &&
          userController.currentUserPosts.value[i]["quotedPostId"] == null) {
        setState(() {
          textPosts.add(userController.currentUserPosts.value[i]);
        });
      }
    }

    for (var element in textPosts) {
      http.Response res = await get("$url/likes/post/${element["id"]}");
      http.Response likedByUserRes = await get(
          "$url/likes/post/likedByUser/${authController.userId.value}/${element["id"]}");

      userController.likes.value.add(res.body);
      userController.isLikedByUser.value.add(likedByUserRes.body);

      http.Response commentCountRes =
          await get("$url/comments/count/${element["id"]}");

      mainController.postCommentsCount.add(commentCountRes.body);
    }
    print(userController.likes.value);
    print(userController.isLikedByUser.value);

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

    userController.likes.value[index] = res.body;

    http.Response likedByUserRes = await get(
        "$url/likes/post/likedByUser/${authController.userId.value}/${textPosts[index]["id"]}");
    userController.isLikedByUser.value[index] = likedByUserRes.body;
    print(userController.isLikedByUser.value[index]);
    print(userController.likes.value[index]);
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

    userController.likes.value[index] = res.body;

    http.Response likedByUserRes = await get(
        "$url/likes/post/likedByUser/${authController.userId.value}/${textPosts[index]["id"]}");
    userController.isLikedByUser.value[index] = likedByUserRes.body;

    setState(() {});
  }

  @override
  void initState() {
    getTextLikes();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.grey,
              ),
            )
          : Container(
              margin: const EdgeInsets.only(top: 10),
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
                                  child: userController.currentUserData
                                              .value["picture"] ==
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
                                          child: Image.network(userController
                                              .currentUserData
                                              .value["picture"]),
                                        )),
                              SizedBox(
                                width: Get.width * 0.04,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userController
                                        .currentUserData.value["name"],
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium,
                                  ),
                                  Text(
                                    "@${userController.currentUserData.value["username"]}",
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
                                          userController.isLikedByUser
                                                      .value[index] ==
                                                  "false"
                                              ? likePost(index)
                                              : dislikePost(index);
                                        },
                                        child: Icon(userController.isLikedByUser
                                                    .value[index] ==
                                                "false"
                                            ? Icons.favorite_outline
                                            : Icons.favorite)),
                                    const SizedBox(
                                      width: 3,
                                    ),
                                    Text(
                                      userController.likes.value[index],
                                    ),
                                    SizedBox(
                                      width: Get.width * 0.1,
                                    ),
                                    InkWell(
                                        onTap: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                            builder: (context) {
                                              return PostComments(
                                                  postId: textPosts[index]
                                                      ["id"],
                                                  index: index);
                                            },
                                          ));
                                        },
                                        child: Icon(Icons.chat_bubble_outline)),
                                    const SizedBox(
                                      width: 3,
                                    ),
                                    Obx(
                                      () => Text(
                                        mainController.postCommentsCount[index],
                                      ),
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
            ),
    );
  }
}
