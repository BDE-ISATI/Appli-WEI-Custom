import 'dart:convert';

import 'package:appli_wei_custom/models/challenge.dart';
import 'package:appli_wei_custom/src/pages/challenge_details/widgets/challenge_title.dart';
import 'package:appli_wei_custom/src/shared/widgets/button.dart';
import 'package:appli_wei_custom/src/shared/widgets/top_navigation_bar.dart';
import 'package:flutter/material.dart';

class ChallengeDetailsPage extends StatefulWidget {
  const ChallengeDetailsPage({Key key, @required this.challenge}) : super(key: key);
  
  final Challenge challenge;

  @override 
  _ChallengeDetailsPageState createState() => _ChallengeDetailsPageState();
}

class _ChallengeDetailsPageState extends State<ChallengeDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // First we add main widgets
          Positioned.fill(
            child: Column(
              children: [
                Expanded(
                  child: Hero(
                    tag: "challenge_image",
                    child: Image.memory(
                      base64Decode(widget.challenge.imageBase64),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 114, left: 32, right: 32, bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Text(widget.challenge.description),
                        ),
                        Button(
                          onPressed: (widget.challenge.isWaitingValidation) ? null : () {

                          },
                          text: "Valider le défis",
                        )
                      ],
                    ),
                  ),
                )
              ],
            ) 
          ),
          TopNavigationBar(),
          // The middle
          Align(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: ChallengeTitle(challenge: widget.challenge,),
            ),
          )
        ],
      ),
    );
  }

}