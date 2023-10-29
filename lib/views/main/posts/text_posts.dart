import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media/controllers/authController.dart';
import 'package:social_media/views/components/text_post.dart';

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
              return TextPost(textPosts[index]["description"]);
            }),
      ),
    );
  }
}
