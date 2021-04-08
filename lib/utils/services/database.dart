import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  getAllUsers() async {
    return await FirebaseFirestore.instance
        .collection('users')
        .get();
  }

  getUserInfoByUsername(String username) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get();
  }

  updateUserInfo(String username,String name,String bio) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(username)
        .update({'name':name,'bio':bio});
  }

  getUserInfoByEmail(String email) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
  }

  uploadUserInfo(String username,Map<String, String> userInfoMap) {
    FirebaseFirestore.instance.collection('users').doc(username).set(userInfoMap);
  }

  createChatRoom(String ChatRoomID, Map<String, dynamic> ChatRoomMap) {
    FirebaseFirestore.instance
        .collection('ChatRooms')
        .doc(ChatRoomID)
        .set(ChatRoomMap);
  }

  addChatMessage(String ChatRoomID, Map<String, dynamic> ChatMessageMap) {
    FirebaseFirestore.instance
        .collection('ChatRooms')
        .doc(ChatRoomID)
        .collection('chats')
        .add(ChatMessageMap);
  }

  addLastChat(String ChatRoomID, String lastChatMessage,int time) {
    FirebaseFirestore.instance
        .collection('ChatRooms')
        .doc(ChatRoomID)
        .update({'LastChat.Message': lastChatMessage,'LastChat.Time':time});
  }

  getChatMessage(String ChatRoomID) async {
    return await FirebaseFirestore.instance
        .collection('ChatRooms')
        .doc(ChatRoomID)
        .collection('chats')
        .orderBy("time", descending: false)
        .snapshots();
  }

  getChatRooms(String username) async {
    return await FirebaseFirestore.instance
        .collection('ChatRooms')
        .where('users', arrayContains: username)
        .snapshots();
  }

  getCurrUserChatRooms(String ChatRoomID) async {
    return await FirebaseFirestore.instance
        .collection('ChatRooms')
        .where('chatRoomID',isEqualTo: ChatRoomID)
        .snapshots();
  }
  getCurrUserChatRoomsGet(String ChatRoomID) async {
    return await FirebaseFirestore.instance
        .collection('ChatRooms')
        .where('chatRoomID',isEqualTo: ChatRoomID)
        .get();
  }
}
