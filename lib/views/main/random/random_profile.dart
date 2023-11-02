import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media/constants/REST_api.dart';
import 'package:social_media/views/main/random/post_types/random_user_image_posts.dart';
import 'package:social_media/views/main/random/post_types/random_user_like_posts.dart';
import 'package:social_media/views/main/random/post_types/random_user_quote_posts.dart';
import 'package:social_media/views/main/random/post_types/random_user_text_posts.dart';
import 'package:http/http.dart' as http;
import 'package:social_media/views/main/random/random_user_followers.dart';
import 'package:social_media/views/main/random/random_user_following.dart';

import '../../../constants/global.dart';
import '../../../controllers/authController.dart';

class RandomProfile extends StatefulWidget {
  final dynamic user;
  const RandomProfile({required this.user, super.key});

  @override
  State<RandomProfile> createState() => _RandomProfileState();
}

class _RandomProfileState extends State<RandomProfile>
    with TickerProviderStateMixin {
  AuthController authController = Get.put(AuthController());
  var posts = [];
  var likedPosts = [];
  var isLoading = false;
  var profileIndex = 0.obs;
  var postCount = 0;
  final scrollController = ScrollController();

  var userFollowerDetails = [].obs;
  var userFollowingDetails = [].obs;
  var isFollowing = false.obs;
  void getUserPosts() async {
    setState(() {
      isLoading = true;
    });
    http.Response res = await get("$url/posts/${widget.user["id"]}");
    posts = jsonDecode(res.body);
    http.Response likedRes =
        await get("$url/likes/posts/user/${widget.user["id"]}");
    likedPosts = jsonDecode(likedRes.body);

//get user followers;
    http.Response followerRes =
        await get("$url/following/follow/following/${widget.user["id"]}");
    userFollowerDetails.value = jsonDecode(followerRes.body);

//get user following
    http.Response followingRes =
        await get("$url/following/follow/follower/${widget.user["id"]}");
    userFollowingDetails.value = jsonDecode(followingRes.body);

    http.Response isFollowRes = await get(
        "$url/following/isFollow/${authController.userId.value}/${widget.user["id"]}");
    isFollowing.value = jsonDecode(isFollowRes.body);

    http.Response postCountResponse =
        await get("$url/posts/count/${widget.user["id"]}");
    postCount = jsonDecode(postCountResponse.body);

    print(isFollowing);
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
              child: const Icon(Icons.arrow_back),
            ),
            Container(
              padding: const EdgeInsets.only(right: 12),
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
          ? const Center(
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
                        ? const CircleAvatar(
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
                              postCount.toString(),
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
                        InkWell(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return RandomUserFollowers(
                                randomUserFollowers: userFollowerDetails[1],
                                name: widget.user["name"],
                              );
                            }));
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Obx(
                                () => Text(
                                  userFollowerDetails[0].toString(),
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                              Text(
                                "Followers",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: Get.width * 0.09,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return RandomUserFollowing(
                                randomUserFollowing: userFollowingDetails[1],
                                name: widget.user["name"],
                              );
                            }));
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Obx(
                                () => Text(
                                  userFollowingDetails[0].toString(),
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                              Text(
                                "Following",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: Get.width * 0.01,
                    right: Get.width * 0.01,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: Get.height * 0.16,
                        child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            controller: scrollController,
                            scrollDirection: Axis.horizontal,
                            itemCount: 2,
                            itemBuilder: (context, index) {
                              return index == 0
                                  ? Container(
                                      width: Get.width * 0.94,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                widget.user["name"],
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displayMedium,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  scrollController.animateTo(
                                                      (1) * Get.width * 0.95,
                                                      duration: const Duration(
                                                          milliseconds: 500),
                                                      curve: Curves.ease);

                                                  profileIndex.value = 1;
                                                },
                                                child: const Row(children: [
                                                  Text("Bio "),
                                                  Icon(
                                                    Icons
                                                        .arrow_forward_outlined,
                                                    color: Colors.blue,
                                                  )
                                                ]),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: Get.width * 0.46,
                                                child: Obx(
                                                  () {
                                                    if (isFollowing.value ==
                                                        false) {
                                                      return ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            textStyle:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                            primary:
                                                                Colors.green,
                                                            onPrimary:
                                                                Colors.white,
                                                          ),
                                                          onPressed: () async {
                                                            await post(
                                                                endpoint:
                                                                    "$url/following/follow",
                                                                body:
                                                                    jsonEncode({
                                                                  "followerId":
                                                                      authController
                                                                          .userId
                                                                          .value,
                                                                  "followingId":
                                                                      widget.user[
                                                                          "id"]
                                                                }),
                                                                success: () {});
                                                            //get user followers;
                                                            http.Response
                                                                followerRes =
                                                                await get(
                                                                    "$url/following/follow/following/${widget.user["id"]}");
                                                            userFollowerDetails
                                                                    .value =
                                                                jsonDecode(
                                                                    followerRes
                                                                        .body);

//get user following
                                                            http.Response
                                                                followingRes =
                                                                await get(
                                                                    "$url/following/follow/follower/${widget.user["id"]}");
                                                            userFollowingDetails
                                                                    .value =
                                                                jsonDecode(
                                                                    followingRes
                                                                        .body);

                                                            http.Response
                                                                isFollowRes =
                                                                await get(
                                                                    "$url/following/isFollow/${authController.userId.value}/${widget.user["id"]}");
                                                            isFollowing.value =
                                                                jsonDecode(
                                                                    isFollowRes
                                                                        .body);
                                                          },
                                                          child: const Text(
                                                              "Follow"));
                                                    } else {
                                                      return ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            textStyle:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                            primary: Colors.red,
                                                            onPrimary:
                                                                Colors.white,
                                                          ),
                                                          onPressed: () async {
                                                            await post(
                                                                endpoint:
                                                                    "$url/following/unfollow",
                                                                body:
                                                                    jsonEncode({
                                                                  "followerId":
                                                                      authController
                                                                          .userId
                                                                          .value,
                                                                  "followingId":
                                                                      widget.user[
                                                                          "id"]
                                                                }),
                                                                success: () {});
                                                            //get user followers;
                                                            http.Response
                                                                followerRes =
                                                                await get(
                                                                    "$url/following/follow/following/${widget.user["id"]}");
                                                            userFollowerDetails
                                                                    .value =
                                                                jsonDecode(
                                                                    followerRes
                                                                        .body);

//get user following
                                                            http.Response
                                                                followingRes =
                                                                await get(
                                                                    "$url/following/follow/follower/${widget.user["id"]}");
                                                            userFollowingDetails
                                                                    .value =
                                                                jsonDecode(
                                                                    followingRes
                                                                        .body);

                                                            http.Response
                                                                isFollowRes =
                                                                await get(
                                                                    "$url/following/isFollow/${authController.userId.value}/${widget.user["id"]}");
                                                            isFollowing.value =
                                                                jsonDecode(
                                                                    isFollowRes
                                                                        .body);
                                                          },
                                                          child: const Text(
                                                              "Unfollow"));
                                                    }
                                                  },
                                                ),
                                              ),
                                              SizedBox(
                                                width: Get.width * 0.02,
                                              ),
                                              SizedBox(
                                                width: Get.width * 0.46,
                                                child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      textStyle:
                                                          const TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                      primary: Colors.blue,
                                                      onPrimary: Colors.white,
                                                    ),
                                                    onPressed: () {},
                                                    child:
                                                        const Text("Message")),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 3),
                                          child: InkWell(
                                            onTap: () {
                                              scrollController.animateTo(
                                                  (0) * Get.width * 0.95,
                                                  duration: const Duration(
                                                      milliseconds: 500),
                                                  curve: Curves.ease);

                                              profileIndex.value = 0;
                                            },
                                            child: const Icon(
                                              Icons.arrow_back,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5),
                                          child: SizedBox(
                                            width: Get.width * 0.95,
                                            child: Text(
                                              widget.user["bio"] ?? "",
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                            }),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Obx(
                            () => Container(
                              width:
                                  15, // Adjust the size of the circle as needed
                              height: 15,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1.5, color: Colors.blue),
                                  shape: BoxShape.circle,
                                  color:
                                      profileIndex == 0 ? Colors.blue : null),
                            ),
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          Obx(
                            () => Container(
                              width:
                                  15, // Adjust the size of the circle as needed
                              height: 15,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1.5, color: Colors.blue),
                                  shape: BoxShape.circle,
                                  color:
                                      profileIndex == 1 ? Colors.blue : null),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
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
                      RandomUserQuotePosts(
                        userId: widget.user["id"],
                        userPosts: posts,
                      ),
                      RandomUserLikePosts(
                        userId: widget.user["id"],
                        likePosts: likedPosts,
                      ),
                    ]),
                  ),
                )
              ]),
            )),
    );
  }
}

class RandomUserLikePost {}
