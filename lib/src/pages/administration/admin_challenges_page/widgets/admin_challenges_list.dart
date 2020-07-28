import 'package:appli_wei_custom/models/administration/admin_challenge.dart';
import 'package:appli_wei_custom/src/pages/administration/admin_challenges_page/widgets/admin_challenge_card.dart';
import 'package:appli_wei_custom/src/providers/admin_challenges_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class AdminChallengesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AdminChallengesStore>(
      builder: (context, challengesStore, child) {
        return RefreshIndicator(
          onRefresh: () => _getData(context),
          child: FutureBuilder(
            future: challengesStore.getChallenges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (!snapshot.hasData) {
                  return const Center(child: Text("Impossible d'obtenir les défis"),);
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Erreur : ${snapshot.error.toString()}",));
                }

                final List<AdminChallenge> challenges = snapshot.data as List<AdminChallenge>;

                final List<AdminChallenge> individualChallenges = [];
                final List<AdminChallenge> teamChallenges = [];

                for (final challenge in challenges) {
                  if (challenge.isForTeam) {
                    teamChallenges.add(challenge);
                  }  
                  else {
                    individualChallenges.add(challenge);
                  }
                }

                return _buildGrid(context, individualChallenges + teamChallenges);
              }

              return const Center(child: CircularProgressIndicator(),);
            },
          ),
        );
      },
    );
  }

  Widget _buildGrid(BuildContext context, List<AdminChallenge> challenges) {
    final List<StaggeredTile> staggeredTiles = [];
    final List<AdminChallengeCard> challengesCard = []; 

    for (int i = 0; i < challenges.length; ++i) {
      staggeredTiles.add(StaggeredTile.extent(2, i.isEven ? 272 : 300));
      challengesCard.add(AdminChallengeCard(challenge: challenges[i],));
    }

    return StaggeredGridView.count(
      crossAxisCount: 4,
      staggeredTiles: staggeredTiles,
      children: challengesCard,
    );
  }

  Future _getData(BuildContext context) async {
    final AdminChallengesStore challengesStore = Provider.of<AdminChallengesStore>(context, listen: false);
    challengesStore.refreshData();
  }
}