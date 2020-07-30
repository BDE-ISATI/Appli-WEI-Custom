import 'package:appli_wei_custom/models/challenge.dart';
import 'package:appli_wei_custom/models/team.dart';
import 'package:appli_wei_custom/services/challenge_service.dart';
import 'package:appli_wei_custom/src/providers/user_store.dart';
import 'package:appli_wei_custom/src/shared/widgets/challenge_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TeamChallengesList extends StatelessWidget {
  const TeamChallengesList({Key key, @required this.team}) : super(key: key);

  final Team team;

  @override
  Widget build(BuildContext context) {
    return Consumer<UserStore>(
      builder: (context, userStore, child) {
        return FutureBuilder(
          future: ChallengeService.instance.getDoneChallengesForTeam(userStore.authentificationHeader, team.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (!snapshot.hasData) {
                return const Center(child: Text("Impossible de récupérer les défis"),);
              }

              if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()),);
              }

              final List<Challenge> challenges = snapshot.data as List<Challenge>;

              return buildList(context, challenges);
            }


            return const Center(child: CircularProgressIndicator(),);
          },
        );
      },
    );
  }

  Widget buildList(BuildContext context, List<Challenge> challenges) {
    if (challenges.isEmpty) {
      return const Center(child: Text("Aucun challenge n'a été fini pour le moment"),);
    }

    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: challenges.length,
      itemBuilder: (context, index) {
        return SizedBox(
          width: 200,
          child: ChallengeCard(challenge: challenges[index],)
        );
      },
    );
  }
}