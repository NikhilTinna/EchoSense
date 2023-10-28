import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media/constants/REST_api.dart';
import 'package:social_media/constants/global.dart';
import 'package:social_media/constants/toast.dart';
import 'package:http/http.dart' as http;
import 'package:social_media/controllers/authController.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final textController = TextEditingController();
  File? postImage = File("");

  Future getImageGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        postImage = File(pickedFile.path);
      });
    } else {
      showErrorToast("Please pick an image");
    }
  }

  final picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
          child: Container(
              margin: EdgeInsets.only(
                  top: 10,
                  left: Get.width * 0.025,
                  right: Get.width * 0.025,
                  bottom: 15),
              child: postImage!.path.isEmpty
                  ? Stack(
                      children: [
                        Positioned(
                          top: Get.height * 0.27,
                          left: 0,
                          right: 0,
                          child: TextField(
                              maxLines: 6,
                              controller: textController,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      width: 1, color: Colors.blueGrey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      width: 1, color: Colors.grey),
                                ),
                                hintText: "Write something here..",
                              )),
                        ),
                        Positioned(
                            bottom: 50,
                            left: 0,
                            child: InkWell(
                              onTap: () {
                                getImageGallery();
                              },
                              child: const Icon(
                                Icons.image,
                                size: 28,
                                color: Colors.grey,
                              ),
                            )),
                        Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: ElevatedButton(
                                onPressed: () async {
                                  AuthController authController =
                                      Get.put(AuthController());
                                  print(authController.token.value);
                                  http.Response res = await post(
                                      endpoint: "$url/posts",
                                      body: jsonEncode({
                                        "description": textController.text,
                                        "userId": authController.userId.value
                                      }),
                                      success: () => showSuccessToast(
                                          "Post added successfully"));
                                },
                                child: const Text("Add post")))
                      ],
                    )
                  : Stack(
                      children: [
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: TextField(
                              maxLines: 6,
                              controller: textController,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      width: 1, color: Colors.blueGrey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      width: 1, color: Colors.grey),
                                ),
                                hintText: "Write something here..",
                              )),
                        ),
                        Positioned(
                          top: 170,
                          left: 0,
                          right: 0,
                          child: Container(
                            constraints: BoxConstraints(
                                minHeight: Get.height * 0.4,
                                maxHeight: Get.height * 0.5),
                            margin: const EdgeInsets.only(top: 10),
                            child: Image.file(
                              postImage!, // Replace with the path to your image
                              fit: BoxFit
                                  .fill, // Use BoxFit.fill to force the image to fill the container
                            ),
                          ),
                        ),
                        Positioned(
                            top: 190,
                            right: 10,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  postImage = File("");
                                });
                              },
                              child: Icon(
                                Icons.remove_circle,
                                color: Colors.red,
                              ),
                            )),
                        Positioned(
                            bottom: 50,
                            left: 0,
                            child: InkWell(
                              onTap: () {
                                getImageGallery();
                              },
                              child: const Icon(
                                Icons.image,
                                size: 28,
                                color: Colors.grey,
                              ),
                            )),
                        Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: ElevatedButton(
                                onPressed: () async {
                                  AuthController authController =
                                      Get.put(AuthController());
                                  var stream =
                                      http.ByteStream(postImage!.openRead());
                                  stream.cast();
                                  print(postImage!.path);

                                  var length = await postImage!.length();
                                  http.MultipartRequest res =
                                      http.MultipartRequest('POST',
                                          Uri.parse("$url/posts/image"));
                                  res.fields["description"] =
                                      textController.text;
                                  res.fields["userId"] =
                                      authController.userId.value;
                                  res.headers["x-auth-token"] =
                                      "bearer " + authController.token.value;
                                  var multiport =
                                      await http.MultipartFile.fromPath(
                                          "image", postImage!.path.toString());

                                  res.files.add(multiport);
                                  await res.send();
                                },
                                child: const Text("Add post")))
                      ],
                    ))),
    );
  }
}
