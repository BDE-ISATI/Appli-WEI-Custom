import 'package:appli_wei_custom/models/challenge.dart';
import 'package:appli_wei_custom/src/shared/widgets/wei_card.dart';
import 'package:flutter/material.dart';

class ChallengeTitle extends StatelessWidget {
  const ChallengeTitle({Key key, @required this.challenge}) : super(key: key);

  final Challenge challenge;

  @override
  Widget build(BuildContext context) {
    return WeiCard(
      height: 150,
      margin: const EdgeInsets.all(0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("${challenge.name} (${challenge.value} points)", style: Theme.of(context).textTheme.headline2,),
          const SizedBox(height: 16,),

          if (challenge.numberLeft == 0) ...{
            Text("Défi terminé.", style: Theme.of(context).textTheme.headline3,)
          }
          else ...{
            Text("Nombre de répétition restantes : ${challenge.numberLeft}", style: Theme.of(context).textTheme.headline3,),
            if (!challenge.isForTeam)
              Text("Status : ${challenge.isWaitingValidation ? "en cours de validation" : "à faire" }", style: Theme.of(context).textTheme.headline4,)
          }

        ],
      ),
    );
  }
}