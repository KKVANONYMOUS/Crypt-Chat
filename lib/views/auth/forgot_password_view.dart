import 'package:crypt_chat/utils/services/auth.dart';
import 'package:flutter/material.dart';
class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController EmailEditingController=new TextEditingController();

  AuthMethods authMethods = new AuthMethods();

  final scaffoldKey=GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    resetPasswordHandler (){
      if(EmailEditingController.text.isNotEmpty && RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(EmailEditingController.text)){
        try {
          authMethods.resetPassword(EmailEditingController.text);
          SnackBar snackBar=SnackBar(duration: Duration(seconds: 1),content: Text('Email sent!',style: TextStyle(color: Colors.white)),backgroundColor: Colors.green);
          scaffoldKey.currentState.showSnackBar(snackBar);
          Future.delayed(Duration(seconds: 1), () {
            Navigator.of(context).pop();
          });
        }
        catch(e){
          SnackBar snackBar=SnackBar(content: Text('Some error occured',style: TextStyle(color: Colors.white)),backgroundColor: Colors.red);
          scaffoldKey.currentState.showSnackBar(snackBar);
        }
      }
      else{
        SnackBar snackBar=SnackBar(content: Text('Enter valid email!',style: TextStyle(color: Colors.white)),backgroundColor: Colors.red);
        scaffoldKey.currentState.showSnackBar(snackBar);
      }
    }

    Size screenSize=MediaQuery.of(context).size;
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(),
        body:Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(text: TextSpan(text: "Reset Password",style: TextStyle(color: MediaQuery.of(context).platformBrightness==Brightness.light?Colors.black87:Colors.white,fontWeight:FontWeight.bold,fontSize: 20))),
              SizedBox(height: screenSize.height * 0.01),
              Text("Enter the email associated with your account and we'll send an email with instructions to reset your password",style: TextStyle(fontSize: 15,fontWeight:FontWeight.bold,color: MediaQuery.of(context).platformBrightness==Brightness.light?Colors.black54:Colors.white54)),
              SizedBox(height: screenSize.height * 0.05),
              Text("Email address",style: TextStyle(fontSize: 15,fontWeight:FontWeight.bold,color: MediaQuery.of(context).platformBrightness==Brightness.light?Colors.black54:Colors.white54)),
              SizedBox(height: screenSize.height * 0.01),
              TextField(
                controller: EmailEditingController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter email address..",
                  hintStyle: TextStyle(
                    color: MediaQuery.of(context).platformBrightness==Brightness.light?Colors.black54:Colors.white54
                  )
                ),
              ),
              SizedBox(height: screenSize.height * 0.03),
              FlatButton(
                onPressed: resetPasswordHandler,
                color: Theme.of(context).primaryColor,
                minWidth: double.infinity,
                padding: EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Text(
                  'Send Instructions',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    letterSpacing: 1
                  ),
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}