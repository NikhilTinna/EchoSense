import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
      margin: EdgeInsets.only(
        left: Get.width * 0.025,
        right: Get.width * 0.025,
      ),
      child: Column(
        children: [
          Container(
            child: CircleAvatar(
              radius: 56,
              backgroundColor: Colors.white,
              backgroundImage: AssetImage("assets/images/logo.png"),
            ),
            // child: client["image"] == null
            //     ? const CircleAvatar(
            //         radius: 60,
            //         backgroundColor: Colors.white,
            //         child: Icon(
            //           Icons.camera_alt,
            //           color: Colors.blue,
            //           size: 50,
            //         ),
            //       )
          ),
        ],
      ),
    )));
  }
}
