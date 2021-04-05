import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypt_chat/constants/app_constants.dart';
import 'package:crypt_chat/utils/helpers/helper_functions.dart';
import 'package:crypt_chat/utils/helpers/helper_functions.dart';
import 'package:crypt_chat/utils/helpers/helper_functions.dart';
import 'package:crypt_chat/utils/services/auth.dart';
import 'package:crypt_chat/utils/services/database.dart';
import 'package:crypt_chat/views/chat_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  QuerySnapshot searchUserSnapshot;
  TextEditingController SearchEditingController = new TextEditingController();

  QuerySnapshot UsersSnapshot;
  QuerySnapshot ChatRoomsSnapshot;

  Widget searchUsersList() {
    return searchUserSnapshot != null
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchUserSnapshot.docs.length,
            itemBuilder: (context, index) {
              return UserItem(
                searchUserSnapshot.docs[index].data()["username"],
                searchUserSnapshot.docs[index].data()["email"],
              );
            })
        : Container();
  }

  createChatRoom(String username) {
    List<String> users = [username, Constants.currentUser];
    String chatRoomID = HelperFunctions.getChatRoomId(username, Constants.currentUser);
    Map<String, dynamic> ChatRoomMap = {
      'chatRoomID': chatRoomID,
      'users': users
    };
    databaseMethods.createChatRoom(chatRoomID, ChatRoomMap);
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => ChatScreen(chatRoomID)));
  }

  Widget userList() {
    return UsersSnapshot != null
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: UsersSnapshot.docs.length,
            itemBuilder: (context, index) {
              return UserItem(
                  UsersSnapshot.docs[index].data()["username"], "test");
            })
        : Container();
  }

  Widget UserItem(String username, String email) {
    return username != Constants.currentUser
        ? InkWell(
            onTap: () {
              String chatRoomID =
                  HelperFunctions.getChatRoomId(username, Constants.currentUser);
              databaseMethods.getCurrUserChatRoomsGet(chatRoomID).then((val) {
                val.size>0
                    ? Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatScreen(chatRoomID)))
                    : createChatRoom(username);
              });
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
                                Text("Hey there I am using crypt_chat",
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey.shade600))
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        : Container();
  }

  @override
  void initState() {
    getAllUsers();
    super.initState();
  }

  void getAllUsers() {
    databaseMethods.getAllUsers().then((val) => {
          setState(() {
            UsersSnapshot = val;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return UsersSnapshot != null
        ? Scaffold(
            appBar: AppBar(
                elevation: 0,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Users',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: screenSize.height * 0.024),
                    ),
                    Text(
                      "${UsersSnapshot.docs.length - 1} users",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          fontSize: screenSize.height * 0.02),
                    ),
                  ],
                )),
            body: Container(
              child: Column(
                children: [
                  Divider(color: Colors.white70, height: 0.5),
                  Container(
                      child: Row(
                    children: [
                      Expanded(
                          child: Container(
                        height: screenSize.height * 0.06,
                        child: TextField(
                          controller: SearchEditingController,
                          style: TextStyle(fontSize: 16),
                          decoration: InputDecoration(
                            hintText: 'Search username...',
                            hintStyle: TextStyle(color: Colors.white70),
                            border: InputBorder.none,
                            filled: true,
                            fillColor: Constants.kPrimaryColor,
                          ),
                        ),
                      )),
                      InkWell(
                        onTap: () {
                          databaseMethods
                              .getUserInfoByUsername(
                                  SearchEditingController.text)
                              .then((val) => setState(() {
                                    searchUserSnapshot = val;
                                  }));
                        },
                        child: Container(
                            height: screenSize.height * 0.06,
                            width: screenSize.width * 0.125,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                            ),
                            child: Icon(
                              Icons.search,
                              color: Colors.white70,
                            )),
                      ),
                    ],
                  )),
                  Expanded(
                      child: searchUserSnapshot != null
                          ? searchUserSnapshot.size > 0
                              ? searchUsersList()
                              : userList()
                          : userList())
                ],
              ),
            ),
          )
        : Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Center(child: CircularProgressIndicator()),
          );
  }
}
