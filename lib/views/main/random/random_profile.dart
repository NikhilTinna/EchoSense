import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RandomProfile extends StatefulWidget {
  final dynamic user;
  const RandomProfile({required this.user, super.key});

  @override
  State<RandomProfile> createState() => _RandomProfileState();
}

class _RandomProfileState extends State<RandomProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back),
            ),
            Container(
              padding: EdgeInsets.only(right: 12),
              child: Text(
                widget.user["username"],
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ),
            Container()
          ],
        ),
      ),
      body: SafeArea(
          child: Container(
        margin: EdgeInsets.only(
            top: 10, right: Get.width * 0.025, left: Get.width * 0.025),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              widget.user["picture"] == null
                  ? CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.white,
                      backgroundImage:
                          AssetImage("assets/images/profile_picture.png"),
                    )
                  : CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(widget.user["picture"]),
                    ),
              SizedBox(
                width: Get.width * 0.1,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "23",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        "posts",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  SizedBox(
                    width: Get.width * 0.09,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "23",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        "Followers",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  SizedBox(
                    width: Get.width * 0.09,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "23",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        "Following",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(
                  left: Get.width * 0.01,
                  right: Get.width * 0.01,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.user["name"],
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      widget.user["bio"] == null ? "" : widget.user["bio"],
                      style: const TextStyle(fontSize: 16),
                    )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 12,
          ),
        ]),
      )),
    );
  }
}
