import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypt_chat/constants/app_constants.dart';
import 'package:crypt_chat/utils/helpers/shared_pref_helper.dart';
import 'package:crypt_chat/utils/services/auth.dart';
import 'package:crypt_chat/utils/services/database.dart';
import 'file:///F:/Flutter_Project/crypt_chat/lib/views/home_view.dart';
import 'package:crypt_chat/widgets/rounded_button.dart';
import 'package:crypt_chat/widgets/rounded_input_field.dart';
import 'package:crypt_chat/widgets/rounded_password_field.dart';
import 'file:///F:/Flutter_Project/crypt_chat/lib/views/auth/sign_up_view.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading=false;

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  SharedPrefHelper sharedPrefHelper = new SharedPrefHelper();

  final formKey = GlobalKey<FormState>();

  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();

  void loginUser(){
    if(formKey.currentState.validate()){

      setState(() {
        isLoading=true;
      });

      authMethods.LoginWithEmailAndPassword(emailEditingController.text,passwordEditingController.text)
          .then((val) async {
        if(val !=null){

          QuerySnapshot loginSnapshot= await databaseMethods.getUserInfoByEmail(emailEditingController.text);
          sharedPrefHelper.saveUserEmailSharedPref(loginSnapshot.docs[0].data()["email"]);
          sharedPrefHelper.saveUsernameSharedPref(loginSnapshot.docs[0].data()["username"]);
          sharedPrefHelper.saveUserLoggedInSharedPref(true);

          Navigator.pushReplacement(context,MaterialPageRoute(
              builder:(context)=>HomeScreen()
          ));
        }else{
          setState(() {
            isLoading=false;
          });
        }
        
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize=MediaQuery.of(context).size;
    return Scaffold(
      body:isLoading ? Container(
        child: Center(
            child:CircularProgressIndicator()
        ),
      ):Container(
        height: screenSize.height,
        width: double.infinity,
        child:Stack(
          alignment: Alignment.center,
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Image.asset(
                    "assets/images/login.png",
                    height: screenSize.height * 0.45,
                  ),
                  Text(
                      'LOGIN',
                      style:TextStyle(
                          fontWeight: FontWeight.bold,
                          color: MediaQuery.of(context).platformBrightness==Brightness.light ? Theme.of(context).primaryColor : Constants.kSecondaryColor,
                          fontSize: 20.0
                      )
                  ),
                  SizedBox(height: screenSize.height * 0.03),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        RoundedInputField(screenSize: screenSize, validator: (value){ return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value) ? null : "Enter correct email";},hintText: 'Email Address',icon: Icons.email,controller:emailEditingController),
                        RoundedPasswordField(screenSize: screenSize , validator: (value){ return value.length < 6 ? "Password too small" : null; },hintText: 'Password',icon: Icons.lock,controller:passwordEditingController),
                      ],
                    ),
                  ),
                  RoundedButton(screenSize: screenSize,text:'Login', color: Theme.of(context).primaryColor,textColor:Colors.white,press: loginUser),
                  SizedBox(height: screenSize.height * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don’t have an Account ? ',
                        style:TextStyle(
                          color:Theme.of(context)
                              .textTheme
                              .headline5
                              .color
                        )
                      ),
                      InkWell(
                        onTap: (){
                          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context){return SignUpScreen();}));
                        },
                        child: Text(
                          'Register',
                          style:TextStyle(
                            color: MediaQuery.of(context).platformBrightness==Brightness.light ? Theme.of(context).primaryColor : Constants.kSecondaryColor ,
                            fontWeight: FontWeight.bold
                          )
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        )
      )
    );
  }
}


