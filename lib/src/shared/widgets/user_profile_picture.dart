import 'dart:convert';

import 'package:appli_wei_custom/models/user.dart';
import 'package:appli_wei_custom/services/user_service.dart';
import 'package:appli_wei_custom/src/providers/user_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProfilePicture extends StatelessWidget {
  const UserProfilePicture({Key key, this.user, this.size = 64}) : super(key: key);
  
  final User user;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Consumer<UserStore>(
      builder: (context, userStore, child) {
        if ((user == null && userStore.profilePicture == null) || (user != null && user.profilePicture == null)) {
          return FutureBuilder(
            future: UserService.instance.getProfilePicture(userStore.authentificationHeader, user == null ? userStore.id : user.id, user == null ? userStore.profilePictureId : user.profilePictureId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (!snapshot.hasData) {
                  return const Center(child: Text("Image not loaded"));
                }

                if (user != null) {
                  user.profilePicture = snapshot.data as String;
                }
                else {
                  userStore.updateProfilePicture(snapshot.data as String);
                }

                return Image.memory(
                  base64Decode(snapshot.data as String),
                  height: size,
                  width: size,
                  fit: BoxFit.fitHeight,
                );
              }

              return const Center(child: CircularProgressIndicator(),);
            },
          );
        }

        return Image.memory(
          base64Decode(user != null ? user.profilePicture : userStore.profilePicture),
          height: size,
          width: size,
          fit: BoxFit.fitHeight,
        );
      }
    );
  }
}