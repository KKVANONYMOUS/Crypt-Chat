import 'file:///F:/Flutter_Project/crypt_chat/lib/views/auth/login_view.dart';
import 'file:///F:/Flutter_Project/crypt_chat/lib/views/auth/sign_up_view.dart';
import 'package:crypt_chat/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size screenSize=MediaQuery.of(context).size;
    return Scaffold(
      body:Container(
        width: double.infinity,
        height: screenSize.height,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      'WELCOME TO CRYPTCHAT',
                      style:TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor
                      )
                  ),
                  SizedBox(height: screenSize.height * 0.03),
                  SvgPicture.asset(
                    "assets/images/chat.svg",
                    height: screenSize.height * 0.45,
                  ),
                  SizedBox(height: screenSize.height * 0.04),
                  RoundedButton(screenSize: screenSize,text:'LOGIN', color: Theme.of(context).primaryColor,textColor:Colors.white,press: () {
                   Navigator.push(context,MaterialPageRoute(builder: (context){return LoginScreen();}));
                  }),
                  RoundedButton(screenSize: screenSize,text:'SIGN UP', color: Color(0xFFF1E6FF),textColor:Colors.black,press: () {
                    Navigator.push(context,MaterialPageRoute(builder: (context){return SignUpScreen();}));
                  }),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}

