import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media/constants/REST_api.dart';
import 'package:social_media/constants/global.dart';
import 'package:social_media/constants/toast.dart';
import 'package:social_media/controllers/authController.dart';
import 'package:social_media/controllers/userController.dart';
import 'package:social_media/models/post.dart';
import 'package:http/http.dart' as http;
import 'package:social_media/views/authentication/login.dart';
import 'package:social_media/views/main/edit_profile.dart';
import 'package:social_media/views/main/home/user_followers.dart';
import 'package:social_media/views/main/posts/image_posts.dart';
import 'package:social_media/views/main/posts/like_post.dart';
import 'package:social_media/views/main/posts/quote_posts.dart';
import 'package:social_media/views/main/posts/text_posts.dart';

import '../../controllers/mainController.dart';
import 'home/user_following.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with TickerProviderStateMixin {
  UserController userController = Get.put(UserController());
  AuthController authController = Get.put(AuthController());
  MainController mainController = Get.put(MainController());

  var userFollowingDetails = [].obs;
  var userFollowerDetails = [].obs;
  var postCount = 0;

  var isLoading = false;

  void getUserProfileData() async {
    setState(() {
      isLoading = true;
    });
    http.Response res =
        await get("$url/user/details/${authController.userId.value}");
    userController.currentUserData.value = jsonDecode(res.body);
  }

  void getCurrentUserData() async {
    userController.currentUserIsLoading.value = true;
    http.Response res = await get("$url/posts/${authController.userId.value}");

    userController.currentUserPosts.value = jsonDecode(res.body);

    userController.currentUserIsLoading.value = false;

    //get user followers;
    http.Response followerRes = await get(
        "$url/following/follow/following/${authController.userId.value}");
    userController.followers.value = jsonDecode(followerRes.body);

//get user following
    http.Response followingRes = await get(
        "$url/following/follow/follower/${authController.userId.value}");
    userController.following.value = jsonDecode(followingRes.body);

    print(userController.followers);
    print(userController.following);

    http.Response postCountResponse =
        await get("$url/posts/count/${authController.userId.value}");
    postCount = jsonDecode(postCountResponse.body);

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    userController.currentUserIsLoading.value = true;
    getUserProfileData();
    getCurrentUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var tabController = TabController(vsync: this, length: 4);
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(
              color: Colors.grey,
            ),
          )
        : Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 24,
                  ),
                  Text(
                    "Your Profile",
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  PopupMenuButton(
                      icon: const Icon(Icons.menu),
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                              onTap: () {
                                Future.delayed(Duration.zero, () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return const EditProfile();
                                  }));
                                });
                              },
                              child: const Text("Edit profile")),
                          PopupMenuItem(
                              onTap: () async {
                                SharedPreferences sp =
                                    await SharedPreferences.getInstance();
                                sp.clear();

                                Get.deleteAll();
                                showSuccessToast("Logged out");
                                Future.delayed(Duration.zero, () {
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (context) {
                                    return const Login();
                                  }));
                                });
                              },
                              child: const Text("Logout"))
                        ];
                      })
                ],
              ),
              backgroundColor: Theme.of(context).colorScheme.background,
            ),
            backgroundColor: Theme.of(context).colorScheme.background,
            body: userController.currentUserIsLoading.value
                ? const Center(
                    child: CircularProgressIndicator(
                    color: Colors.grey,
                  ))
                : SafeArea(
                    child: Container(
                      margin: const EdgeInsets.only(
                        top: 12,
                      ),
                      child: Container(
                        margin: EdgeInsets.only(
                          left: Get.width * 0.025,
                          right: Get.width * 0.025,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                userController
                                            .currentUserData.value["picture"] ==
                                        null
                                    ? const CircleAvatar(
                                        radius: 35,
                                        backgroundColor: Colors.white,
                                        backgroundImage: AssetImage(
                                            "assets/images/profile_picture.png"),
                                      )
                                    : CircleAvatar(
                                        radius: 35,
                                        backgroundColor: Colors.white,
                                        backgroundImage: NetworkImage(
                                            userController.currentUserData
                                                .value["picture"]),
                                      ),
                                SizedBox(
                                  width: Get.width * 0.1,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          postCount.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                        Text(
                                          "posts",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: Get.width * 0.09,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return UserFollowers(
                                            userFollowers:
                                                userController.followers[1],
                                          );
                                        }));
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Obx(
                                            () => Text(
                                              userController.followers[0]
                                                  .toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                            ),
                                          ),
                                          Text(
                                            "Followers",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
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
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return UserFollowing(
                                              userFollowing:
                                                  userController.following[1]);
                                        }));
                                      },
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Obx(
                                            () => Text(
                                              userController.following[0]
                                                  .toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                            ),
                                          ),
                                          Text(
                                            "Following",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
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
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      SizedBox(
                                        height: Get.height * 0.13,
                                        child: Text(
                                          userController.currentUserData
                                                  .value["bio"] ??
                                              "",
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              height: 50,
                              child: TabBar(
                                  controller: tabController,
                                  tabs: const [
                                    Icon(Icons.text_format),
                                    Icon(Icons.image),
                                    Icon(Icons.question_answer),
                                    Icon(Icons.thumb_up)
                                  ]),
                            ),
                            Flexible(
                              flex: 1,
                              child: Container(
                                child: TabBarView(
                                    controller: tabController,
                                    children: const [
                                      TextPosts(),
                                      ImagePosts(),
                                      QuotePosts(),
                                      LikePost(),
                                    ]),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ));
  }
}
