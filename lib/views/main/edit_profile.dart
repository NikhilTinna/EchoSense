import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/authController.dart';
import '../../controllers/userController.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  UserController userController = Get.put(UserController());
  AuthController authController = Get.put(AuthController());

  var nameController = TextEditingController();
  var usernameController = TextEditingController();
  var bioController = TextEditingController();

  @override
  void initState() {
    nameController.text = userController.currentUserData.value["name"];
    usernameController.text = userController.currentUserData.value["username"];
    if (userController.currentUserData.value["bio"] != null) {
      bioController.text = userController.currentUserData.value["bio"];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text("Edit Profile"),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
            child: Container(
          margin: EdgeInsets.only(
              top: 10,
              left: Get.width * 0.025,
              right: Get.width * 0.025,
              bottom: 20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            userController.currentUserData.value["picture"] == null
                ? Center(
                    child: const CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.white,
                      backgroundImage:
                          AssetImage("assets/images/profile_picture.png"),
                    ),
                  )
                : Center(
                    child: CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(
                          userController.currentUserData.value["picture"]),
                    ),
                  ),
            SizedBox(
              height: 50,
            ),
            Row(
              children: [
                Text(
                  " Name",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
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
                hintText: "Enter name",
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Text(
                  " Username",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            TextFormField(
              controller: usernameController,
              decoration: InputDecoration(
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
                hintText: "Enter Username",
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Text(
                  " Bio",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            TextFormField(
              maxLines: 6,
              controller: bioController,
              decoration: InputDecoration(
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
                hintText: "Describe yourself",
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(onPressed: () {}, child: Text("Edit profile"))
          ]),
        )),
      ),
    );
  }
}
