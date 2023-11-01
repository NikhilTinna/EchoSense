import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../constants/REST_api.dart';
import '../../../../constants/global.dart';
import '../../../../controllers/authController.dart';

class RandomUserLikePosts extends StatefulWidget {
  final String userId;
  final List likePosts;
  const RandomUserLikePosts(
      {required this.userId, required this.likePosts, super.key});

  @override
  State<RandomUserLikePosts> createState() => _RandomUserLikePostsState();
}

class _RandomUserLikePostsState extends State<RandomUserLikePosts> {
  AuthController authController = Get.put(AuthController());
  var likes = [];
  var isLikedByUser = [];
  var isLoading = false;
  var likingPosts = [];

  void getPostsData() async {
    likingPosts = widget.likePosts;
    setState(() {
      isLoading = true;
    });

    for (var element in likingPosts) {
      http.Response res = await get("$url/likes/post/${element["post"]["id"]}");
      http.Response likedByUserRes = await get(
          "$url/likes/post/likedByUser/${authController.userId.value}/${element["post"]["id"]}");

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
          "postId": likingPosts[index]["post"]["id"]
        }),
        success: () {});

    http.Response res =
        await get("$url/likes/post/${likingPosts[index]["post"]["id"]}");

    likes[index] = res.body;

    http.Response likedByUserRes = await get(
        "$url/likes/post/likedByUser/${authController.userId.value}/${likingPosts[index]["post"]["id"]}");
    isLikedByUser[index] = likedByUserRes.body;

    setState(() {});
  }

  void dislikePost(int index) async {
    http.Response resLike = await post(
        endpoint: "$url/likes/post/remove",
        body: jsonEncode({
          "userId": authController.userId.value,
          "postId": likingPosts[index]["post"]["id"]
        }),
        success: () {});

    http.Response res =
        await get("$url/likes/post/${likingPosts[index]["post"]["id"]}");

    likes[index] = res.body;

    http.Response likedByUserRes = await get(
        "$url/likes/post/likedByUser/${authController.userId.value}/${likingPosts[index]["post"]["id"]}");
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
                  itemCount: likingPosts.length,
                  itemBuilder: (context, index) {
                    return likingPosts[index]["post"]["quotedPostId"] != null
                        ? Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        width: Get.width * 0.12,
                                        child: likingPosts[index]["post"]
                                                    ["user"]["picture"] ==
                                                null
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Image.asset(
                                                  'assets/images/profile_picture.png',
                                                  fit: BoxFit.fill,
                                                ),
                                              )
                                            : ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Image.network(
                                                    likingPosts[index]["post"]
                                                        ["user"]["picture"]),
                                              )),
                                    SizedBox(
                                      width: Get.width * 0.04,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          likingPosts[index]["post"]["user"]
                                              ["name"],
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayMedium,
                                        ),
                                        Text(
                                          "@${likingPosts[index]["post"]["user"]["username"]}",
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
                                  margin:
                                      EdgeInsets.only(left: Get.width * 0.17),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Flexible(
                                            child: Text(
                                              likingPosts[index]["post"]
                                                  ["description"],
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
                                      likingPosts[index]["post"]["imageurl"] !=
                                              null
                                          ? Column(
                                              children: [
                                                Container(
                                                  constraints: BoxConstraints(
                                                      maxHeight:
                                                          Get.height * 0.45,
                                                      minWidth: Get.width),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: Image.network(
                                                      likingPosts[index]["post"]
                                                          [
                                                          "imageurl"], // Replace with the path to your image
                                                      fit: BoxFit
                                                          .fill, // Use BoxFit.fill to force the image to fill the container
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                              ],
                                            )
                                          : Container(),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 0.5,
                                                  color: Colors.grey),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                      width: Get.width * 0.08,
                                                      child: likingPosts[index][
                                                                          "post"]
                                                                      [
                                                                      "quotePost"]
                                                                  [
                                                                  "user"]["picture"] ==
                                                              null
                                                          ? ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              child:
                                                                  Image.asset(
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
                                                                  likingPosts[index]
                                                                              [
                                                                              "post"]
                                                                          [
                                                                          "quotePost"]["user"]
                                                                      [
                                                                      "picture"]),
                                                            )),
                                                  SizedBox(
                                                    width: Get.width * 0.03,
                                                  ),
                                                  Text(
                                                    likingPosts[index]["post"]
                                                            ["quotePost"]
                                                        ["user"]["name"],
                                                    style: const TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  SizedBox(
                                                    width: Get.width * 0.03,
                                                  ),
                                                  Text(
                                                      "@${likingPosts[index]["post"]["quotePost"]["user"]["username"]}",
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.grey)),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                children: [
                                                  Flexible(
                                                    child: Text(
                                                      likingPosts[index]["post"]
                                                              ["quotePost"]
                                                          ["description"],
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              likingPosts[index]["post"]
                                                              ["quotePost"]
                                                          ["imageurl"] !=
                                                      null
                                                  ? Column(
                                                      children: [
                                                        Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            child:
                                                                Image.network(
                                                              likingPosts[index]
                                                                          [
                                                                          "post"]
                                                                      [
                                                                      "quotePost"]
                                                                  [
                                                                  "imageurl"], // Replace with the path to your image
                                                              fit: BoxFit
                                                                  .fill, // Use BoxFit.fill to force the image to fill the container
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                      ],
                                                    )
                                                  : Container(),
                                            ],
                                          )),
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
                                                  isLikedByUser[index] ==
                                                          "false"
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
                          )
                        : Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        width: Get.width * 0.12,
                                        child: likingPosts[index]["post"]
                                                    ["user"]["picture"] ==
                                                null
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Image.asset(
                                                  'assets/images/profile_picture.png',
                                                  fit: BoxFit.fill,
                                                ),
                                              )
                                            : ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Image.network(
                                                    likingPosts[index]["post"]
                                                        ["user"]["picture"]),
                                              )),
                                    SizedBox(
                                      width: Get.width * 0.04,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          likingPosts[index]["post"]["user"]
                                              ["name"],
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayMedium,
                                        ),
                                        Text(
                                          "@${likingPosts[index]["post"]["user"]["username"]}",
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
                                  margin:
                                      EdgeInsets.only(left: Get.width * 0.17),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Flexible(
                                            child: Text(
                                              likingPosts[index]["post"]
                                                  ["description"],
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
                                      likingPosts[index]["post"]["imageurl"] !=
                                              null
                                          ? Column(
                                              children: [
                                                Container(
                                                  constraints: BoxConstraints(
                                                      maxHeight:
                                                          Get.height * 0.45,
                                                      minWidth: Get.width),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: Image.network(
                                                      likingPosts[index]["post"]
                                                          [
                                                          "imageurl"], // Replace with the path to your image
                                                      fit: BoxFit
                                                          .fill, // Use BoxFit.fill to force the image to fill the container
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                              ],
                                            )
                                          : Container(),
                                      const SizedBox(
                                        height: 10,
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
                                                  isLikedByUser[index] ==
                                                          "false"
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
