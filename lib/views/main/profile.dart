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
import 'package:social_media/views/main/posts/image_posts.dart';
import 'package:social_media/views/main/posts/text_posts.dart';

import '../../controllers/mainController.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with TickerProviderStateMixin {
  UserController userController = Get.put(UserController());
  AuthController authController = Get.put(AuthController());
  MainController mainController = Get.put(MainController());

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
    return Obx(() {
      if (userController.currentUserIsLoading.value == true) {
        return Center(
          child: CircularProgressIndicator(
            color: Colors.grey,
          ),
        );
      } else {
        return Scaffold(
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
                    userController.currentUserData.value["username"],
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  PopupMenuButton(
                      icon: const Icon(Icons.menu),
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                              child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return EditProfile();
                                    }));
                                  },
                                  child: const Text("Edit profile"))),
                          PopupMenuItem(
                              child: InkWell(
                                  onTap: () async {
                                    Navigator.pop(context);
                                    SharedPreferences sp =
                                        await SharedPreferences.getInstance();
                                    sp.clear();

                                    Get.deleteAll();
                                    showSuccessToast("Logged out");
                                    Navigator.pushReplacement(context,
                                        MaterialPageRoute(builder: (context) {
                                      return Login();
                                    }));
                                  },
                                  child: Text("Logout")))
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
                                      Text(
                                        userController
                                            .currentUserData.value["bio"],
                                        style: TextStyle(fontSize: 16),
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
                            Flexible(
                              flex: 1,
                              child: Container(
                                child: TabBarView(
                                    controller: tabController,
                                    children: [
                                      const TextPosts(),
                                      const ImagePosts(),
                                      Container(),
                                      const Text("hi")
                                    ]),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ));
      }
    });
  }
}
