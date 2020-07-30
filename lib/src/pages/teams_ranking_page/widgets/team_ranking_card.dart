import 'package:appli_wei_custom/models/team.dart';
import 'package:appli_wei_custom/src/providers/user_store.dart';
import 'package:appli_wei_custom/src/shared/widgets/team_image.dart';
import 'package:appli_wei_custom/src/shared/widgets/wei_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TeamRankingCard extends StatelessWidget {
  const TeamRankingCard({Key key, @required this.team, @required this.position}) : super(key: key);

  final int position;
  final Team team;

  @override
  Widget build(BuildContext context) {
    return Consumer<UserStore>(
      builder: (context, userStore, child) {
        final bool isCurrentTeam = team.id == userStore.teamId;

        final Color cardColor = isCurrentTeam ? Theme.of(context).accentColor : Colors.white;
        final Color textColor = isCurrentTeam ? Colors.white : Colors.black87;
        final Color rankColor = isCurrentTeam ? Colors.white : Theme.of(context).accentColor;

        return WeiCard(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
          margin: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8.0),
          color: cardColor,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(32.0),
                child: TeamImage(team: team, width: 64.0, height: 64.0, boxFit: BoxFit.cover,)
              ),
              const SizedBox(width: 8.0,),
              Expanded(
                flex: 7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(team.name, style: Theme.of(context).textTheme.headline2.merge(TextStyle(color: textColor))),
                    Text("Score : ${team.score}", style: Theme.of(context).textTheme.headline3.merge(TextStyle(color: textColor))),
                    const SizedBox(height: 8.0,),
                    GestureDetector(
                      onTap: () {},
                      child: Text("VOIR L'EQUIPE", style: TextStyle(color: rankColor),),
                    )
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