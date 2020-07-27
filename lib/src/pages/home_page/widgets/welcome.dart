import 'package:appli_wei_custom/src/providers/user_store.dart';
import 'package:appli_wei_custom/src/shared/widgets/user_profile_picture.dart';
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
                  child: const UserProfilePicture(size: 96.0,)
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