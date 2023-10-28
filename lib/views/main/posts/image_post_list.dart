import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:social_media/controllers/userController.dart';

class ImagePostList extends StatefulWidget {
  final List<dynamic> images;
  final int count;

  ImagePostList(this.images, this.count);

  @override
  State<ImagePostList> createState() => _ImagePostListState();
}

class _ImagePostListState extends State<ImagePostList> {
  UserController userController = Get.put(UserController());
  ItemScrollController itemScrollController = ItemScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
          child: Container(
        margin: EdgeInsets.only(
            top: 10, left: Get.width * 0.025, right: Get.width * 0.025),
        child: ScrollablePositionedList.builder(
            itemScrollController: itemScrollController,
            initialScrollIndex: widget.count,
            itemCount: widget.images.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            width: Get.width * 0.12,
                            child: userController
                                        .currentUserData.value["picture"] ==
                                    null
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
                                    child: Image.network(userController
                                        .currentUserData.value["picture"]),
                                  )),
                        SizedBox(
                          width: Get.width * 0.02,
                        ),
                        Container(
                            width: Get.width * 0.79,
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
                      margin: EdgeInsets.only(left: Get.width * 0.15),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                widget.images[index]["description"],
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                top: 3, bottom: 3, left: 1.5, right: 1.5),
                            child: Image.network(
                              widget.images[index][
                                  "imageurl"], // Replace with the path to your image
                              fit: BoxFit
                                  .fill, // Use BoxFit.fill to force the image to fill the container
                            ),
                          ),
                          SizedBox(
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
      )),
    );
  }
}
