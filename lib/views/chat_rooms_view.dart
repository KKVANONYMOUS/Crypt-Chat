import 'package:crypt_chat/constants/app_constants.dart';
import 'package:crypt_chat/utils/helpers/helper_functions.dart';
import 'package:crypt_chat/utils/helpers/shared_pref_helper.dart';
import 'package:crypt_chat/utils/services/database.dart';
import 'package:crypt_chat/utils/services/encryption_decryption.dart';
import 'package:crypt_chat/views/auth/login_view.dart';
import 'package:crypt_chat/views/chat_view.dart';
import 'package:crypt_chat/views/search_view.dart';
import 'package:crypt_chat/utils/services/auth.dart';
import 'package:crypt_chat/widgets/alert_dialog.dart';
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

  Icon searchIcon = new Icon(Icons.search);
  final TextEditingController SearchEditingController =
      new TextEditingController();
  String _searchText = "";

  Widget appBarTitle = new Text(
    'Chats',
    style: TextStyle(
        color: Colors.white60, fontWeight: FontWeight.bold, fontSize: 20),
  );

  _ChatRoomsState() {
    SearchEditingController.addListener(() {
      if (SearchEditingController.text.isNotEmpty) {
        setState(() {
          _searchText = SearchEditingController.text;
        });
        databaseMethods.getUserInfoByUsername(_searchText).then((val) {
          if (val != null && val.size > 0) {
            String ChatRoomID = HelperFunctions.getChatRoomId(
                _searchText, Constants.currentUser);
            databaseMethods.getCurrUserChatRooms(ChatRoomID).then((val) => {
                  setState(() {
                    ChatRoomsStream = val;
                  })
                });
          } else {
            getCurrUserandChats();
          }
        });
      } else {
        getCurrUserandChats();
      }
    });
  }

  void searchChatRoom() {
    setState(() {
      if (this.searchIcon.icon == Icons.search) {
        this.searchIcon = new Icon(Icons.close);
        this.appBarTitle = new TextField(
          controller: SearchEditingController,
          decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.search, color: Colors.white60),
              hintText: 'Search username...',
              hintStyle: TextStyle(color: Colors.white54),
              border: InputBorder.none),
          cursorColor: Colors.white54,
          style: TextStyle(color: Colors.white54),
        );
      } else {
        this.searchIcon = new Icon(Icons.search);
        this.appBarTitle = new Text(
          'Chats',
          style: TextStyle(
              color: Colors.white60, fontWeight: FontWeight.bold, fontSize: 20),
        );
        SearchEditingController.clear();
      }
    });
  }

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
                    String lastMessage = "";
                    int lastMessageTime = 0;
                    if (snapshot.data.docs[index].data()["LastChat"] != null) {
                      lastMessage = EncryptionDecryption.decryptMessage(
                          encrypt.Encrypted.fromBase64(snapshot.data.docs[index]
                              .data()["LastChat"]["Message"]));
                      lastMessageTime =
                          snapshot.data.docs[index].data()["LastChat"]["Time"];
                      return ChatRoomsItem(ChatRoomID, lastMessage,
                          DateTime.fromMillisecondsSinceEpoch(lastMessageTime));
                    }
                    return Container();

                  })
              :Container();
        });
  }

  Widget ChatRoomsItem(
      String ChatRoomID, String lastMessage, final lastMessageTime) {
    String username =
        ChatRoomID.replaceAll('_', "").replaceAll(Constants.currentUser, "");
    String lastMessageDate = lastMessageTime.toString().substring(0, 10);

    String lastMessageTimestamp = lastMessageTime.toString().substring(11, 16);
    String currDate = DateTime.fromMillisecondsSinceEpoch(
            DateTime.now().millisecondsSinceEpoch)
        .toString()
        .substring(0, 10);

    String lastMessageDateFormatted =
        "${lastMessageDate.substring(8, 10)}/${lastMessageDate.substring(5, 7)}/${lastMessageDate.substring(2, 4)}";
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
                          Text('@${username}',
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
                  lastMessageDate != "1970-01-01"
                      ? Text(
                          lastMessageDate == currDate
                              ? lastMessageTimestamp
                              : lastMessageDateFormatted,
                          style: TextStyle(fontSize: 12))
                      : Container()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getCurrUserandChats() async {
    Constants.currentUser = await sharedPrefHelper.getUsernameSharedPref();
    databaseMethods.getChatRooms(Constants.currentUser).then((val) => {
          setState(() {
            ChatRoomsStream = val;
          })
        });
  }

  void LogoutPressed() async {
    final action = await AlertDialogsClass.logoutDialog(
        context, 'Logout', 'Are you sure you want to exit?');
    if (action == DialogsAction.yes) {
      authMethods.signOut();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  @override
  void initState() {
    getCurrUserandChats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        //centerTitle: true,
        elevation: 0,
        title: appBarTitle,
        leading: IconButton(
          icon: searchIcon,
          onPressed: searchChatRoom,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: LogoutPressed,
          )
        ],
      ),
      body: Container(
        child: chatRoomsList(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.person_add_alt_1, color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchScreen()));
        },
      ),
    );
  }
}
