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
  Widget build(BuildContext context) {
    Size screenSize=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title:Text(
          'Chats',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: screenSize.height * 0.03
          ),
        ),
        actions: [
          GestureDetector(
            onTap: (){
              authMethods.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Icon(Icons.exit_to_app),
            ),
          )
        ],
      ),
      body:Container(
        margin: EdgeInsets.fromLTRB(0, 10.0, 0, 0),
        color: Colors.white,
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
                        border:InputBorder.none,
                      ),
                      style: TextStyle(
                        fontSize: 18.0
                      ),
                    )
                  ),
                  GestureDetector(
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
            Expanded(child: searchUsersList())
          ],
        ),
      ),

    );
  }
}







