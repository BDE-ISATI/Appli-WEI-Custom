import 'package:appli_wei_custom/src/pages/main_page/widgets/menu_drawer.dart';
import 'package:appli_wei_custom/src/pages/users_ranking_page/widgets/users_ranking.dart';
import 'package:appli_wei_custom/src/shared/widgets/button.dart';
import 'package:flutter/material.dart';

class UsersRankingPage extends StatelessWidget {
  const UsersRankingPage({Key key, @required this.onSelectedTab}) : super(key: key);

  final ValueChanged<TabItem> onSelectedTab;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("Classement des joueurs", style: Theme.of(context).textTheme.headline1,),
          const SizedBox(height: 16,),
          Expanded(
            child: UsersRanking(),
          ),
          Button(
            onPressed: () {
              onSelectedTab(TabItem.challengesTeam);
            },
            text: "Classement des équipes",
          )
        ],
      ),
    );
  }
}