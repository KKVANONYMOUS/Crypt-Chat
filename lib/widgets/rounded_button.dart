import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Color color,textColor;
  final Function press;

  const RoundedButton({
    Key key,
    @required this.screenSize,
    @required this.text,
    @required this.color,
    @required this.textColor,
    @required this.press,
  }) : super(key: key);

  final Size screenSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenSize.width * 0.8,
      margin: EdgeInsets.symmetric(vertical:screenSize.height * 0.01),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30.0),
        child: FlatButton(
          onPressed: press,
          padding: EdgeInsets.symmetric(horizontal: 40.0,vertical: 20.0),
          color: color,
          child: Text(
            text,
            style: TextStyle(
                color: textColor,
                //fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
    );
  }
}
