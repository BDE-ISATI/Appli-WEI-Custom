import 'package:appli_wei_custom/models/team.dart';
import 'package:appli_wei_custom/models/user.dart';
import 'package:appli_wei_custom/src/providers/user_store.dart';
import 'package:appli_wei_custom/src/shared/widgets/button.dart';
import 'package:appli_wei_custom/src/shared/widgets/user_profile_picture.dart';
import 'package:appli_wei_custom/src/shared/widgets/wei_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TeamUserCard extends StatelessWidget {
  const TeamUserCard({Key key, @required this.user, @required this.team}) : super(key: key);

  final Team team;
  final User user;

  @override
  Widget build(BuildContext context) {
    return Consumer<UserStore>(
      builder: (context, userStore, child) {
        final bool isCurrentUser = user.id == userStore.id;

        final Color cardColor = isCurrentUser ? Theme.of(context).accentColor : Colors.white;
        final Color textColor = isCurrentUser ? Colors.white : Colors.black87;

        return WeiCard(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
          margin: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8.0),
          color: cardColor,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(32.0),
                child: UserProfilePicture(user: user,)
              ),
              const SizedBox(width: 8.0,),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text("${user.firstName} ${user.lastName}", style: Theme.of(context).textTheme.headline2.merge(TextStyle(color: textColor))),
                    Text("Score : ${user.score}", style: Theme.of(context).textTheme.headline3.merge(TextStyle(color: textColor))),
                    Visibility(
                      visible: userStore.hasPermission(UserRoles.administrator) || (userStore.hasPermission(UserRoles.captain) && userStore.teamId == team.id),
                      child: Button(
                        text: "Voire le profil",
                        onPressed: () async {},
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}