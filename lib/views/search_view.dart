import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypt_chat/constants/app_constants.dart';
import 'file:///F:/Flutter_Project/crypt_chat/lib/views/auth/login_view.dart';
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

  AuthMethods authMethods=new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  QuerySnapshot searchUserSnapshot;
  TextEditingController SearchEditingController=new TextEditingController();

  QuerySnapshot UsersSnapshot;

  Widget searchUsersList(){
    return searchUserSnapshot !=null ? ListView.builder(
      shrinkWrap: true,
      itemCount: searchUserSnapshot.docs.length,
      itemBuilder: (context,index){
        return SearchListItem(
          searchUserSnapshot.docs[index].data()["username"],
          searchUserSnapshot.docs[index].data()["email"],
        );
      }) : Container();
  }

  createChatRoom(String username){
    List <String> users=[username,Constants.currentUser];
    String chatRoomID=getChatRoomId(username, Constants.currentUser);
    Map <String,dynamic> ChatRoomMap = {
      'chatRoomID':chatRoomID,
      'users':users
    };
    databaseMethods.createChatRoom(chatRoomID, ChatRoomMap);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ChatScreen(chatRoomID)));
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  Widget userList() {
    return UsersSnapshot !=null ? ListView.builder(
        shrinkWrap: true,
        itemCount: UsersSnapshot.docs.length,
        itemBuilder: (context,index){
          return UserItem(
            UsersSnapshot.docs[index].data()["username"],
          );
        }) : Container();
  }

  Widget UserItem(String username) {
    return username != Constants.currentUser ? InkWell(
      onTap: (){
        createChatRoom(username);
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
                              "Hey there I am using crypt_chat",
                              style: TextStyle(
                                  fontSize: 13, color: Colors.grey.shade600))
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
    ):Container();
  }

  Widget SearchListItem (String username,String email){
    Size screenSize=MediaQuery.of(context).size;
    return username != Constants.currentUser ? GestureDetector(
      onTap: (){
        createChatRoom(username);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
        child: Row(
          children: [
            Column(
              crossAxisAlignment:CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor
                  ),
                ),
                Text(email)
              ],
            ),
            Spacer()
          ],
        ),
      ),
    ) : Container();
  }

  @override
  void initState()  {
    databaseMethods.getAllUsers()
        .then((val)=>{
      setState((){
        UsersSnapshot=val;
      })
    });
    super.initState();
  }
  //
  // void getAllUsers() async {
  //
  // }

  @override
  Widget build(BuildContext context) {
    Size screenSize=MediaQuery.of(context).size;
    return UsersSnapshot!=null ? Scaffold(
      appBar: AppBar(
        elevation: 0,
        title:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Users',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: screenSize.height * 0.028
              ),
            ),
            Text(
              "${UsersSnapshot.docs.length-1} users",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontSize: screenSize.height * 0.025
              ),
            ),
          ],
        )

      ),
      body:Container(
        margin: EdgeInsets.fromLTRB(0, 10.0, 0, 0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child:Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: SearchEditingController,
                      decoration: InputDecoration(
                        hintText: 'Search username...',
                        hintStyle: TextStyle(color: Theme.of(context).primaryColor),
                        border:InputBorder.none,
                      ),
                      style: TextStyle(
                        fontSize: 18.0
                      ),
                    )
                  ),
                  InkWell(
                    onTap: (){
                      databaseMethods.getUserInfoByUsername(SearchEditingController.text)
                          .then((val)=>
                            setState((){
                              searchUserSnapshot= val;
                            })
                      );
                    },
                    child: Container(
                      height: screenSize.height * 0.05,
                        width: screenSize.width * 0.125,
                      decoration: BoxDecoration(
                          color: Color(0xFFF1E6FF),
                        borderRadius: BorderRadius.circular(30.0)
                      ),
                      child: Icon(Icons.search)
                    ),
                  )
                ],
              )
            ),
            //Expanded(child: searchUsersList())
            Expanded(child:userList())
          ],
        ),
      ),

    ):Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Center(child: CircularProgressIndicator()),
    );
  }
}







