import 'package:crypt_chat/constants/app_constants.dart';
import 'package:crypt_chat/utils/helpers/shared_pref_helper.dart';
import 'file:///F:/Flutter_Project/crypt_chat/lib/views/auth/login_view.dart';
import 'package:crypt_chat/utils/services/auth.dart';
import 'package:crypt_chat/utils/services/database.dart';
import 'file:///F:/Flutter_Project/crypt_chat/lib/views/home_view.dart';
import 'package:crypt_chat/widgets/rounded_button.dart';
import 'package:crypt_chat/widgets/rounded_input_field.dart';
import 'package:crypt_chat/widgets/rounded_password_field.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isLoading=false;

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  SharedPrefHelper sharedPrefHelper = new SharedPrefHelper();
  final formKey = GlobalKey<FormState>();

  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();
  TextEditingController usernameEditingController = new TextEditingController();

  void signUpUser(){
    if(formKey.currentState.validate()){

      setState(() {
        isLoading=true;
      });

      authMethods.SignUpWithEmailAndPassword(emailEditingController.text,passwordEditingController.text)
      .then((val){
        if(val!=null) {

          Map <String,String> userInfoMap={
            'username':usernameEditingController.text,
            'email':emailEditingController.text,
            'name':usernameEditingController.text,
            'bio':"It's my Crypt Chat!"
          };

          databaseMethods.uploadUserInfo(usernameEditingController.text,userInfoMap);
          sharedPrefHelper.saveUsernameSharedPref(usernameEditingController.text);
          sharedPrefHelper.saveUserEmailSharedPref(emailEditingController.text);
          sharedPrefHelper.saveUserLoggedInSharedPref(true);

          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => HomeScreen()
          ));
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
                        "assets/images/signup.png",
                        height: screenSize.height * 0.45,
                      ),
                      Text(
                          'REGISTER',
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
                            RoundedInputField(screenSize: screenSize, validator: (value){ return value.isEmpty || value.length < 4 ? "Username too small" : RegExp(r"^[a-zA-Z0-9]+$").hasMatch(value) ?null:"No special characters allowed";},hintText: 'Username',icon: Icons.account_circle_rounded,controller:usernameEditingController),
                            RoundedPasswordField(screenSize: screenSize , validator: (value){ return value.length < 6 ? "Password too small" : null; },hintText: 'Password',icon: Icons.lock,controller:passwordEditingController),
                          ],
                        ),
                      ),
                      RoundedButton(screenSize: screenSize,text:'Register', color: Theme.of(context).primaryColor,textColor:Colors.white,press: signUpUser),
                      SizedBox(height: screenSize.height * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              'Already have an account? ',
                              style:TextStyle(
                                  color:Theme.of(context)
                                      .textTheme
                                      .headline5
                                      .color
                              )
                          ),
                          InkWell(
                            onTap: (){
                              Navigator.pushReplacement(context,MaterialPageRoute(builder: (context){return LoginScreen();}));
                            },
                            child: Text(
                                'Login',
                                style:TextStyle(
                                    color:MediaQuery.of(context).platformBrightness==Brightness.light ? Theme.of(context).primaryColor : Constants.kSecondaryColor,
                                    fontWeight: FontWeight.bold,
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


