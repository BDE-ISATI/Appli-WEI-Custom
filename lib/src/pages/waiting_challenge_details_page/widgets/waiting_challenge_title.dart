import 'package:appli_wei_custom/models/waiting_challenges.dart';
import 'package:appli_wei_custom/src/shared/widgets/wei_card.dart';
import 'package:flutter/material.dart';

class WaitingChallengeTitle extends StatelessWidget {
  const WaitingChallengeTitle({Key key, @required this.challenge}) : super(key: key);

  final WaitingChallenge challenge;

  @override
  Widget build(BuildContext context) {
    return WeiCard(
      height: 150,
      margin: const EdgeInsets.all(0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(challenge.name, style: Theme.of(context).textTheme.headline2,),
          const SizedBox(height: 16,),
          Text("Joueur : ${challenge.playerName}", style: Theme.of(context).textTheme.headline3,),
        ],
      ),
    );
  }
}