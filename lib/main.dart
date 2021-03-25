import 'package:crypt_chat/theme.dart';
import 'package:crypt_chat/utils/helpers/shared_pref_helper.dart';
import 'package:crypt_chat/views/chat_rooms_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:crypt_chat/views/welcome_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn;
  @override
  void initState() {
    setState(() {
      getLoggedInState();
    });
    super.initState();
  }

  getLoggedInState()async{
    await SharedPrefHelper().getUserLoggedInSharedPref()
        .then((val){
          setState(() {
            isLoggedIn = val;
          });
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CryptChat',
      theme: lightThemeData(context),
      darkTheme: darkThemeData(context),
      home:isLoggedIn != null ? isLoggedIn ? ChatRooms():WelcomeScreen() : WelcomeScreen(),
    );
  }
}


