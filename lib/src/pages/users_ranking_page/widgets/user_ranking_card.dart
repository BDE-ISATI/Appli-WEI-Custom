import 'package:appli_wei_custom/models/user.dart';
import 'package:appli_wei_custom/src/providers/user_store.dart';
import 'package:appli_wei_custom/src/shared/widgets/user_profile_picture.dart';
import 'package:appli_wei_custom/src/shared/widgets/wei_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserRankingCard extends StatelessWidget {
  const UserRankingCard({Key key, @required this.user, @required this.position}) : super(key: key);

  final int position;
  final User user;

  @override
  Widget build(BuildContext context) {
    return Consumer<UserStore>(
      builder: (context, userStore, child) {
        final bool isCurrentUser = user.id == userStore.id;

        final Color cardColor = isCurrentUser ? Theme.of(context).accentColor : Colors.white;
        final Color textColor = isCurrentUser ? Colors.white : Colors.black87;
        final Color teamColor = isCurrentUser ? Colors.white : Colors.black45;
        final Color rankColor = isCurrentUser ? Colors.white : Theme.of(context).accentColor;

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
                flex: 7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text("${user.firstName} ${user.lastName}", style: Theme.of(context).textTheme.headline2.merge(TextStyle(color: textColor))),
                    Text("Score : ${user.score}", style: Theme.of(context).textTheme.headline3.merge(TextStyle(color: textColor))),
                    Text("Equipe ${user.teamName}", style: Theme.of(context).textTheme.headline4.merge(TextStyle(color: teamColor)))
                  ],
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                flex: 3,
                child: Center(
                  child: Text("#$position", style: TextStyle(fontSize: 48, fontFamily: "Futura Light", color: rankColor)),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}