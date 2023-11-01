import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media/constants/REST_api.dart';
import 'package:social_media/constants/global.dart';
import 'package:social_media/views/main/home.dart';

import '../../constants/toast.dart';
import '../../controllers/authController.dart';
import '../../controllers/userController.dart';
import 'package:http/http.dart' as http;

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
  File? profileImage = File("");
  Future getImageGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        profileImage = File(pickedFile.path);
      });
    } else {
      showErrorToast("Please pick an image");
    }
  }

  final picker = ImagePicker();

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
        title: const Text("Edit Profile"),
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
            profileImage!.path.isNotEmpty
                ? InkWell(
                    onTap: () {
                      getImageGallery();
                    },
                    child: Center(
                      child: CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.white,
                        backgroundImage: FileImage(profileImage!),
                      ),
                    ),
                  )
                : userController.currentUserData.value["picture"] == null
                    ? InkWell(
                        onTap: () {
                          getImageGallery();
                        },
                        child: const Center(
                          child: CircleAvatar(
                            radius: 45,
                            backgroundColor: Colors.white,
                            backgroundImage:
                                AssetImage("assets/images/profile_picture.png"),
                          ),
                        ),
                      )
                    : InkWell(
                        onTap: () {
                          getImageGallery();
                        },
                        child: Center(
                          child: CircleAvatar(
                            radius: 45,
                            backgroundColor: Colors.white,
                            backgroundImage: NetworkImage(userController
                                .currentUserData.value["picture"]),
                          ),
                        ),
                      ),
            const SizedBox(
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
              maxLines: 5,
              maxLength: 100,
              inputFormatters: [
                TextInputFormatter.withFunction((oldValue, newValue) {
                  int newLines = newValue.text.split('\n').length;
                  if (newLines > 5) {
                    return oldValue;
                  } else {
                    return newValue;
                  }
                }),
              ],
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
            ElevatedButton(
                onPressed: () async {
                  if (profileImage!.path.isEmpty) {
                    if (usernameController.text !=
                        userController.currentUserData.value["username"]) {
                      http.Response usernameRes = await post(
                          endpoint: "$url/user/username",
                          body: jsonEncode({
                            "name": nameController.text,
                            "username": usernameController.text,
                            "bio": bioController.text
                          }),
                          success: () {});
                      if (usernameRes.statusCode == 200) {
                        userController.currentUserIsLoading.value = true;
                        await put(
                            endpoint: "$url/user/update/text",
                            body: jsonEncode({
                              "id": authController.userId.value,
                              "name": nameController.text,
                              "username": usernameController.text,
                              "bio": bioController.text
                            }),
                            success: () {
                              userController.currentUserData.value["name"] =
                                  nameController.text;
                              userController.currentUserData.value["username"] =
                                  usernameController.text;
                              userController.currentUserData.value["bio"] =
                                  bioController.text;
                              userController.currentUserIsLoading.value = false;
                            });
                        showSuccessToast("Profile Updated Successfully");
                        Navigator.pop(context);
                        authController.userIndex.value = 0;
                      }
                    } else {
                      userController.currentUserIsLoading.value = true;
                      await put(
                          endpoint: "$url/user/update/text",
                          body: jsonEncode({
                            "id": authController.userId.value,
                            "name": nameController.text,
                            "username": usernameController.text,
                            "bio": bioController.text
                          }),
                          success: () {
                            userController.currentUserData.value["name"] =
                                nameController.text;
                            userController.currentUserData.value["username"] =
                                usernameController.text;
                            userController.currentUserData.value["bio"] =
                                bioController.text;
                            userController.currentUserIsLoading.value = false;
                          });
                      showSuccessToast("Profile Updated Successfully");
                      Navigator.pop(context);
                      authController.userIndex.value = 0;
                    }
                  } else {
                    if (usernameController.text !=
                        userController.currentUserData.value["username"]) {
                      http.Response usernameRes = await post(
                          endpoint: "$url/user/username",
                          body: jsonEncode({
                            "name": nameController.text,
                            "username": usernameController.text,
                            "bio": bioController.text
                          }),
                          success: () {});
                      if (usernameRes.statusCode == 200) {
                        var stream = http.ByteStream(profileImage!.openRead());
                        stream.cast();
                        print(profileImage!.path);

                        var length = await profileImage!.length();
                        http.MultipartRequest res = http.MultipartRequest(
                            'PUT', Uri.parse("$url/user/update/image"));
                        res.fields["id"] = authController.userId.value;
                        res.fields["name"] = nameController.text;
                        res.fields["username"] = usernameController.text;
                        res.fields["bio"] = bioController.text;

                        res.headers["x-auth-token"] =
                            "bearer " + authController.token.value;
                        var multiport = await http.MultipartFile.fromPath(
                            "image", profileImage!.path.toString());

                        res.files.add(multiport);
                        await res.send();
                        userController.currentUserData.value["name"] =
                            nameController.text;
                        userController.currentUserData.value["username"] =
                            usernameController.text;
                        userController.currentUserData.value["bio"] =
                            bioController.text;

                        userController.currentUserData.value["picture"] =
                            res.headers["image"];
                        showSuccessToast("Profile Updated Successfully");
                        Navigator.pop(context);

                        authController.userIndex.value = 0;
                      }
                    } else {
                      var stream = http.ByteStream(profileImage!.openRead());
                      stream.cast();
                      print(profileImage!.path);

                      var length = await profileImage!.length();
                      http.MultipartRequest res = http.MultipartRequest(
                          'PUT', Uri.parse("$url/user/update/image"));
                      res.fields["id"] = authController.userId.value;
                      res.fields["name"] = nameController.text;
                      res.fields["username"] = usernameController.text;
                      res.fields["bio"] = bioController.text;

                      res.headers["x-auth-token"] =
                          "bearer " + authController.token.value;
                      var multiport = await http.MultipartFile.fromPath(
                          "image", profileImage!.path.toString());

                      res.files.add(multiport);
                      await res.send();
                      userController.currentUserData.value["name"] =
                          nameController.text;
                      userController.currentUserData.value["username"] =
                          usernameController.text;
                      userController.currentUserData.value["bio"] =
                          bioController.text;

                      userController.currentUserData.value["picture"] =
                          res.headers["image"];
                      showSuccessToast("Profile Updated Successfully");
                      Navigator.pop(context);
                      authController.userIndex.value = 0;
                    }
                  }
                },
                child: const Text("Edit profile"))
          ]),
        )),
      ),
    );
  }
}
