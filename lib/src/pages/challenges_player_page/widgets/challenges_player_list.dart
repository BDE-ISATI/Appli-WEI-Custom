import 'package:appli_wei_custom/models/challenge.dart';
import 'package:appli_wei_custom/services/challenge_service.dart';
import 'package:appli_wei_custom/src/providers/user_store.dart';
import 'package:appli_wei_custom/src/shared/widgets/challenge_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class ChallengesPlayerList extends StatefulWidget {
  @override
  _ChallengesPlayerListState createState() => _ChallengesPlayerListState();
}

class _ChallengesPlayerListState extends State<ChallengesPlayerList> {
  Future<List<Challenge>> _challenges;
  
  @override
  void initState() {
    super.initState();

    final UserStore userStore = Provider.of<UserStore>(context, listen: false);
    _challenges = ChallengeService.instance.getChallengesForUser(userStore.authentificationHeader, userStore.id);
  }
  
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _getData,
      child: FutureBuilder(
        future: _challenges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (!snapshot.hasData) {
              return const Center(child: Text("Impossible d'obtenir les défis"),);
            }

            if (snapshot.hasError) {
              return Center(child: Text("Erreur : ${snapshot.error.toString()}",));
            }

            final List<Challenge> challenges = snapshot.data as List<Challenge>;

            return _buildGrid(context, challenges);
          }

          return const Center(child: CircularProgressIndicator(),);
        },
      ),
    );
  }

  Widget _buildGrid(BuildContext context, List<Challenge> challenges) {
    final List<StaggeredTile> staggeredTiles = [];
    final List<ChallengeCard> challengesCard = []; 

    for (int i = 0; i < challenges.length; ++i) {
      staggeredTiles.add(StaggeredTile.extent(2, i.isEven ? 272 : 300));
      challengesCard.add(ChallengeCard(challenge: challenges[i]));
    }

    return StaggeredGridView.count(
      crossAxisCount: 4,
      staggeredTiles: staggeredTiles,
      children: challengesCard,
    );
  }

  Future _getData() async {
    setState(() {
      final UserStore userStore = Provider.of<UserStore>(context, listen: false);
      _challenges = ChallengeService.instance.getChallengesForUser(userStore.authentificationHeader, userStore.id);
    });
  }
}