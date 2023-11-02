import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media/controllers/userController.dart';
import 'package:http/http.dart' as http;
import 'package:social_media/views/main/random/random_profile.dart';
import '../../../constants/REST_api.dart';
import '../../../constants/global.dart';
import '../../../controllers/authController.dart';

class UserFollowers extends StatefulWidget {
  List userFollowers;
  UserFollowers({required this.userFollowers, key});

  @override
  State<UserFollowers> createState() => _UserFollowersState();
}

class _UserFollowersState extends State<UserFollowers> {
  AuthController authController = Get.put(AuthController());
  UserController userController = Get.put(UserController());
  var isFollowing = [];
  var isLoading = false;

  getFollowerData() async {
    setState(() {
      isLoading = true;
    });
    print(widget.userFollowers);
    for (var element in widget.userFollowers) {
      http.Response res = await get(
          "$url/following/isFollow/${authController.userId.value}/${element["followerId"]}");
      isFollowing.add(jsonDecode(res.body));
    }
    print(isFollowing);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getFollowerData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Followers")),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.grey,
              ),
            )
          : SafeArea(
              child: Container(
              margin: EdgeInsets.only(
                  left: Get.width * 0.025, right: Get.width * 0.025),
              child: ListView.builder(
                  itemCount: widget.userFollowers.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return RandomProfile(
                              user: widget.userFollowers[index]["follower"]);
                        }));
                      },
                      child: Column(
                        children: [
                          ListTile(
                              leading: widget.userFollowers[index]["follower"]
                                          ["picture"] ==
                                      null
                                  ? const CircleAvatar(
                                      backgroundImage: AssetImage(
                                          "assets/images/profile_picture.png"))
                                  : CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          widget.userFollowers[index]
                                              ["follower"]["picture"])),
                              title: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${widget.userFollowers[index]["follower"]["name"]}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "${widget.userFollowers[index]["follower"]["username"]}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .displaySmall,
                                    ),
                                  ],
                                ),
                              ),
                              trailing: isFollowing[index]
                                  ? SizedBox(
                                      width: Get.width * 0.26,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            textStyle: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600),
                                            primary: Colors.white,
                                            onPrimary: Colors.black,
                                          ),
                                          onPressed: () async {
                                            await post(
                                                endpoint:
                                                    "$url/following/unfollow",
                                                body: jsonEncode({
                                                  "followerId": authController
                                                      .userId.value,
                                                  "followingId": widget
                                                          .userFollowers[index]
                                                      ["followerId"]
                                                }),
                                                success: () {});

                                            //get user following
                                            http.Response followingRes = await get(
                                                "$url/following/follow/follower/${authController.userId.value}");
                                            userController.following.value =
                                                jsonDecode(followingRes.body);
                                            setState(() {
                                              isFollowing[index] = false;
                                            });
                                          },
                                          child: const Text("Following")),
                                    )
                                  : SizedBox(
                                      width: Get.width * 0.26,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            textStyle: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600),
                                            primary: Colors.green,
                                            onPrimary: Colors.white,
                                          ),
                                          onPressed: () async {
                                            await post(
                                                endpoint:
                                                    "$url/following/follow",
                                                body: jsonEncode({
                                                  "followerId": authController
                                                      .userId.value,
                                                  "followingId": widget
                                                          .userFollowers[index]
                                                      ["followerId"]
                                                }),
                                                success: () {});

                                            //get user following
                                            http.Response followingRes = await get(
                                                "$url/following/follow/follower/${authController.userId.value}");
                                            userController.following.value =
                                                jsonDecode(followingRes.body);
                                            setState(() {
                                              isFollowing[index] = true;
                                            });
                                          },
                                          child: const Text("Follow")),
                                    )),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    );
                  }),
            )),
    );
  }
}
