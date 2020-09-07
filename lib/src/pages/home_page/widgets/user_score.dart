import 'package:appli_wei_custom/models/user.dart';
import 'package:appli_wei_custom/services/user_service.dart';
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
            FutureBuilder(
              future: UserService.instance.getUser(userStore.authentificationHeader, userStore.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (!snapshot.hasData) {
                    return const Text("Une erreur s'est produite...");
                  }

                  final User player = snapshot.data as User;
                  return Text(player.score.toString(), style: TextStyle(fontSize: 128, color: Theme.of(context).accentColor),);

                }
                else {
                  return const CircularProgressIndicator();
                }
              },
            ),
            const SizedBox(height: 4,),
            const Text("Ton score")
          ],
        );
      },
    );
  }
}