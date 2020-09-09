import 'package:appli_wei_custom/models/team.dart';
import 'package:appli_wei_custom/src/pages/team_details_page/team_users_page/widgets/team_users.dart';
import 'package:appli_wei_custom/src/shared/widgets/top_navigation_bar.dart';
import 'package:flutter/material.dart';

class TeamUsersPage extends StatelessWidget {
  const TeamUsersPage({Key key, @required this.team}) : super(key: key);

  final Team team;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child:  Padding(
              padding: const EdgeInsets.only(top: 102.0, left: 8, right: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text("Membres de l'équipe ${team.name}", style: Theme.of(context).textTheme.headline1,),
                  const SizedBox(height: 16,),
                  Expanded(
                    child: TeamUsers(team: team,),
                  ),
                ],
              ),
            ),
          ),
          TopNavigationBar()
        ],
      ),
    );
  }
}