import 'package:appli_wei_custom/models/team.dart';
import 'package:appli_wei_custom/services/team_service.dart';
import 'package:appli_wei_custom/src/pages/teams_ranking_page/widgets/team_ranking_card.dart';
import 'package:appli_wei_custom/src/providers/user_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TeamsRanking extends StatefulWidget {
  @override
  _TeamsRankingState createState() => _TeamsRankingState();
}

class _TeamsRankingState extends State<TeamsRanking> {
  Future<List<Team>> _ranking;
  
  @override
  void initState() {
    super.initState();

    final UserStore userStore = Provider.of<UserStore>(context, listen: false);
    _ranking = TeamService.instance.getRanking(userStore.authentificationHeader);
  }
  
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _getData,
      child: FutureBuilder(
        future: _ranking,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (!snapshot.hasData) {
              return const Center(child: Text("Impossible d'obtenir le classement"),);
            }

            if (snapshot.hasError) {
              return Center(child: Text("Erreur : ${snapshot.error.toString()}",));
            }

            final List<Team> teams = snapshot.data as List<Team>;

            if (teams.isEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Image(
                    image: AssetImage("assets/image/logo.png"),
                    height: 96.0,
                    width: 96.0,
                  ),
                  SizedBox(height: 8.0,),
                  Text("Le classement des équipe est caché pour le moment.")
                ],
              );
            }

            return _buildList(teams);
          }

          return const Center(child: CircularProgressIndicator(),);
        },
      ),
    );
  }

  Widget _buildList(List<Team> teams) {
    return ListView.builder(
      itemCount: teams.length,
      itemBuilder: (context, index) {
        return TeamRankingCard(team: teams[index], position: index + 1);
      },
    );
  }

  Future _getData() async {
    setState(() {
      final UserStore userStore = Provider.of<UserStore>(context, listen: false);
      _ranking = TeamService.instance.getRanking(userStore.authentificationHeader);
    });
  }
}