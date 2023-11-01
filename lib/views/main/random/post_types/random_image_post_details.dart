import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../../constants/REST_api.dart';
import '../../../../constants/global.dart';
import '../../../../controllers/authController.dart';

class RandomImagePostDetails extends StatefulWidget {
  final String userId;
  final List imagePosts;
  final int count;
  const RandomImagePostDetails(
      {required this.userId,
      required this.imagePosts,
      required this.count,
      super.key});

  @override
  State<RandomImagePostDetails> createState() => _RandomImagePostDetailsState();
}

class _RandomImagePostDetailsState extends State<RandomImagePostDetails> {
  AuthController authController = Get.put(AuthController());
  var likes = [];
  var isLikedByUser = [];
  var isLoading = false;

  final itemScrollController = ItemScrollController();

  void getPostsData() async {
    setState(() {
      isLoading = true;
    });

    for (var element in widget.imagePosts) {
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
          "postId": widget.imagePosts[index]["id"]
        }),
        success: () {});

    http.Response res =
        await get("$url/likes/post/${widget.imagePosts[index]["id"]}");

    likes[index] = res.body;

    http.Response likedByUserRes = await get(
        "$url/likes/post/likedByUser/${authController.userId.value}/${widget.imagePosts[index]["id"]}");
    isLikedByUser[index] = likedByUserRes.body;

    setState(() {});
  }

  void dislikePost(int index) async {
    http.Response resLike = await post(
        endpoint: "$url/likes/post/remove",
        body: jsonEncode({
          "userId": authController.userId.value,
          "postId": widget.imagePosts[index]["id"]
        }),
        success: () {});

    http.Response res =
        await get("$url/likes/post/${widget.imagePosts[index]["id"]}");

    likes[index] = res.body;

    http.Response likedByUserRes = await get(
        "$url/likes/post/likedByUser/${authController.userId.value}/${widget.imagePosts[index]["id"]}");
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
              child: ScrollablePositionedList.builder(
                  itemScrollController: itemScrollController,
                  initialScrollIndex: widget.count,
                  itemCount: widget.imagePosts.length,
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
                                  child: widget.imagePosts[index]["user"]
                                              ["imageurl"] ==
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
                                          child: Image.network(
                                              widget.imagePosts[index]["user"]
                                                  ["imageurl"]),
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
                                        widget.imagePosts[index]["user"]
                                            ["name"],
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayMedium,
                                      ),
                                      Text(
                                        "@${widget.imagePosts[index]["user"]["username"]}",
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
                                      widget.imagePosts[index]["description"],
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
                                      widget.imagePosts[index][
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
