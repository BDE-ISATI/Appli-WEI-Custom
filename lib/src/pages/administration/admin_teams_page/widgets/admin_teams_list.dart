import 'package:appli_wei_custom/models/team.dart';
import 'package:appli_wei_custom/src/pages/administration/admin_teams_page/widgets/admin_teams_filtered_list.dart';
import 'package:appli_wei_custom/src/providers/admin_teams_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminTeamsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AdminTeamsStore>(
      builder: (context, teamsStore, child) {
        return RefreshIndicator(
          onRefresh: () => _getData(context),
          child: FutureBuilder(
            future: teamsStore.getTeams(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (!snapshot.hasData) {
                  return const Center(child: Text("Impossible d'obtenir les équipes"),);
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Erreur : ${snapshot.error.toString()}",));
                }

                final List<Team> teams = snapshot.data as List<Team>;

                return AdminTeamsFilteredList(teams: teams,);
              }

              return const Center(child: CircularProgressIndicator(),);
            },
          ),
        );
      },
    );
  }

  Future _getData(BuildContext context) async {
    final AdminTeamsStore teamsStore = Provider.of<AdminTeamsStore>(context, listen: false);
    teamsStore.refreshData();
  }
}