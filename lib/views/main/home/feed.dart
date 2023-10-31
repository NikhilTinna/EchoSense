import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media/controllers/userController.dart';
import 'package:http/http.dart' as http;
import '../../../constants/REST_api.dart';
import '../../../constants/global.dart';
import '../../../constants/toast.dart';
import '../../../controllers/authController.dart';
import '../../../controllers/mainController.dart';
import '../profile.dart';
import '../random/post_comments.dart';

class Feed extends StatefulWidget {
  const Feed({super.key});

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  AuthController authController = Get.put(AuthController());
  MainController mainController = Get.put(MainController());

  bool isLoading = false;
  var posts = [];
  void getAllPostsData() async {
    setState(() {
      isLoading = true;
    });
    http.Response res =
        await get("$url/posts/random/${authController.userId.value}");

    mainController.posts.value = await jsonDecode(res.body);

    posts = mainController.posts.value;

    for (var element in mainController.posts) {
      http.Response res = await get("$url/likes/post/${element["id"]}");
      http.Response likedByUserRes = await get(
          "$url/likes/post/likedByUser/${authController.userId.value}/${element["id"]}");

      mainController.likes.add(res.body);
      mainController.isLikedByUser.add(likedByUserRes.body);
    }
    setState(() {
      isLoading = false;
    });
  }

  void likePost(int index) async {
    http.Response resLike = await post(
        endpoint: "$url/likes/post",
        body: jsonEncode({
          "userId": authController.userId.value,
          "postId": mainController.posts.value[index]["id"]
        }),
        success: () {});

    http.Response res =
        await get("$url/likes/post/${mainController.posts.value[index]["id"]}");

    mainController.likes.value[index] = res.body;

    http.Response likedByUserRes = await get(
        "$url/likes/post/likedByUser/${authController.userId.value}/${mainController.posts.value[index]["id"]}");
    mainController.isLikedByUser.value[index] = likedByUserRes.body;

    setState(() {});
  }

  void dislikePost(int index) async {
    http.Response resLike = await post(
        endpoint: "$url/likes/post/remove",
        body: jsonEncode({
          "userId": authController.userId.value,
          "postId": mainController.posts.value[index]["id"]
        }),
        success: () {});

    http.Response res =
        await get("$url/likes/post/${mainController.posts.value[index]["id"]}");

    mainController.likes.value[index] = res.body;

    http.Response likedByUserRes = await get(
        "$url/likes/post/likedByUser/${authController.userId.value}/${mainController.posts.value[index]["id"]}");
    mainController.isLikedByUser.value[index] = likedByUserRes.body;

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getAllPostsData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.grey,
              ),
            )
          : SafeArea(
              child: Container(
                margin: const EdgeInsets.only(
                  top: 10,
                ),
                child: Column(
                  children: [
                    Flexible(
                      flex: 1,
                      child: isLoading == false
                          ? ListView.builder(
                              itemCount: posts.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              width: Get.width * 0.12,
                                              child: posts[index]["user"]
                                                          ["picture"] ==
                                                      null
                                                  ? InkWell(
                                                      onTap: () {
                                                        Get.to(Profile());
                                                      },
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        child: Image.asset(
                                                          'assets/images/profile_picture.png', // Replace with the path to your image
                                                          fit: BoxFit
                                                              .fill, // Use BoxFit.fill to force the image to fill the container
                                                        ),
                                                      ),
                                                    )
                                                  : InkWell(
                                                      onTap: () {
                                                        Get.to(Profile());
                                                      },
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        child: Image.network(
                                                            posts[index]["user"]
                                                                ["picture"]),
                                                      ),
                                                    )),
                                          SizedBox(
                                            width: Get.width * 0.04,
                                          ),
                                          SizedBox(
                                              width: Get.width * 0.77,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    posts[index]["user"]
                                                        ["name"],
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .displayMedium,
                                                  ),
                                                  Text(
                                                    "@${posts[index]["user"]["username"]}",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .displaySmall,
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
                                      InkWell(
                                        onTap: () {
                                          Get.to(PostComments(
                                            postId: posts[index]["id"],
                                          ));
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              left: Get.width * 0.17),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Flexible(
                                                    child: Text(
                                                      posts[index]
                                                          ["description"],
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              posts[index]["imageurl"] != null
                                                  ? Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        child: Image.network(
                                                          posts[index][
                                                              "imageurl"], // Replace with the path to your image
                                                          fit: BoxFit
                                                              .fill, // Use BoxFit.fill to force the image to fill the container
                                                        ),
                                                      ),
                                                    )
                                                  : Container(),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              posts[index]["quotedPostId"] !=
                                                      null
                                                  ? Container(
                                                      width: double.infinity,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              width: 0.5,
                                                              color:
                                                                  Colors.grey),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Container(
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10)),
                                                                  width:
                                                                      Get.width *
                                                                          0.08,
                                                                  child: posts[index]["quotePost"]["user"]
                                                                              [
                                                                              "picture"] ==
                                                                          null
                                                                      ? ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.circular(10),
                                                                          child:
                                                                              Image.asset(
                                                                            'assets/images/profile_picture.png', // Replace with the path to your image
                                                                            fit:
                                                                                BoxFit.fill, // Use BoxFit.fill to force the image to fill the container
                                                                          ),
                                                                        )
                                                                      : ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.circular(10),
                                                                          child:
                                                                              Image.network(posts[index]["quotePost"]["user"]["picture"]),
                                                                        )),
                                                              SizedBox(
                                                                width:
                                                                    Get.width *
                                                                        0.03,
                                                              ),
                                                              Text(
                                                                posts[index][
                                                                            "quotePost"]
                                                                        ["user"]
                                                                    ["name"],
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                              SizedBox(
                                                                width:
                                                                    Get.width *
                                                                        0.03,
                                                              ),
                                                              Text(
                                                                  "@${posts[index]["quotePost"]["user"]["username"]}",
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: Colors
                                                                          .grey)),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Flexible(
                                                                child: Text(
                                                                  posts[index][
                                                                          "quotePost"]
                                                                      [
                                                                      "description"],
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodyMedium,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          posts[index]["quotePost"]
                                                                      [
                                                                      "imageurl"] !=
                                                                  null
                                                              ? Column(
                                                                  children: [
                                                                    Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(10)),
                                                                      child:
                                                                          ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10),
                                                                        child: Image
                                                                            .network(
                                                                          posts[index]["quotePost"]
                                                                              [
                                                                              "imageurl"], // Replace with the path to your image
                                                                          fit: BoxFit
                                                                              .fill, // Use BoxFit.fill to force the image to fill the container
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                  ],
                                                                )
                                                              : Container(),
                                                        ],
                                                      ))
                                                  : Container(),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                children: [
                                                  Obx(
                                                    () => InkWell(
                                                        onTap: () async {
                                                          mainController.isLikedByUser
                                                                          .value[
                                                                      index] ==
                                                                  "false"
                                                              ? likePost(index)
                                                              : dislikePost(
                                                                  index);
                                                        },
                                                        child: Icon(mainController
                                                                        .isLikedByUser
                                                                        .value[
                                                                    index] ==
                                                                "false"
                                                            ? Icons
                                                                .favorite_outline
                                                            : Icons.favorite)),
                                                  ),
                                                  const SizedBox(
                                                    width: 3,
                                                  ),
                                                  Obx(
                                                    () => Text(
                                                      mainController
                                                          .likes.value[index],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: Get.width * 0.1,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      final textController =
                                                          TextEditingController();
                                                      final picker =
                                                          ImagePicker();
                                                      File? postImage =
                                                          File("");

                                                      showModalBottomSheet(
                                                          isScrollControlled:
                                                              true,
                                                          showDragHandle: true,
                                                          backgroundColor:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .background,
                                                          context: context,
                                                          builder: (context) {
                                                            return StatefulBuilder(
                                                                builder: (BuildContext
                                                                        context,
                                                                    StateSetter
                                                                        setModalState /*You can rename this!*/) {
                                                              return SingleChildScrollView(
                                                                child:
                                                                    Container(
                                                                        height: Get.height *
                                                                            0.9,
                                                                        margin: EdgeInsets.only(
                                                                            left: Get.width *
                                                                                0.025,
                                                                            right: Get.width *
                                                                                0.025,
                                                                            bottom:
                                                                                15),
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
                                                                                            borderSide: const BorderSide(width: 1, color: Colors.blueGrey),
                                                                                          ),
                                                                                          focusedBorder: OutlineInputBorder(
                                                                                            borderRadius: BorderRadius.circular(10),
                                                                                            borderSide: const BorderSide(width: 1, color: Colors.grey),
                                                                                          ),
                                                                                          hintText: "Write something here..",
                                                                                        )),
                                                                                  ),
                                                                                  Positioned(
                                                                                      bottom: 50,
                                                                                      left: 0,
                                                                                      child: InkWell(
                                                                                        onTap: () async {
                                                                                          final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                                                                                          if (pickedFile != null) {
                                                                                            setModalState(() {
                                                                                              postImage = File(pickedFile.path);
                                                                                            });
                                                                                          }
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
                                                                                            AuthController authController = Get.put(AuthController());
                                                                                            print(authController.token.value);
                                                                                            http.Response res = await post(
                                                                                                endpoint: "$url/posts/reply",
                                                                                                body: jsonEncode({
                                                                                                  "description": textController.text,
                                                                                                  "userId": authController.userId.value,
                                                                                                  "quotedPostId": posts[index]["id"]
                                                                                                }),
                                                                                                success: () => showSuccessToast("Quote post added successfully"));
                                                                                            Navigator.pop(context);
                                                                                          },
                                                                                          child: const Text("quote post")))
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
                                                                                            borderSide: const BorderSide(width: 1, color: Colors.blueGrey),
                                                                                          ),
                                                                                          focusedBorder: OutlineInputBorder(
                                                                                            borderRadius: BorderRadius.circular(10),
                                                                                            borderSide: const BorderSide(width: 1, color: Colors.grey),
                                                                                          ),
                                                                                          hintText: "Write something here..",
                                                                                        )),
                                                                                  ),
                                                                                  Positioned(
                                                                                    top: 170,
                                                                                    left: 0,
                                                                                    right: 0,
                                                                                    child: Container(
                                                                                      constraints: BoxConstraints(minHeight: Get.height * 0.4, maxHeight: Get.height * 0.5),
                                                                                      margin: const EdgeInsets.only(top: 10),
                                                                                      child: Image.file(
                                                                                        postImage!, // Replace with the path to your image
                                                                                        fit: BoxFit.fill, // Use BoxFit.fill to force the image to fill the container
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Positioned(
                                                                                      top: 190,
                                                                                      right: 10,
                                                                                      child: InkWell(
                                                                                        onTap: () {
                                                                                          setModalState(() {
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
                                                                                        onTap: () async {
                                                                                          final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                                                                                          if (pickedFile != null) {
                                                                                            setModalState(() {
                                                                                              postImage = File(pickedFile.path);
                                                                                            });
                                                                                          }
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
                                                                                            AuthController authController = Get.put(AuthController());
                                                                                            var stream = http.ByteStream(postImage!.openRead());
                                                                                            stream.cast();
                                                                                            print(postImage!.path);

                                                                                            var length = await postImage!.length();
                                                                                            http.MultipartRequest res = http.MultipartRequest('POST', Uri.parse("$url/posts/reply/image"));
                                                                                            res.fields["description"] = textController.text;
                                                                                            res.fields["userId"] = authController.userId.value;
                                                                                            res.fields["quotedPostId"] = posts[index]["id"];
                                                                                            res.headers["x-auth-token"] = "bearer " + authController.token.value;
                                                                                            var multiport = await http.MultipartFile.fromPath("image", postImage!.path.toString());

                                                                                            res.files.add(multiport);
                                                                                            await res.send();
                                                                                            showSuccessToast("Quote post added successfully");
                                                                                            Navigator.pop(context);
                                                                                          },
                                                                                          child: const Text("quote Post")))
                                                                                ],
                                                                              )),
                                                              );
                                                            });
                                                          });
                                                    },
                                                    child: const Icon(Icons
                                                        .chat_bubble_outline),
                                                  ),
                                                  const SizedBox(
                                                    width: 3,
                                                  ),
                                                  const Text(
                                                    "0",
                                                  ),
                                                  SizedBox(
                                                    width: Get.width * 0.1,
                                                  ),
                                                  const Icon(
                                                      Icons.replay_outlined),
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
                              })
                          : Container(),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
