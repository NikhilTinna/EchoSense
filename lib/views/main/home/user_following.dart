import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media/controllers/userController.dart';

class UserFollowing extends StatefulWidget {
  const UserFollowing({super.key});

  @override
  State<UserFollowing> createState() => _UserFollowingState();
}

class _UserFollowingState extends State<UserFollowing> {
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
            itemCount: userController.following[1].length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  ListTile(
                      leading: userController.following[1][index]["following"]
                                  ["picture"] ==
                              null
                          ? const CircleAvatar(
                              backgroundImage: AssetImage(
                                  "assets/images/profile_picture.png"))
                          : CircleAvatar(
                              backgroundImage: NetworkImage(
                                  userController.following[1][index]
                                      ["following"]["picture"])),
                      title: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${userController.following[1][index]["following"]["name"]}",
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "${userController.following[1][index]["following"]["username"]}",
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
