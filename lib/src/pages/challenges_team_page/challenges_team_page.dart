import 'package:appli_wei_custom/src/pages/challenges_team_page/widgets/challenges_team_list.dart';
import 'package:appli_wei_custom/src/pages/main_page/widgets/menu_drawer.dart';
import 'package:appli_wei_custom/src/shared/widgets/button.dart';
import 'package:flutter/material.dart';

class ChallengesTeamPage extends StatelessWidget {
  const ChallengesTeamPage({Key key, @required this.onSelectedTab}) : super(key: key);

  final ValueChanged<TabItem> onSelectedTab;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("Défis d'équipe", style: Theme.of(context).textTheme.headline1,),
          const SizedBox(height: 16,),
          Expanded(
            child: ChallengesTeamList()
          ),
          Button(
            onPressed: () {
              onSelectedTab(TabItem.challengesPlayer);
            },
            text: "Défis individuels",
          )
        ],
      ),
    );
  }
}