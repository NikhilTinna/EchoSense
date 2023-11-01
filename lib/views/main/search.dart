import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media/constants/REST_api.dart';
import 'package:social_media/controllers/authController.dart';
import 'package:http/http.dart' as http;
import 'package:social_media/views/main/random/random_profile.dart';

import '../../constants/global.dart';
import '../../controllers/userController.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  AuthController authController = Get.put(AuthController());
  UserController userController = Get.put(UserController());
  final searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    userController.users = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(
              top: 10, left: Get.width * 0.025, right: Get.width * 0.025),
          child: Column(children: [
            TextField(
              onChanged: (value) async {
                userController.isSearchLoading.value = true;
                if (searchController.text.isEmpty) {
                  http.Response userResponse = await get(
                      "$url/user/search/${authController.userId.value}/*");
                  userController.users = jsonDecode(userResponse.body);
                } else {
                  http.Response userResponse = await get(
                      "$url/user/search/${authController.userId.value}/${searchController.text}");
                  userController.users = jsonDecode(userResponse.body);
                }
                userController.isSearchLoading.value = false;
              },
              controller: searchController,
              decoration: InputDecoration(
                prefixIcon: const InkWell(child: Icon(Icons.search)),
                iconColor: Colors.grey,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      const BorderSide(width: 1, color: Colors.blueGrey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(width: 1, color: Colors.grey),
                ),
                contentPadding: const EdgeInsets.all(10),
                hintText: "Search..",
              ),
            ),
            Expanded(
              child: Obx(
                () {
                  return userController.isSearchLoading.value
                      ? const Center(
                          child: CircularProgressIndicator(color: Colors.grey),
                        )
                      : ListView.builder(
                          itemCount: userController.users.length,
                          itemBuilder: ((context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return RandomProfile(
                                      user: userController.users[index]);
                                }));
                              },
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: userController.users[index]
                                                ["picture"] ==
                                            null
                                        ? const CircleAvatar(
                                            backgroundImage: AssetImage(
                                                "assets/images/profile_picture.png"))
                                        : CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                userController.users[index]
                                                    ["picture"])),
                                    title: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10,
                                          right: 8,
                                          top: 8,
                                          bottom: 8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${userController.users[index]["username"]}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .displayMedium,
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                              "${userController.users[index]["name"].toString()}",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  )
                                ],
                              ),
                            );
                          }),
                        );
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
