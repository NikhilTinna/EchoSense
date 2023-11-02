import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media/controllers/userController.dart';
import 'package:http/http.dart' as http;
import 'package:social_media/views/main/random/random_profile.dart';
import '../../../constants/REST_api.dart';
import '../../../constants/global.dart';
import '../../../controllers/authController.dart';

class RandomUserFollowing extends StatefulWidget {
  List randomUserFollowing;
  String name;
  RandomUserFollowing(
      {required this.randomUserFollowing, required this.name, key});

  @override
  State<RandomUserFollowing> createState() => _RandomUserFollowingState();
}

class _RandomUserFollowingState extends State<RandomUserFollowing> {
  AuthController authController = Get.put(AuthController());
  UserController userController = Get.put(UserController());
  var isFollowing = [];
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${widget.name}'s Following")),
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
                  itemCount: widget.randomUserFollowing.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return RandomProfile(
                              user: widget.randomUserFollowing[index]
                                  ["follower"]);
                        }));
                      },
                      child: Column(
                        children: [
                          ListTile(
                            leading: widget.randomUserFollowing[index]
                                        ["following"]["picture"] ==
                                    null
                                ? const CircleAvatar(
                                    backgroundImage: AssetImage(
                                        "assets/images/profile_picture.png"))
                                : CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        widget.randomUserFollowing[index]
                                            ["following"]["picture"])),
                            title: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${widget.randomUserFollowing[index]["following"]["name"]}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "${widget.randomUserFollowing[index]["following"]["username"]}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall,
                                  ),
                                ],
                              ),
                            ),
                          ),
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
