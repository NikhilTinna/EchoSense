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
import 'package:social_media/views/main/home/feed.dart';
import 'package:social_media/views/main/home/popular.dart';
import 'package:social_media/views/main/posts/image_posts.dart';
import 'package:social_media/views/main/posts/text_posts.dart';

import '../../controllers/mainController.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  UserController userController = Get.put(UserController());
  AuthController authController = Get.put(AuthController());
  MainController mainController = Get.put(MainController());

  var isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
  }

  @override
  Widget build(BuildContext context) {
    var tabController = TabController(vsync: this, length: 2);
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 50,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 24,
              ),
              Image.asset(
                "assets/images/logo.png",
                width: 40,
                height: 40,
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
        body: SafeArea(
          child: Container(
            margin: const EdgeInsets.only(),
            child: Container(
              margin: EdgeInsets.only(
                left: Get.width * 0.025,
                right: Get.width * 0.025,
              ),
              child: Column(
                children: [
                  Container(
                    height: 50,
                    child: TabBar(controller: tabController, tabs: const [
                      Text(
                        "Your Feed",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "Popular",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      )
                    ]),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      child: TabBarView(controller: tabController, children: [
                        Feed(),
                        Popular(),
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
