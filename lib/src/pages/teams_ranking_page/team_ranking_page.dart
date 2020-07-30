import 'package:appli_wei_custom/src/pages/main_page/widgets/menu_drawer.dart';
import 'package:appli_wei_custom/src/pages/teams_ranking_page/widgets/team_ranking.dart';
import 'package:appli_wei_custom/src/shared/widgets/button.dart';
import 'package:flutter/material.dart';

class TeamsRankingPage extends StatelessWidget {
  const TeamsRankingPage({Key key, @required this.onSelectedTab}) : super(key: key);

  final ValueChanged<TabItem> onSelectedTab;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("Classement des équipes", style: Theme.of(context).textTheme.headline1,),
          const SizedBox(height: 16,),
          Expanded(
            child: TeamsRanking(),
          ),
          Button(
            onPressed: () {
              onSelectedTab(TabItem.rankingPlayers);
            },
            text: "Classement des joueurs",
          )
        ],
      ),
    );
  }
}