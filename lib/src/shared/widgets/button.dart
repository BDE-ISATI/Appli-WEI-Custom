import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button({Key key, 
                @required this.onPressed,
                @required this.text}) : super(key: key);

  final void Function() onPressed;

  final String text;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32)
      ),
      color: Theme.of(context).accentColor,
      child: Text(text, style: const TextStyle(color: Colors.white), textAlign: TextAlign.center,),
    );
  }
}