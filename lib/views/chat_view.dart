import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypt_chat/constants/app_constants.dart';
import 'package:crypt_chat/utils/services/database.dart';
import 'package:crypt_chat/utils/services/encryption_decryption.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String ChatRoomID;

  ChatScreen(this.ChatRoomID);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController textEditingController = new TextEditingController();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Stream<QuerySnapshot> ChatMessageStream;

  Widget chatMessageList() {
    return StreamBuilder(
        stream: ChatMessageStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    String msg = snapshot.data.docs[index].data()["message"];
                    return ChatMessageItem(
                        EncryptionDecryption.decryptMessage(
                            encrypt.Encrypted.fromBase64(msg)),
                        Constants.currentUser ==
                                snapshot.data.docs[index].data()["sentBy"]
                            ? true
                            : false,
                        snapshot.data.docs[index].data()["time"]);
                  })
              : Container();
        });
  }

  Widget ChatMessageItem(String message, bool isSentByMe, int time) {
    Size screenSize = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      child: Row(
        mainAxisAlignment:
            isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: screenSize.width * 0.6),
            padding: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
              color: isSentByMe ? Colors.deepPurple : Color(0xFFF1E6FF),
              borderRadius: isSentByMe
                  ? BorderRadius.only(
                      topLeft: Radius.circular(25),
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    )
                  : BorderRadius.only(
                      topRight: Radius.circular(25),
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
            ),
            child: Text(
              message,
              style:
                  TextStyle(color: isSentByMe ? Colors.white : Colors.black87),
            ),
          ),
          // SizedBox(width: 15),
          // Text(
          //   "16:28",
          //   style: TextStyle(
          //     color:Colors.grey
          //   ),
          // ),
        ],
      ),
    );
    // return Container(
    //   padding: EdgeInsets.only(
    //       top: 8,
    //       bottom: 8,
    //       left: isSentByMe ? 0 : 24,
    //       right: isSentByMe ? 24 : 0),
    //   alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
    //   child: Container(
    //     margin: isSentByMe
    //         ? EdgeInsets.only(left: 30)
    //         : EdgeInsets.only(right: 30),
    //     padding: EdgeInsets.only(
    //         top: 17, bottom: 17, left: 20, right: 20),
    //     decoration: BoxDecoration(
    //         borderRadius: isSentByMe ? BorderRadius.only(
    //             topLeft: Radius.circular(23),
    //             topRight: Radius.circular(23),
    //             bottomLeft: Radius.circular(23)
    //         ) :
    //         BorderRadius.only(
    //             topLeft: Radius.circular(23),
    //             topRight: Radius.circular(23),
    //             bottomRight: Radius.circular(23)),
    //         gradient: LinearGradient(
    //           colors: isSentByMe ? [
    //             const Color(0xff007EF4),
    //             const Color(0xff2A75BC)
    //           ]
    //               : [
    //             Colors.grey,
    //             Colors.grey
    //           ],
    //         )
    //     ),
    //     child: Text(message,
    //         textAlign: TextAlign.start,
    //         style: TextStyle(
    //             color: Colors.white,
    //             fontSize: 16,
    //             fontFamily: 'OverpassRegular',
    //             fontWeight: FontWeight.w300)),
    //   ),
    // );
  }

  sendMessage() {
    if (textEditingController.text.isNotEmpty) {
      // Map <String,dynamic> ChatMessageMap = {
      //   "message":textEditingController.text,
      //   "sentBy": Constants.currentUser,
      //   "time":DateTime.now().millisecondsSinceEpoch
      // };

      String encryptedMessage =
          EncryptionDecryption.encryptMessage(textEditingController.text);
      Map<String, dynamic> ChatMessageMap = {
        "message": encryptedMessage,
        "sentBy": Constants.currentUser,
        "time": DateTime.now().millisecondsSinceEpoch
      };

      databaseMethods.addChatMessage(widget.ChatRoomID, ChatMessageMap);
      databaseMethods.addLastChatMessage(widget.ChatRoomID, encryptedMessage);
      textEditingController.text = "";
    }
  }

  @override
  void initState() {
    databaseMethods.getChatMessage(widget.ChatRoomID).then((val) {
      setState(() {
        ChatMessageStream = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                backgroundImage: AssetImage("assets/images/user_avatar.png"),
                maxRadius: 20,
              ),
              SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        widget.ChatRoomID.replaceAll("_", "")
                            .replaceAll(Constants.currentUser, "")
                            .toUpperCase(),
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    SizedBox(height: 6),
                    Text("Online",
                        style:
                            TextStyle(color: Colors.green[200], fontSize: 13)),
                  ],
                ),
              ),
            ],
          )),
      body: Stack(
        children: [
          chatMessageList(),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: [
                  SizedBox(width: 15),
                  Expanded(
                    child: TextField(
                      controller: textEditingController,
                      decoration: InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                    ),
                  ),
                  SizedBox(width: 15),
                  FloatingActionButton(
                    onPressed: () {
                      sendMessage();
                    },
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                    elevation: 0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
