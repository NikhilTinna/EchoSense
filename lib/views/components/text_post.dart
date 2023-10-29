import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media/controllers/userController.dart';

class TextPost extends StatelessWidget {
  final dynamic textpost;
  TextPost(this.textpost);

  @override
  Widget build(BuildContext context) {
    UserController userController = Get.put(UserController());
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  width: Get.width * 0.12,
                  child: userController.currentUserData.value["picture"] == null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            'assets/images/profile_picture.png', // Replace with the path to your image
                            fit: BoxFit
                                .fill, // Use BoxFit.fill to force the image to fill the container
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                              userController.currentUserData.value["picture"]),
                        )),
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
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      Text(
                        "@${userController.currentUserData.value["username"]}",
                        style: Theme.of(context).textTheme.displaySmall,
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
            margin: EdgeInsets.only(left: Get.width * 0.17),
            child: Column(
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        textpost,
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
  }
}
