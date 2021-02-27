import 'package:cloud_firestore/cloud_firestore.dart';
import 'file:///F:/Flutter_Project/crypt_chat/lib/views/auth/login_view.dart';
import 'package:crypt_chat/utils/services/auth.dart';
import 'package:crypt_chat/utils/services/database.dart';
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
          username: searchUserSnapshot.docs[index].data()["username"],
          email: searchUserSnapshot.docs[index].data()["email"],
        );
      }) : Container();
  }

  createChatRoom(String username){
    // List <String> users=[username,]
    // databaseMethods.createChatRoom(ChatRoomID, ChatRoomMap)
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
        decoration: BoxDecoration(
            color:Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0)
            )
        ),
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


class SearchListItem extends StatelessWidget {
  final String username;
  final String email;
  SearchListItem({this.username,this.email});

  @override
  Widget build(BuildContext context) {
    Size screenSize=MediaQuery.of(context).size;
    return GestureDetector(
      onTap: (){},
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
    );
  }
}






