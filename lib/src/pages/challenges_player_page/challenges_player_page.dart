import 'package:appli_wei_custom/models/user.dart';
import 'package:appli_wei_custom/src/pages/challenges_player_page/widgets/challenges_player_captain_list.dart';
import 'package:appli_wei_custom/src/pages/challenges_player_page/widgets/challenges_player_list.dart';
import 'package:appli_wei_custom/src/pages/main_page/widgets/menu_drawer.dart';
import 'package:appli_wei_custom/src/providers/user_store.dart';
import 'package:appli_wei_custom/src/shared/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChallengesPlayerPage extends StatelessWidget {
  const ChallengesPlayerPage({Key key, @required this.onSelectedTab}) : super(key: key);

  final ValueChanged<TabItem> onSelectedTab;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("Défis individuels", style: Theme.of(context).textTheme.headline1,),
          const SizedBox(height: 16,),
          Expanded(
            child: Consumer<UserStore>(
              builder: (context, userStore, child) {
                if (userStore.hasPermission(UserRoles.captain)) {
                  return ChallengesPlayerCaptainList();
                }

                return ChallengesPlayerList();
              },
            ),
          ),
          Button(
            onPressed: () {
              onSelectedTab(TabItem.challengesTeam);
            },
            text: "Défis d'équipe",
          )
        ],
      ),
    );
  }
}