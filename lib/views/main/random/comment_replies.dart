// ignore_for_file: unnecessary_string_interpolations, unnecessary_brace_in_string_interps

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media/constants/REST_api.dart';
import 'package:social_media/constants/global.dart';

import 'package:http/http.dart' as http;
import 'package:social_media/controllers/userController.dart';

import '../../../controllers/authController.dart';
import '../../../controllers/mainController.dart';

class CommentReplies extends StatefulWidget {
  final String commentId;
  final String postId;
  final int index;
  const CommentReplies(
      {required this.postId, required this.commentId, required this.index});

  @override
  State<CommentReplies> createState() => _CommentRepliesState();
}

class _CommentRepliesState extends State<CommentReplies> {
  AuthController authController = Get.put(AuthController());
  MainController mainController = Get.put(MainController());
  bool isLoading = false;
  final replyController = TextEditingController();

  List replies = [];
  List replyLikes = [];
  List isReplyLikedByUser = [];

  void getComments() async {
    setState(() {
      isLoading = true;
    });

    http.Response res = await get("$url/replies/${widget.commentId}");

    replies = jsonDecode(res.body);
    for (var element in replies) {
      http.Response res = await get("$url/likes/reply/${element["id"]}");
      replyLikes.add(res.body);
      http.Response isLikedByUserRes = await get(
          "$url/likes/reply/likedByUser/${authController.userId.value}/${element["id"]}");
      isReplyLikedByUser.add(isLikedByUserRes.body);
    }

    setState(() {
      isLoading = false;
    });
  }

  void likeReply(int index) async {
    http.Response resLike = await post(
        endpoint: "$url/likes/reply",
        body: jsonEncode({
          "userId": authController.userId.value,
          "replyId": replies[index]["id"]
        }),
        success: () {});

    http.Response res = await get("$url/likes/reply/${replies[index]["id"]}");
    http.Response likedByUserRes = await get(
        "$url/likes/reply/likedByUser/${authController.userId.value}/${replies[index]["id"]}");
    setState(() {
      replyLikes[index] = res.body;
      isReplyLikedByUser[index] = likedByUserRes.body;
    });
  }

  void dislikeReply(int index) async {
    http.Response resLike = await post(
        endpoint: "$url/likes/reply/remove",
        body: jsonEncode({
          "userId": authController.userId.value,
          "replyId": replies[index]["id"]
        }),
        success: () {});

    http.Response res = await get("$url/likes/reply/${replies[index]["id"]}");
    http.Response likedByUserRes = await get(
        "$url/likes/reply/likedByUser/${authController.userId.value}/${replies[index]["id"]}");
    setState(() {
      replyLikes[index] = res.body;
      isReplyLikedByUser[index] = likedByUserRes.body;
    });
  }

  @override
  void initState() {
    getComments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Text("Replies"),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Container(
              margin: EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                  left: Get.width * 0.025,
                  right: Get.width * 0.025),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: replies.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              ListTile(
                                leading: replies[index]["user"]["picture"] ==
                                        null
                                    ? const CircleAvatar(
                                        backgroundImage: AssetImage(
                                            "assets/images/profile_picture.png"))
                                    : CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            replies[index]["user"]["picture"])),
                                title: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${replies[index]["user"]["username"]}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayMedium,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "${replies[index]["description"].toString()}",
                                        style: TextStyle(),
                                      ),
                                    ],
                                  ),
                                ),
                                trailing: Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        if (isReplyLikedByUser[index] ==
                                            "false") {
                                          likeReply(index);
                                        } else {
                                          dislikeReply(index);
                                        }
                                      },
                                      child: Icon(
                                          isReplyLikedByUser[index] == "false"
                                              ? Icons.favorite_outline
                                              : Icons.favorite),
                                    ),
                                    Text(replyLikes[index])
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                            ],
                          );
                        }),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: replyController,
                          decoration:
                              const InputDecoration(hintText: "Enter reply.."),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      InkWell(
                          onTap: () async {
                            if (replyController.text.isNotEmpty) {
                              await post(
                                  endpoint: "$url/replies/",
                                  body: jsonEncode({
                                    "description": replyController.text,
                                    "userId": authController.userId.value,
                                    "postId": widget.postId,
                                    "commentId": widget.commentId,
                                  }),
                                  success: () {});

                              http.Response res =
                                  await get("$url/replies/${widget.commentId}");

                              replies = [];
                              replyLikes = [];
                              isReplyLikedByUser = [];

                              replies = jsonDecode(res.body);
                              for (var element in replies) {
                                http.Response res = await get(
                                    "$url/likes/reply/${element["id"]}");
                                replyLikes.add(res.body);
                                http.Response isLikedByUserRes = await get(
                                    "$url/likes/reply/likedByUser/${authController.userId.value}/${element["id"]}");
                                isReplyLikedByUser.add(isLikedByUserRes.body);
                              }
                              http.Response replyCountResponse = await get(
                                  "$url/replies/count/${widget.commentId}");

                              setState(() {
                                mainController
                                        .commentRepliesCount[widget.index] =
                                    replyCountResponse.body;
                              });

                              setState(() {});
                            }
                            replyController.text = "";
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          child: const Icon(Icons.send)),
                    ],
                  )
                ],
              ),
            )),
    );
  }
}
