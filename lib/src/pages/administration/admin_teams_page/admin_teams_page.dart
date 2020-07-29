import 'package:appli_wei_custom/models/team.dart';
import 'package:appli_wei_custom/src/pages/administration/admin_team_edit_page/admin_team_edit_page.dart';
import 'package:appli_wei_custom/src/pages/administration/admin_teams_page/widgets/admin_teams_list.dart';
import 'package:appli_wei_custom/src/providers/admin_teams_store.dart';
import 'package:appli_wei_custom/src/providers/user_store.dart';
import 'package:appli_wei_custom/src/shared/widgets/button.dart';
import 'package:appli_wei_custom/src/shared/widgets/top_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminTeamsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserStore>(
      builder: (context, userStore, child) {
        return ChangeNotifierProvider(
          create: (context) => AdminTeamsStore(authorizationHeader: userStore.authentificationHeader),
          builder: (context, child) {
            return Scaffold(
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TopNavigationBar(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8.0),
                    child: Text("Les équipes", style: Theme.of(context).textTheme.headline1,),
                  ),
                  Expanded(
                    child: AdminTeamsList(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                    child: Button(
                      onPressed: () async {
                        final AdminTeamsStore adminTeamsStore = Provider.of<AdminTeamsStore>(context, listen: false);
                        
                        await Navigator.of(context).push<void>(
                          MaterialPageRoute(builder: (context) => ChangeNotifierProvider.value(
                            value: adminTeamsStore,
                            child: AdminTeamEditPage(team: Team(), heroTag: "",),
                          ))
                        );
                      },
                      text: "Ajouter une équipe",
                    ),
                  )
                ],
              ),
            );
          },
        );  
      },
    );
  }
}