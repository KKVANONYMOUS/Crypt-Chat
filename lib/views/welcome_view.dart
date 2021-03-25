import 'file:///F:/Flutter_Project/crypt_chat/lib/views/auth/login_view.dart';
import 'file:///F:/Flutter_Project/crypt_chat/lib/views/auth/sign_up_view.dart';
import 'package:crypt_chat/constants/app_constants.dart';
import 'package:crypt_chat/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size screenSize=MediaQuery.of(context).size;
    return Scaffold(
      body:SafeArea(
        child: Container(
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
                          fontWeight: FontWeight.w900,
                          color: Theme.of(context)
                              .textTheme
                              .headline5
                              .color,
                        )
                    ),
                    Image.asset(
                      "assets/images/welcome_screen.png",
                      height: screenSize.height * 0.5,
                    ),
                    Text(
                      "Experience a new way to keep your chats \nsafe and secure",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .color
                            .withOpacity(0.8),
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.04),
                    RoundedButton(screenSize: screenSize,text:'Login', color: Theme.of(context).primaryColor,textColor:Colors.white,press: () {
                     Navigator.pushReplacement(context,MaterialPageRoute(builder: (context){return LoginScreen();}));
                    }),
                    RoundedButton(screenSize: screenSize,text:'Register', color: Constants.kSecondaryColor,textColor:Colors.black,press: () {
                      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context){return SignUpScreen();}));
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}

