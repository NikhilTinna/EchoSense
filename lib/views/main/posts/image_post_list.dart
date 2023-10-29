import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:social_media/constants/REST_api.dart';
import 'package:social_media/constants/global.dart';
import 'package:social_media/controllers/authController.dart';
import 'package:social_media/controllers/userController.dart';
import 'package:http/http.dart' as http;

class ImagePostList extends StatefulWidget {
  final List<dynamic> images;
  final int count;

  ImagePostList(this.images, this.count);

  @override
  State<ImagePostList> createState() => _ImagePostListState();
}

class _ImagePostListState extends State<ImagePostList> {
  UserController userController = Get.put(UserController());
  AuthController authController = Get.put(AuthController());
  ItemScrollController itemScrollController = ItemScrollController();
  var isLoading = false;
  void getImageLikes() async {
    userController.likes.value = [];
    userController.isLikedByUser.value = [];
    setState(() {
      isLoading = true;
    });
    for (var element in widget.images) {
      http.Response res = await get("$url/likes/post/${element["id"]}");
      http.Response likedByUserRes = await get(
          "$url/likes/post/likedByUser/${authController.userId.value}/${element["id"]}");

      userController.likes.value.add(res.body);
      userController.isLikedByUser.value.add(likedByUserRes.body);
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
          "postId": widget.images[index]["id"]
        }),
        success: () {});

    http.Response res =
        await get("$url/likes/post/${widget.images[index]["id"]}");

    userController.likes.value[index] = res.body;

    http.Response likedByUserRes = await get(
        "$url/likes/post/likedByUser/${authController.userId.value}/${widget.images[index]["id"]}");
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
          "postId": widget.images[index]["id"]
        }),
        success: () {});

    http.Response res =
        await get("$url/likes/post/${widget.images[index]["id"]}");
    print(res.body);
    userController.likes.value[index] = res.body;

    http.Response likedByUserRes = await get(
        "$url/likes/post/likedByUser/${authController.userId.value}/${widget.images[index]["id"]}");
    userController.isLikedByUser.value[index] = likedByUserRes.body;
    print(userController.isLikedByUser.value[index]);
    print(userController.likes.value[index]);
    setState(() {});
  }

  @override
  void initState() {
    getImageLikes();
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
          : SafeArea(
              child: Container(
              margin: EdgeInsets.only(
                  top: 10, left: Get.width * 0.025, right: Get.width * 0.025),
              child: ScrollablePositionedList.builder(
                  itemScrollController: itemScrollController,
                  initialScrollIndex: widget.count,
                  itemCount: widget.images.length,
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
                                width: Get.width * 0.02,
                              ),
                              Container(
                                  width: Get.width * 0.79,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                  )),
                            ],
                          ),
                          SizedBox(
                            height: Get.height * 0.01,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: Get.width * 0.15),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      widget.images[index]["description"],
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      widget.images[index][
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
                                            userController.isLikedByUser
                                                        .value[index] ==
                                                    "false"
                                                ? likePost(index)
                                                : dislikePost(index);
                                          },
                                          child: Icon(userController
                                                      .isLikedByUser
                                                      .value[index] ==
                                                  "false"
                                              ? Icons.favorite_outline
                                              : Icons.favorite)),
                                    ),
                                    const SizedBox(
                                      width: 3,
                                    ),
                                    Obx(
                                      () => Text(
                                        userController.likes.value[index],
                                      ),
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
