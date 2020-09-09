import 'package:appli_wei_custom/models/user.dart';
import 'package:appli_wei_custom/src/shared/widgets/user_profile_picture.dart';
import 'package:flutter/material.dart';

class UserTitle extends StatelessWidget {
  const UserTitle({Key key, @required this.user}) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(48),
              child: UserProfilePicture(size: 96.0, user: user,)
          ),
          const SizedBox(width: 16,),
          Flexible(
            child: Text("Profil de ${user.firstName}", style: Theme.of(context).textTheme.headline1,)
          )
        ],
      ),
    );
  }
}