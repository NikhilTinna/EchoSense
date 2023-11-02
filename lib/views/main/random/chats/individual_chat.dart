import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media/controllers/authController.dart';

class IndividualChat extends StatefulWidget {
  final dynamic receiverInfo;
  final String combinedId;
  const IndividualChat(
      {required this.combinedId, required this.receiverInfo, key});

  @override
  State<IndividualChat> createState() => _IndividualChatState();
}

class _IndividualChatState extends State<IndividualChat> {
  AuthController authController = Get.put(AuthController());
  var chatTable = FirebaseFirestore.instance.collection("Chats");
  final messageController = TextEditingController();

  void getData() async {
    print(widget.receiverInfo);
    var firebasedata = await chatTable.doc(widget.combinedId).get();
    var userInteractionData = FirebaseFirestore.instance
        .collection("Users")
        .doc(authController.userId.value)
        .collection("messages")
        .doc(widget.receiverInfo["id"]);

    if (!firebasedata.exists) {
      await chatTable
          .doc(widget.combinedId)
          .collection("Color")
          .doc(widget.combinedId)
          .set({"chat_theme": "#FF0000"});
      await userInteractionData.set(widget.receiverInfo);
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              InkWell(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back),
              ),
              SizedBox(
                width: 300,
                child: ListTile(
                  leading: widget.receiverInfo["picture"] == null
                      ? const CircleAvatar(
                          backgroundImage:
                              AssetImage("assets/images/profile_picture.png"))
                      : CircleAvatar(
                          backgroundImage:
                              NetworkImage(widget.receiverInfo["picture"]),
                        ),
                  title: Text(
                    widget.receiverInfo["name"],
                    maxLines: 1,
                    style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                        color: Colors.white,
                        fontSize: 20),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                Flexible(
                  flex: 1,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: chatTable
                        .doc(widget.combinedId)
                        .collection("Color")
                        .snapshots(),
                    builder: (context, snapshot) {
                      List<Container> clientWidgets = [];
                      if (snapshot.hasData) {
                        final clients = snapshot.data?.docs;
                        for (var client in clients!) {
                          final clientWidget = Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: Get.width * 0.025),
                            color: Color(int.parse(
                                client["chat_theme"].replaceAll("#", "0xFF"))),
                            child: StreamBuilder<QuerySnapshot>(
                                stream: chatTable
                                    .doc(widget.combinedId)
                                    .collection("messages")
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  List<Row> clientWidgets = [];
                                  if (snapshot.hasData) {
                                    final clients = snapshot.data?.docs;
                                    for (var client in clients!) {
                                      final clientWidget = Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          AnimatedContainer(
                                            duration: const Duration(
                                                milliseconds: 300),
                                            decoration: const BoxDecoration(
                                                color: Colors.blue,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight: Radius.circular(10),
                                                  bottomLeft:
                                                      Radius.circular(10),
                                                )),
                                            padding: const EdgeInsets.all(10),
                                            constraints: BoxConstraints(
                                                minWidth: 50,
                                                maxWidth: Get.width * 0.75,
                                                minHeight: 45),
                                            margin: const EdgeInsets.only(
                                                bottom: 20),
                                            child: Text(
                                              client["message"],
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w400),
                                            ),
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
                          );
                          clientWidgets.add(clientWidget);
                        }
                      }
                      return Column(
                        children: clientWidgets,
                      );
                    },
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        decoration:
                            InputDecoration(hintText: "Enter message.."),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
