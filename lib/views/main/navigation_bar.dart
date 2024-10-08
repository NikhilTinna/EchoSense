import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media/views/main/add_post.dart';
import 'package:social_media/views/main/home.dart';
import 'package:social_media/views/main/notifications.dart';
import 'package:social_media/views/main/profile.dart';
import 'package:social_media/views/main/random/chats/chat_list.dart';
import 'package:social_media/views/main/search.dart';
import 'package:social_media/views/main/ai_screen.dart'; // Import the AI screen

import '../../controllers/authController.dart';

class UserNavigationBar extends StatelessWidget {
  UserNavigationBar({super.key});

  final List<Widget> userPages = [
    const Home(),
    const Search(),
    const AddPost(),
    const ChatList(),
    const AIScreen(), // Add AI screen here
    const Profile()
  ];

  final AuthController controller = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            iconSize: 26,
            fixedColor: Colors.green,
            backgroundColor: const Color(0xff00141C),
            type: BottomNavigationBarType.fixed,
            unselectedItemColor: Colors.white,
            currentIndex: controller.userIndex.value,
            onTap: (userIndex) {
              controller.userIndex.value = userIndex;
              // Add condition to navigate to the AI screen
              if (userIndex == 4) {
                // Navigate to the AI screen
                Get.to(() => AIScreen());
              }
            },
            items: const [
              BottomNavigationBarItem(
                backgroundColor: Colors.red,
                icon: Icon(Icons.home),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                    Icons.science), // Use a different icon for the AI screen
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: '',
              ),
            ],
          ),
        ),
        body: Obx(() => userPages[controller.userIndex.value]),
      ),
    );
  }
}
