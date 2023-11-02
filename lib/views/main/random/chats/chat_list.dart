import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media/controllers/authController.dart';

import 'individual_chat.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  AuthController authController = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Messages"),
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(
              top: 5, left: Get.width * 0.025, right: Get.width * 0.025),
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Users")
                  .doc(authController.userId.value)
                  .collection("messages")
                  .snapshots(),
              builder: (context, snapshot) {
                List<Column> clientWidgets = [];
                if (snapshot.hasData) {
                  final clients = snapshot.data?.docs;
                  for (var client in clients!) {
                    final clientWidget = Column(
                      children: [
                        InkWell(
                          onTap: () {
                            String chatId;
                            if (authController.userId.value
                                    .compareTo(client["id"]) ==
                                1) {
                              chatId =
                                  client["id"] + authController.userId.value;
                            } else {
                              chatId =
                                  authController.userId.value + client["id"];
                            }
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return IndividualChat(
                                combinedId: chatId,
                                receiverInfo: {
                                  "bio": client["bio"],
                                  "createdAt": client["createdAt"],
                                  "updatedAt": client["updatedAt"],
                                  "email": client["email"],
                                  "password": client["password"],
                                  "id": client["id"],
                                  "name": client["name"],
                                  "username": client["username"],
                                  "picture": client["picture"],
                                },
                              );
                            }));
                          },
                          child: ListTile(
                            leading: client["picture"] == null
                                ? const CircleAvatar(
                                    backgroundImage: AssetImage(
                                        "assets/images/profile_picture.png"))
                                : CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(client["picture"])),
                            title: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${client["username"]}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium,
                                  ),
                                  Text(
                                    "${client["username"].toString()}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    );
                    clientWidgets.add(clientWidget);
                  }
                }
                return Column(
                  children: clientWidgets,
                );
              }),
        ),
      ),
    );
  }
}
