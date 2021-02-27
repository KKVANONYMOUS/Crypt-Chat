import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{
  getUserInfoByUsername(String username) async {
    return await FirebaseFirestore.instance.collection('users')
        .where('username',isEqualTo: username).get();
  }

  getUserInfoByEmail(String email) async {
    return await FirebaseFirestore.instance.collection('users')
        .where('email',isEqualTo: email).get();
  }
  uploadUserInfo(Map<String,String > userInfoMap){
    FirebaseFirestore.instance.collection('users').add(userInfoMap);
  }

  createChatRoom(String ChatRoomID,Map <String,String> ChatRoomMap){
    FirebaseFirestore.instance.collection(ChatRoomID).add(ChatRoomMap);
  }
}