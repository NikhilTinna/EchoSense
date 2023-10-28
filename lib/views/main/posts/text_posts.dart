import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media/controllers/authController.dart';

import '../../../controllers/userController.dart';

class TextPosts extends StatefulWidget {
  const TextPosts({super.key});

  @override
  State<TextPosts> createState() => _TextPostsState();
}

class _TextPostsState extends State<TextPosts> {
  UserController userController = Get.put(UserController());
  List<dynamic> textPosts = [];
  @override
  void initState() {
    for (int i = 0; i < userController.currentUserPosts.value.length; i++) {
      if (userController.currentUserPosts.value[i]["imageurl"] == null) {
        setState(() {
          textPosts.add(userController.currentUserPosts.value[i]);
        });
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        margin: const EdgeInsets.only(top: 10),
        child: ListView.builder(
            itemCount: textPosts.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: Get.width * 0.14,
                          child: userController
                                      .currentUserData.value["picture"] ==
                                  null
                              ? const CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.white,
                                  backgroundImage: AssetImage(
                                      "assets/images/profile_picture.png"),
                                )
                              : CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.white,
                                  backgroundImage: NetworkImage(userController
                                      .currentUserData.value["picture"]),
                                ),
                        ),
                        SizedBox(
                          width: Get.width * 0.04,
                        ),
                        Container(
                            width: Get.width * 0.77,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userController.currentUserData.value["name"],
                                  style:
                                      Theme.of(context).textTheme.displayMedium,
                                ),
                                Text(
                                  "@${userController.currentUserData.value["username"]}",
                                  style:
                                      Theme.of(context).textTheme.displaySmall,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                              ],
                            )),
                      ],
                    ),
                    SizedBox(
                      height: Get.height * 0.01,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: Get.width * 0.18),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  textPosts[index]["description"],
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              const Icon(Icons.favorite_outline),
                              const SizedBox(
                                width: 3,
                              ),
                              const Text(
                                "0",
                              ),
                              SizedBox(
                                width: Get.width * 0.1,
                              ),
                              const Icon(Icons.chat_bubble_outline),
                              const SizedBox(
                                width: 3,
                              ),
                              const Text(
                                "0",
                              ),
                              SizedBox(
                                width: Get.width * 0.1,
                              ),
                              const Icon(Icons.replay_outlined),
                              const SizedBox(
                                width: 3,
                              ),
                              const Text(
                                "0",
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Divider(
                      color: Colors.grey,
                    )
                  ],
                ),
              );
            }),
      ),
    );
  }
}
