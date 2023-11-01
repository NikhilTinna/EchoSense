import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media/controllers/userController.dart';

class UserFollowers extends StatefulWidget {
  const UserFollowers({super.key});

  @override
  State<UserFollowers> createState() => _UserFollowersState();
}

class _UserFollowersState extends State<UserFollowers> {
  UserController userController = Get.put(UserController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Your Followers")),
      body: SafeArea(
          child: Container(
        margin:
            EdgeInsets.only(left: Get.width * 0.025, right: Get.width * 0.025),
        child: ListView.builder(
            itemCount: userController.followers[1].length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  ListTile(
                      leading: userController.followers[1][index]["follower"]
                                  ["picture"] ==
                              null
                          ? const CircleAvatar(
                              backgroundImage: AssetImage(
                                  "assets/images/profile_picture.png"))
                          : CircleAvatar(
                              backgroundImage: NetworkImage(userController
                                  .followers[1][index]["follower"]["picture"])),
                      title: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${userController.followers[1][index]["follower"]["name"]}",
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "${userController.followers[1][index]["follower"]["username"]}",
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                          ],
                        ),
                      ),
                      trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            textStyle: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600),
                            primary: Colors.green,
                            onPrimary: Colors.white,
                          ),
                          onPressed: () async {},
                          child: const Text("Follow"))),
                  SizedBox(
                    height: 5,
                  ),
                ],
              );
            }),
      )),
    );
  }
}
