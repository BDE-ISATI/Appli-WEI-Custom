import 'package:appli_wei_custom/src/providers/user_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserStore>(
      builder: (context, userStore, child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(48),
                  child: const Image(
                    image: AssetImage("assets/images/players.jpg"), 
                    height: 96,
                    width: 96,
                    fit: BoxFit.fitHeight,
                  ),
              ),
              const SizedBox(width: 16,),
              Flexible(
                child: Text("Bienvenue ${userStore.firstName}", style: Theme.of(context).textTheme.headline1,)
              )
            ],
          ),
        );
      },
    );
  }
}