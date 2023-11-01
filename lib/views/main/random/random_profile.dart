import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media/constants/REST_api.dart';
import 'package:social_media/views/main/random/post_types/random_user_image_posts.dart';
import 'package:social_media/views/main/random/post_types/random_user_like_posts.dart';
import 'package:social_media/views/main/random/post_types/random_user_quote_posts.dart';
import 'package:social_media/views/main/random/post_types/random_user_text_posts.dart';
import 'package:http/http.dart' as http;

import '../../../constants/global.dart';

class RandomProfile extends StatefulWidget {
  final dynamic user;
  const RandomProfile({required this.user, super.key});

  @override
  State<RandomProfile> createState() => _RandomProfileState();
}

class _RandomProfileState extends State<RandomProfile>
    with TickerProviderStateMixin {
  var posts = [];
  var isLoading = false;
  void getUserPosts() async {
    setState(() {
      isLoading = true;
    });
    http.Response res = await get("$url/posts/${widget.user["id"]}");
    posts = jsonDecode(res.body);

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getUserPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var tabController = TabController(vsync: this, length: 4);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back),
            ),
            Container(
              padding: EdgeInsets.only(right: 12),
              child: Text(
                widget.user["username"],
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ),
            Container()
          ],
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.grey,
              ),
            )
          : SafeArea(
              child: Container(
              margin: EdgeInsets.only(
                  top: 10, right: Get.width * 0.025, left: Get.width * 0.025),
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    widget.user["picture"] == null
                        ? CircleAvatar(
                            radius: 35,
                            backgroundColor: Colors.white,
                            backgroundImage:
                                AssetImage("assets/images/profile_picture.png"),
                          )
                        : CircleAvatar(
                            radius: 35,
                            backgroundColor: Colors.white,
                            backgroundImage:
                                NetworkImage(widget.user["picture"]),
                          ),
                    SizedBox(
                      width: Get.width * 0.1,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "23",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              "posts",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        SizedBox(
                          width: Get.width * 0.09,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "23",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              "Followers",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        SizedBox(
                          width: Get.width * 0.09,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "23",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              "Following",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        left: Get.width * 0.01,
                        right: Get.width * 0.01,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.user["name"],
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          SizedBox(
                            height: Get.height * 0.13,
                            child: Text(
                              widget.user["bio"] ?? "",
                              style: const TextStyle(fontSize: 16),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Container(
                  height: 50,
                  child: TabBar(controller: tabController, tabs: const [
                    Icon(Icons.text_format),
                    Icon(Icons.image),
                    Icon(Icons.question_answer),
                    Icon(Icons.thumb_up)
                  ]),
                ),
                Flexible(
                  flex: 1,
                  child: Container(
                    child: TabBarView(controller: tabController, children: [
                      RandomUserTextPosts(
                        userId: widget.user["id"],
                        userPosts: posts,
                      ),
                      RandomUserImagePosts(
                        userId: widget.user["id"],
                        userPosts: posts,
                      ),
                      RandomUserQuotePosts(),
                      RandomUserLikePosts(),
                    ]),
                  ),
                )
              ]),
            )),
    );
  }
}

class RandomUserLikePost {}
