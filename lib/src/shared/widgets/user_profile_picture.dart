import 'package:appli_wei_custom/src/providers/user_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProfilePicture extends StatelessWidget {
  const UserProfilePicture({Key key, this.size = 64}) : super(key: key);
  
  final double size;

  @override
  Widget build(BuildContext context) {
    return Consumer<UserStore>(
      builder: (context, userStore, child) {
        if (userStore.profilePicture != null) {
          return Image.memory(
            userStore.profilePicture,
            height: size,
            width: size,
            fit: BoxFit.fitHeight,
          );
        }
        
        return Image(
          image: const AssetImage("assets/logo.jpg"), 
          height: size,
          width: size,
          fit: BoxFit.fitHeight,
        ); 
      }
    );
  }
}