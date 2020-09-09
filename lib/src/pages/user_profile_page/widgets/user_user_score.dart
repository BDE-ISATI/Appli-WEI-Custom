import 'package:appli_wei_custom/models/user.dart';
import 'package:flutter/material.dart';

class UserUserScore extends StatelessWidget {
  const UserUserScore({Key key, @required this.user}) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(user.score.toString(), style: TextStyle(fontSize: 128, color: Theme.of(context).accentColor),),
        const SizedBox(height: 4,),
        const Text("Score")
      ],
    );
  }
}