import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media/controllers/userController.dart';
import 'package:http/http.dart' as http;
import '../../../constants/REST_api.dart';
import '../../../constants/global.dart';
import '../../../controllers/authController.dart';
import '../../../controllers/mainController.dart';

class Feed extends StatefulWidget {
  const Feed({super.key});

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  AuthController authController = Get.put(AuthController());
  MainController mainController = Get.put(MainController());

  var isLoading = false;
  var posts = [];
  void getAllPostsData() async {
    mainController.isLoading.value = true;
    http.Response res =
        await get("$url/posts/random/${authController.userId.value}");

    mainController.posts.value = await jsonDecode(res.body);

    for (int i = 0; i < mainController.posts.value.length; i++) {
      posts.add(mainController.posts.value[i]);
    }
  }

  void getPostLikes() async {
    mainController.likes.value = [];
    mainController.isLikedByUser.value = [];

    for (var element in mainController.posts) {
      http.Response res = await get("$url/likes/post/${element["id"]}");
      http.Response likedByUserRes = await get(
          "$url/likes/post/likedByUser/${authController.userId.value}/${element["id"]}");

      mainController.likes.value.add(res.body);
      mainController.isLikedByUser.value.add(likedByUserRes.body);
    }
    print(mainController.likes.value);
    print(mainController.isLikedByUser.value);
    setState(() {
      mainController.isLoading.value = false;
    });
  }

  void likePost(int index) async {
    http.Response resLike = await post(
        endpoint: "$url/likes/post",
        body: jsonEncode({
          "userId": authController.userId.value,
          "postId": mainController.posts.value[index]["id"]
        }),
        success: () {});

    http.Response res =
        await get("$url/likes/post/${mainController.posts.value[index]["id"]}");

    mainController.likes.value[index] = res.body;

    http.Response likedByUserRes = await get(
        "$url/likes/post/likedByUser/${authController.userId.value}/${mainController.posts.value[index]["id"]}");
    mainController.isLikedByUser.value[index] = likedByUserRes.body;

    setState(() {});
  }

  void dislikePost(int index) async {
    http.Response resLike = await post(
        endpoint: "$url/likes/post/remove",
        body: jsonEncode({
          "userId": authController.userId.value,
          "postId": mainController.posts.value[index]["id"]
        }),
        success: () {});

    http.Response res =
        await get("$url/likes/post/${mainController.posts.value[index]["id"]}");

    mainController.likes.value[index] = res.body;

    http.Response likedByUserRes = await get(
        "$url/likes/post/likedByUser/${authController.userId.value}/${mainController.posts.value[index]["id"]}");
    mainController.isLikedByUser.value[index] = likedByUserRes.body;

    setState(() {});
  }

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    getAllPostsData();
    getPostLikes();
    setState(() {
      isLoading = false;
    });
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
                margin: const EdgeInsets.only(
                  top: 10,
                ),
                child: Column(
                  children: [
                    Flexible(
                      flex: 1,
                      child: isLoading == false
                          ? ListView.builder(
                              itemCount: posts.length,
                              itemBuilder: (context, index) {
                                return posts[index]["imageurl"] == null
                                    ? Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 12),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    width: Get.width * 0.12,
                                                    child: posts[index]["user"]
                                                                ["picture"] ==
                                                            null
                                                        ? ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            child: Image.asset(
                                                              'assets/images/profile_picture.png', // Replace with the path to your image
                                                              fit: BoxFit
                                                                  .fill, // Use BoxFit.fill to force the image to fill the container
                                                            ),
                                                          )
                                                        : ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            child: Image.network(
                                                                posts[index]
                                                                        ["user"]
                                                                    [
                                                                    "picture"]),
                                                          )),
                                                SizedBox(
                                                  width: Get.width * 0.04,
                                                ),
                                                Container(
                                                    width: Get.width * 0.77,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          posts[index]["user"]
                                                              ["name"],
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .displayMedium,
                                                        ),
                                                        Text(
                                                          "@${posts[index]["user"]["username"]}",
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .displaySmall,
                                                        ),
                                                        const SizedBox(
                                                          height: 15,
                                                        ),
                                                      ],
                                                    )),
                                              ],
                                            ),
                                            SizedBox(
                                              height: Get.height * 0.01,
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: Get.width * 0.17),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Flexible(
                                                        child: Text(
                                                          posts[index]
                                                              ["description"],
                                                          style:
                                                              Theme.of(context)
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
                                                      Obx(
                                                        () => InkWell(
                                                            onTap: () async {
                                                              mainController.isLikedByUser
                                                                              .value[
                                                                          index] ==
                                                                      "false"
                                                                  ? likePost(
                                                                      index)
                                                                  : dislikePost(
                                                                      index);
                                                            },
                                                            child: Icon(mainController
                                                                            .isLikedByUser
                                                                            .value[
                                                                        index] ==
                                                                    "false"
                                                                ? Icons
                                                                    .favorite_outline
                                                                : Icons
                                                                    .favorite)),
                                                      ),
                                                      const SizedBox(
                                                        width: 3,
                                                      ),
                                                      Obx(
                                                        () => Text(
                                                          mainController.likes
                                                              .value[index],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: Get.width * 0.1,
                                                      ),
                                                      const Icon(Icons
                                                          .chat_bubble_outline),
                                                      const SizedBox(
                                                        width: 3,
                                                      ),
                                                      const Text(
                                                        "0",
                                                      ),
                                                      SizedBox(
                                                        width: Get.width * 0.1,
                                                      ),
                                                      const Icon(Icons
                                                          .replay_outlined),
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
                                      )
                                    : Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 12),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    width: Get.width * 0.12,
                                                    child: posts[index]["user"]
                                                                ["picture"] ==
                                                            null
                                                        ? ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            child: Image.asset(
                                                              'assets/images/profile_picture.png', // Replace with the path to your image
                                                              fit: BoxFit
                                                                  .fill, // Use BoxFit.fill to force the image to fill the container
                                                            ),
                                                          )
                                                        : ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            child: Image.network(
                                                                posts[index]
                                                                        ["user"]
                                                                    [
                                                                    "picture"]),
                                                          )),
                                                SizedBox(
                                                  width: Get.width * 0.04,
                                                ),
                                                Container(
                                                    width: Get.width * 0.77,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          posts[index]["user"]
                                                              ["name"],
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .displayMedium,
                                                        ),
                                                        Text(
                                                          "@${posts[index]["user"]["username"]}",
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .displaySmall,
                                                        ),
                                                        const SizedBox(
                                                          height: 15,
                                                        ),
                                                      ],
                                                    )),
                                              ],
                                            ),
                                            SizedBox(
                                              height: Get.height * 0.01,
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: Get.width * 0.17),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Flexible(
                                                        child: Text(
                                                          posts[index]
                                                              ["description"],
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyMedium,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      child: Image.network(
                                                        posts[index][
                                                            "imageurl"], // Replace with the path to your image
                                                        fit: BoxFit
                                                            .fill, // Use BoxFit.fill to force the image to fill the container
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Obx(
                                                        () => InkWell(
                                                            onTap: () async {
                                                              mainController.isLikedByUser
                                                                              .value[
                                                                          index] ==
                                                                      "false"
                                                                  ? likePost(
                                                                      index)
                                                                  : dislikePost(
                                                                      index);
                                                            },
                                                            child: Icon(mainController
                                                                            .isLikedByUser
                                                                            .value[
                                                                        index] ==
                                                                    "false"
                                                                ? Icons
                                                                    .favorite_outline
                                                                : Icons
                                                                    .favorite)),
                                                      ),
                                                      const SizedBox(
                                                        width: 3,
                                                      ),
                                                      Obx(
                                                        () => Text(
                                                          mainController.likes
                                                              .value[index],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: Get.width * 0.1,
                                                      ),
                                                      const Icon(Icons
                                                          .chat_bubble_outline),
                                                      const SizedBox(
                                                        width: 3,
                                                      ),
                                                      const Text(
                                                        "0",
                                                      ),
                                                      SizedBox(
                                                        width: Get.width * 0.1,
                                                      ),
                                                      const Icon(Icons
                                                          .replay_outlined),
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
                              })
                          : Container(),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
