import 'package:appli_wei_custom/models/waiting_challenges.dart';
import 'package:appli_wei_custom/services/challenge_service.dart';
import 'package:appli_wei_custom/src/pages/challenges_player_page/widgets/waiting_challenge_card.dart';
import 'package:appli_wei_custom/src/providers/user_store.dart';
import 'package:appli_wei_custom/src/shared/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class ChallengesPlayerCaptainList extends StatefulWidget {
  @override
  _ChallengesPlayerCaptainListState createState() => _ChallengesPlayerCaptainListState();
}

class _ChallengesPlayerCaptainListState extends State<ChallengesPlayerCaptainList> {
  Future<List<WaitingChallenge>> _waitingChallenges;

  @override
  void initState() {
    super.initState();

    final UserStore userStore = Provider.of<UserStore>(context, listen: false);
    _waitingChallenges = ChallengeService.instance.getWaitingChallenges(userStore.authentificationHeader);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _getData,
      child: FutureBuilder(
        future: _waitingChallenges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (!snapshot.hasData) {
              return const Center(child: Text("Impossible d'obtenir les défis"),);
            }

            if (snapshot.hasError) {
              return Center(child: Text("Erreur : ${snapshot.error.toString()}",));
            }

            final List<WaitingChallenge> challenges = snapshot.data as List<WaitingChallenge>;

            return _buildGrid(context, challenges);
          }

          return const Center(child: CircularProgressIndicator(),);
        },
      ),
    );
  }

  Widget _buildGrid(BuildContext context, List<WaitingChallenge> challenges) {
    final List<StaggeredTile> staggeredTiles = [];
    final List<WaitingChallengeCard> challengesCard = []; 

    for (int i = 0; i < challenges.length; ++i) {
      staggeredTiles.add(StaggeredTile.count(1, i.isEven ? 1.5 : 1.8));
      challengesCard.add(WaitingChallengeCard(challenge: challenges[i], onValidated: _challengeValidate,));
    }

    return StaggeredGridView.count(
      crossAxisCount: responsiveCrossAxisCount(context),
      staggeredTiles: staggeredTiles,
      children: challengesCard,
    );
  }

  Future _getData() async {
    setState(() {
      final UserStore userStore = Provider.of<UserStore>(context, listen: false);
    _waitingChallenges = ChallengeService.instance.getWaitingChallenges(userStore.authentificationHeader);
    });
  }

  void _challengeValidate(bool isValidated) {
    if (isValidated) {
      _getData();
    }
  }
}