import 'package:crypt_chat/model/user.dart';
import 'package:crypt_chat/utils/helpers/shared_pref_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods{
  final FirebaseAuth _auth=FirebaseAuth.instance;

  UserClass _userFromFirebaseUser(User firebaseUser){
    return firebaseUser != null ? UserClass(userID:firebaseUser.uid) : null;
  }

  // ignore: non_constant_identifier_names
  Future LoginWithEmailAndPassword(String email,String password) async {
    try{
      UserCredential result= await _auth.signInWithEmailAndPassword(email: email, password: password);
      User firebaseUser= result.user;
      return _userFromFirebaseUser(firebaseUser);
    }
    catch(e){
      print(e);
    }
  }

  // ignore: non_constant_identifier_names
  Future SignUpWithEmailAndPassword(String email,String password) async {
    try{
      UserCredential result= await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User firebaseUser=result.user;
      return _userFromFirebaseUser(firebaseUser);
    }
    catch(e){
      print(e);
    }
  }

  Future resetPassword(String email) async {
    try{
      return await _auth.sendPasswordResetEmail(email: email);
    }
    catch(e){

    }
  }

  Future signOut() async {
    try{
      SharedPrefHelper().saveUserLoggedInSharedPref(false);
      return await _auth.signOut();
    }
    catch(e){
      print(e);
    }
  }
}