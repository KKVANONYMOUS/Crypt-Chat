import 'file:///F:/Flutter_Project/crypt_chat/lib/views/auth/login_view.dart';
import 'package:crypt_chat/constants/app_constants.dart';
import 'package:crypt_chat/utils/helpers/shared_pref_helper.dart';
import 'package:crypt_chat/utils/services/database.dart';
import 'package:crypt_chat/views/chat_view.dart';
import 'package:crypt_chat/views/search_view.dart';
import 'package:crypt_chat/utils/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatRooms extends StatefulWidget {
  @override
  _ChatRoomsState createState() => _ChatRoomsState();
}

class _ChatRoomsState extends State<ChatRooms> {
  AuthMethods authMethods = new AuthMethods();
  SharedPrefHelper sharedPrefHelper = new SharedPrefHelper();
  DatabaseMethods databaseMethods= new DatabaseMethods();

  Stream ChatRoomsStream;

  Widget chatRoomsList(){

    return StreamBuilder(
        stream: ChatRoomsStream,
        builder: (context,snapshot){
          return snapshot.hasData ? ListView.separated(
              shrinkWrap: true,
              itemCount: snapshot.data.docs.length,
              separatorBuilder: (context,index)=>Divider(height: 0.5),
              itemBuilder: (context,index){
                return ChatRoomsItem(
                    snapshot.data.docs[index].data()["chatRoomID"],
                );
              }
          ) : Container();
        }
    );
  }

  Widget ChatRoomsItem(String ChatRoomID){
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatScreen(ChatRoomID)));
      },
      child: Container(
        padding: EdgeInsets.only(left: 16,right: 16,top: 10,bottom: 10),
        child: Row(
          children:[
            Expanded(
              child: Row(
                children:[
                  CircleAvatar(
                    backgroundImage: AssetImage("assets/images/user_avatar.png"),
                    maxRadius: 30,
                  ),
                  SizedBox(width: 16,),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(ChatRoomID.replaceAll('_', "").replaceAll(Constants.currentUser, "").toUpperCase(), style: TextStyle(fontSize: 16))
                        ],
                      ),
                    ),
                  ),
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
    Constants.currentUser=await sharedPrefHelper.getUsernameSharedPref();
    databaseMethods.getChatRooms(Constants.currentUser)
        .then((val)=>{
      setState((){
        ChatRoomsStream = val;
      })
    });
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
        // decoration: BoxDecoration(
        //   color:Colors.white,
        //   borderRadius: BorderRadius.only(
        //     topLeft: Radius.circular(30.0),
        //     topRight: Radius.circular(30.0)
        //   )
        // ),
        child: Column(
          children: [
            chatRoomsList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: (){
          Navigator.push(context,MaterialPageRoute(builder: (context)=>SearchScreen()));
        },
      ),
    );
  }
}
