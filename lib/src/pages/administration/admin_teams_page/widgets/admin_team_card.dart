import 'package:appli_wei_custom/models/team.dart';
import 'package:appli_wei_custom/src/pages/administration/admin_team_edit_page/admin_team_edit_page.dart';
import 'package:appli_wei_custom/src/providers/admin_teams_store.dart';
import 'package:appli_wei_custom/src/shared/widgets/team_image.dart';
import 'package:appli_wei_custom/src/shared/widgets/wei_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminTeamCard extends StatelessWidget {
  const AdminTeamCard({Key key, @required this.team}) : super(key: key);

  final Team team;

  @override
  Widget build(BuildContext context) {
    return WeiCard(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      margin: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8.0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(32.0),
            child: Hero(
              tag: team.id,
              child: TeamImage(team: team, height: 64, width: 64, boxFit: BoxFit.cover,)
            )
          ),
          const SizedBox(width: 8.0,),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(team.name, style: Theme.of(context).textTheme.headline2,),
                Text("Capitaine : ${team.captainName}", style: Theme.of(context).textTheme.headline4)
              ],
            ),
          ),
          const SizedBox(width: 8.0),
          SizedBox(
            height: 48,
            width: 48,
            child: ClipOval(
              child: Material(
                color: Theme.of(context).accentColor, // button color
                child: InkWell(
                  splashColor: Colors.red,
                  onTap: () async { 
                    final AdminTeamsStore adminTeamsStore = Provider.of<AdminTeamsStore>(context, listen: false);

                    adminTeamsStore.deleteTeam(team);
                  },
                  child: const SizedBox(width: 32, height: 32, child: Icon(Icons.delete, color: Colors.white,)),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          SizedBox(
            height: 48,
            width: 48,
            child: ClipOval(
              child: Material(
                color: Theme.of(context).accentColor, // button color
                child: InkWell(
                  splashColor: Colors.red,
                  onTap: () async {
                    final AdminTeamsStore adminTeamsStore = Provider.of<AdminTeamsStore>(context, listen: false);

                    await Navigator.push<void>(
                      context,
                      MaterialPageRoute(builder: (context) => ChangeNotifierProvider.value(
                        value: adminTeamsStore,
                        child: AdminTeamEditPage(team: team, heroTag: team.id,),
                      ))
                    );
                  },
                  child: const SizedBox(width: 32, height: 32, child: Icon(Icons.edit, color: Colors.white,)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}