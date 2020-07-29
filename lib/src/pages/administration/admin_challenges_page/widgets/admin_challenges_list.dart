import 'package:appli_wei_custom/models/administration/admin_challenge.dart';
import 'package:appli_wei_custom/src/pages/administration/admin_challenges_page/widgets/admin_challenges_filtered_list.dart';
import 'package:appli_wei_custom/src/providers/admin_challenges_store.dart';
import 'package:flutter/material.dart';
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

                return AdminChallengesFilteredList(challenges: individualChallenges + teamChallenges,);
              }

              return const Center(child: CircularProgressIndicator(),);
            },
          ),
        );
      },
    );
  }

  Future _getData(BuildContext context) async {
    final AdminChallengesStore challengesStore = Provider.of<AdminChallengesStore>(context, listen: false);
    challengesStore.refreshData();
  }
}