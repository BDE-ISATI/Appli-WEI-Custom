import 'package:appli_wei_custom/src/providers/user_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserScore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserStore>(
      builder: (context, userStore, child) {
        return Column(
          children: [
            Text(userStore.score.toString(), style: TextStyle(fontSize: 128, color: Theme.of(context).accentColor),),
            const SizedBox(height: 4,),
            const Text("Ton score")
          ],
        );
      },
    );
  }
}