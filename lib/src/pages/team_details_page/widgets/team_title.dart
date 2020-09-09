import 'package:appli_wei_custom/models/team.dart';
import 'package:appli_wei_custom/src/pages/team_details_page/team_users_page/team_users_page.dart';
import 'package:appli_wei_custom/src/shared/widgets/button.dart';
import 'package:appli_wei_custom/src/shared/widgets/wei_card.dart';
import 'package:flutter/material.dart';

class TeamTitle extends StatelessWidget {
  const TeamTitle({Key key, @required this.team}) : super(key: key);

  final Team team;

  @override
  Widget build(BuildContext context) {
    return WeiCard(
      height: 150,
      margin: const EdgeInsets.all(0),
      child: Row(
        children: [
          Expanded(
            flex: 7,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(team.name, style: Theme.of(context).textTheme.headline2,),
                Text("Capitaine : ${team.captainName}", style: Theme.of(context).textTheme.headline3,),
                Button(text: "Voir les membres", onPressed: () async {
                  await Navigator.of(context).push<void>(
                    MaterialPageRoute(builder: (context) => TeamUsersPage(team: team,))
                  );
                },)
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(team.score.toString(), style: TextStyle(fontSize: 42, fontFamily: "Futura Light", color: Theme.of(context).accentColor),),
                Text("Score", style: Theme.of(context).textTheme.headline4,)
              ],
            ),
          )
        ],
      )
    );
  }
}