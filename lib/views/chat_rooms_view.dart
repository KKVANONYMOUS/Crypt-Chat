import 'package:crypt_chat/constants/app_constants.dart';
import 'package:crypt_chat/utils/helpers/shared_pref_helper.dart';
import 'package:crypt_chat/utils/services/database.dart';
import 'package:crypt_chat/utils/services/encryption_decryption.dart';
import 'package:crypt_chat/views/auth/login_view.dart';
import 'package:crypt_chat/views/chat_view.dart';
import 'package:crypt_chat/views/search_view.dart';
import 'package:crypt_chat/utils/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class ChatRooms extends StatefulWidget {
  @override
  _ChatRoomsState createState() => _ChatRoomsState();
}

class _ChatRoomsState extends State<ChatRooms> {
  AuthMethods authMethods = new AuthMethods();
  SharedPrefHelper sharedPrefHelper = new SharedPrefHelper();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  Stream ChatRoomsStream;

  int currIndex = 0;

  Widget chatRoomsList() {
    return StreamBuilder(
        stream: ChatRoomsStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    String ChatRoomID =
                        snapshot.data.docs[index].data()["chatRoomID"];
                    String lastMessage = EncryptionDecryption.decryptMessage(
                        encrypt.Encrypted.fromBase64(snapshot.data.docs[index]
                            .data()["LastChatMessage"]));
                    return ChatRoomsItem(ChatRoomID, lastMessage);
                  })
              : Container();
        });
  }

  Widget ChatRoomsItem(String ChatRoomID, String lastMessage) {
    String username =
        ChatRoomID.replaceAll('_', "").replaceAll(Constants.currentUser, "");
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ChatScreen(ChatRoomID)));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage:
                        AssetImage("assets/images/user_avatar.png"),
                    maxRadius: 28,
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              username[0].toUpperCase() +
                                  username.substring((1)),
                              style: TextStyle(fontSize: 16)),
                          SizedBox(height: 6),
                          Text(
                              lastMessage.length > 20
                                  ? lastMessage.substring(0, 20) + "..."
                                  : lastMessage,
                              style: TextStyle(
                                  fontSize: 13, color: Colors.grey.shade600))
                        ],
                      ),
                    ),
                  ),
                  Text("20:00", style: TextStyle(fontSize: 12))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    getCurrUserandChats();
    super.initState();
  }

  void getCurrUserandChats() async {
    Constants.currentUser = await sharedPrefHelper.getUsernameSharedPref();
    databaseMethods.getChatRooms(Constants.currentUser).then((val) => {
          setState(() {
            ChatRoomsStream = val;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Chats',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: screenSize.height * 0.03),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              authMethods.signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Icon(Icons.exit_to_app),
            ),
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(0, 10.0, 0, 0),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              chatRoomsList(),
              // ChatRoomsItem("admin_kunal","test message hai"),
              // ChatRoomsItem("admin_kunal","test message hai"),
              // ChatRoomsItem("admin_kunal","test message hai"),
              // ChatRoomsItem("admin_kunal","test message hai"),
              // ChatRoomsItem("admin_kunal","test message hai"),
              // ChatRoomsItem("admin_kunal","test message hai"),
              // ChatRoomsItem("admin_kunal","test message hai"),
              // ChatRoomsItem("admin_kunal","test message hai"),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.person_add_alt_1, color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchScreen()));
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currIndex,
        onTap: (val) {
          setState(() {
            currIndex = val;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.message_rounded), label: "Chats"),
          BottomNavigationBarItem(
              icon: CircleAvatar(
                backgroundImage: AssetImage("assets/images/user_avatar.png"),
                radius: 12,
              ),
              label: "Profile"),
        ],
      ),
    );
  }
}
