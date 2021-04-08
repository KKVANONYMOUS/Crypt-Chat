import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypt_chat/utils/services/database.dart';
import 'package:flutter/material.dart';
import 'package:crypt_chat/constants/app_constants.dart';

class ProfileScreen extends StatefulWidget {

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  DatabaseMethods databaseMethods = new DatabaseMethods();
  QuerySnapshot searchUserSnapshot;
  TextEditingController NameEditingController = new TextEditingController();
  TextEditingController BioEditingController = new TextEditingController();

  @override
  void initState() {
    databaseMethods.getUserInfoByUsername(Constants.currentUser)
    .then((val){
      setState(() {
        searchUserSnapshot=val;
      });
    });
    super.initState();
  }

  updateUserInfo(){
    if(NameEditingController.text.isNotEmpty && BioEditingController.text.isNotEmpty){
      databaseMethods.updateUserInfo(Constants.currentUser, NameEditingController.text, BioEditingController.text);
      print('Profile Updated');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize=MediaQuery.of(context).size;
    return searchUserSnapshot!=null?Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.1,horizontal: 15),
        child: ListView(
          children: [
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 4,
                            color: Theme.of(context).scaffoldBackgroundColor),
                        boxShadow: [
                          BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 10,
                              color: Colors.black.withOpacity(0.1),
                              offset: Offset(0, 10))
                        ],
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage("assets/images/user_avatar.png")),
                    ),

                  ),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 4,
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                          color: Theme.of(context).primaryColor,
                        ),
                        child: Icon(
                          Icons.camera_alt_rounded,
                          color: Colors.white,
                        ),
                      )),
                ],
              ),
            ),
            Center(
              child: Container(
                child: Text('@${searchUserSnapshot.docs[0].data()['username']}',style: TextStyle(color:MediaQuery.of(context).platformBrightness==Brightness.light ? Constants.kPrimaryColor:Constants.kSecondaryColor,fontSize: 15,fontWeight: FontWeight.bold),),
              ),
            ),
            SizedBox(
              height: 35,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
              child: Column(
                children: [
                  ProfileTextField(context,"Name", searchUserSnapshot.docs[0].data()['name'],NameEditingController),
                  ProfileTextField(context,"Bio", searchUserSnapshot.docs[0].data()['bio'],BioEditingController),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.1),
                    child: RaisedButton(
                      onPressed: () {
                        updateUserInfo();
                      },
                      color: MediaQuery.of(context).platformBrightness==Brightness.light ? Constants.kPrimaryColor:Constants.kSecondaryColor,
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Text(
                        "UPDATE",
                        style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 2.2,
                            color: MediaQuery.of(context).platformBrightness==Brightness.light ? Colors.white:Colors.black87),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ):Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Center(child: CircularProgressIndicator()),
    );
  }
}


Widget ProfileTextField(BuildContext context,
    String labelText, String placeholder, TextEditingController controller) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 35.0),
    child: TextField(
      controller: controller ,
      decoration: InputDecoration(
        prefixIcon: Icon(
          labelText=='Bio'?Icons.info_outline_rounded:Icons.account_circle_rounded,
          color: MediaQuery.of(context).platformBrightness==Brightness.light ? Constants.kPrimaryColor:Colors.grey,
        ),
          suffixIcon: IconButton(
            onPressed: () {
            },
            icon: Icon(
              Icons.edit,
              color: MediaQuery.of(context).platformBrightness==Brightness.light ? Colors.grey:Constants.kPrimaryColor,
            ),
          ),
          contentPadding: EdgeInsets.only(bottom: 3),
          labelText: labelText,
          labelStyle: TextStyle(
            color: MediaQuery.of(context).platformBrightness==Brightness.light ? Colors.black45:Colors.grey
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: placeholder,
          hintStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: MediaQuery.of(context).platformBrightness==Brightness.light ? Colors.black:Colors.white70,
          )),
    ),
  );
}
