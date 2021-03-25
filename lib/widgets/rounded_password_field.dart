import 'package:flutter/material.dart';

class RoundedPasswordField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final Function validator;
  final IconData icon;

  const RoundedPasswordField({
    Key key,
    @required this.screenSize,
    @required this.hintText,
    @required this.validator,
    @required this.icon,
    @required this.controller,
  }) : super(key: key);

  final Size screenSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 5.0),
      width: screenSize.width * 0.8,
      decoration: BoxDecoration(
        color: Color(0xFFF1E6FF),
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: TextFormField(
        style: TextStyle(
            color:Colors.black87
        ),
        validator: validator,
        controller: controller,
        obscureText: true,
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
          icon:Icon(
            icon,
            color:Theme.of(context).primaryColor,
          ),
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 15.0),
          border:InputBorder.none,
        ),
      ),
    );
  }
}
