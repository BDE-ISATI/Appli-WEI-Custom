import 'dart:convert';

import 'package:appli_wei_custom/models/waiting_challenges.dart';
import 'package:appli_wei_custom/src/pages/waiting_challenge_details_page/waiting_challenge_details_page.dart';
import 'package:appli_wei_custom/src/shared/widgets/wei_card.dart';
import 'package:flutter/material.dart';

class WaitingChallengeCard extends StatelessWidget {
  const WaitingChallengeCard({Key key, @required this.challenge, @required this.onValidated}) : super(key: key);

  final ValueChanged<bool> onValidated;

  final WaitingChallenge challenge;
  
  @override
  Widget build(BuildContext context) {
    return WeiCard(
      padding: const EdgeInsets.all(0),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 4,
            child: SizedBox(
              width: double.infinity,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(32.0), topRight: Radius.circular(32.0)),
                child: Hero(
                  tag: challenge.id + challenge.playerId,
                  child: Image.memory(
                    base64Decode(challenge.imageBase64),
                    height: 132,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8.0,),
          Expanded(
            // flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 4),
              child: Text(challenge.name, style: Theme.of(context).textTheme.headline2,),
            )
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 4, bottom: 8),
              child: Text(challenge.playerName, style: Theme.of(context).textTheme.headline3,),
            )
          ),
          SizedBox(
            height: 48,
            width: 48,
            child: ClipOval(
              child: Material(
                color: Theme.of(context).accentColor, // button color
                child: InkWell(
                  splashColor: Colors.red,
                  onTap: () async {
                    final bool validated = await Navigator.push<bool>(
                      context,
                      MaterialPageRoute(builder: (context) => WaitingChallengeDetailsPage(challenge: challenge, heroTag: challenge.id + challenge.playerId))
                    );

                    if (validated != null) {
                      onValidated(validated);
                    }
                  },
                  child: const SizedBox(width: 32, height: 32, child: Icon(Icons.visibility, color: Colors.white,)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8,)
        ],
      ),
    );  
  }
}