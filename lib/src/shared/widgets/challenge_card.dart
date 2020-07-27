import 'dart:convert';

import 'package:appli_wei_custom/models/challenge.dart';
import 'package:appli_wei_custom/src/pages/challenge_details/challenge_details_page.dart';
import 'package:appli_wei_custom/src/shared/widgets/wei_card.dart';
import 'package:flutter/material.dart';

class ChallengeCard extends StatelessWidget {
  const ChallengeCard({Key key, @required this.challenge}) : super(key: key);

  final Challenge challenge;
  
  @override
  Widget build(BuildContext context) {
    return WeiCard(
      padding: const EdgeInsets.all(0),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 6,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(32.0), topRight: Radius.circular(32.0)),
              child: Hero(
                tag: challenge.id,
                child: Image.memory(
                  base64Decode(challenge.imageBase64),
                  height: 132,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8.0,),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(challenge.name, style: Theme.of(context).textTheme.headline2,),
            )
          ),
          const SizedBox(height: 8.0,),
          SizedBox(
            height: 48,
            width: 48,
            child: ClipOval(
              child: Material(
                color: Theme.of(context).accentColor, // button color
                child: InkWell(
                  splashColor: Colors.red,
                  onTap: () async {
                    await Navigator.push<void>(
                      context,
                      MaterialPageRoute(builder: (context) => ChallengeDetailsPage(challenge: challenge, heroTag: challenge.id,))
                    );
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