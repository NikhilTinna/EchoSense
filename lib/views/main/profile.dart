import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media/constants/REST_api.dart';
import 'package:social_media/constants/global.dart';
import 'package:social_media/constants/toast.dart';
import 'package:social_media/controllers/authController.dart';
import 'package:social_media/controllers/userController.dart';
import 'package:social_media/models/post.dart';

import 'package:http/http.dart' as http;
import 'package:social_media/views/main/edit_profile.dart';
import 'package:social_media/views/main/posts/image_posts.dart';
import 'package:social_media/views/main/posts/text_posts.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with TickerProviderStateMixin {
  UserController userController = Get.put(UserController());
  AuthController authController = Get.put(AuthController());

  void getUserProfileData() async {
    http.Response res =
        await get("$url/user/details/${authController.userId.value}");
    userController.currentUserData.value = jsonDecode(res.body);
    print(userController.currentUserData.value);
  }

  void getCurrentUserData() async {
    userController.currentUserIsLoading.value = true;
    http.Response res = await get("$url/posts/${authController.userId.value}");

    userController.currentUserPosts.value = jsonDecode(res.body);

    userController.currentUserIsLoading.value = false;
  }

  @override
  void initState() {
    getUserProfileData();
    getCurrentUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var tabController = TabController(vsync: this, length: 4);
    return Obx(() => Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 24,
              ),
              Text(
                "Your profile",
                style: Theme.of(context).textTheme.displayLarge,
              ),
              PopupMenuButton(
                  icon: const Icon(Icons.menu),
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                          child: InkWell(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return EditProfile();
                                }));
                              },
                              child: const Text("Edit profile"))),
                      PopupMenuItem(child: InkWell(child: Text("Logout")))
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
            : ListView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  SafeArea(
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
                                          "23",
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
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          "23",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                        Text(
                                          "Followers",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: Get.width * 0.09,
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          "23",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                        Text(
                                          "Following",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
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
                                        "Abdul qader",
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayMedium,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "This is where you will write your bio \n and it will look good \n i know you will like it",
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall,
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
                              child: TabBar(
                                  controller: tabController,
                                  tabs: const [
                                    Icon(Icons.text_format),
                                    Icon(Icons.image),
                                    Icon(Icons.question_answer),
                                    Icon(Icons.thumb_up)
                                  ]),
                            ),
                            Container(
                              height: 1000,
                              child: TabBarView(
                                  controller: tabController,
                                  children: [
                                    const TextPosts(),
                                    const ImagePosts(),
                                    Container(),
                                    const Text("hi")
                                  ]),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )));
  }
}
