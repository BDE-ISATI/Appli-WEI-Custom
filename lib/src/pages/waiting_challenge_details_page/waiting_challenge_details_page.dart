import 'dart:convert';

import 'package:appli_wei_custom/models/waiting_challenges.dart';
import 'package:appli_wei_custom/services/challenge_service.dart';
import 'package:appli_wei_custom/src/pages/waiting_challenge_details_page/widgets/waiting_challenge_title.dart';
import 'package:appli_wei_custom/src/providers/user_store.dart';
import 'package:appli_wei_custom/src/shared/widgets/button.dart';
import 'package:appli_wei_custom/src/shared/widgets/top_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WaitingChallengeDetailsPage extends StatelessWidget {
  const WaitingChallengeDetailsPage({Key key, @required this.challenge, this.heroTag}) : super(key: key);
  
  final WaitingChallenge challenge;
  final String heroTag;

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
                    tag: heroTag,
                    child: Image.memory(
                      base64Decode(challenge.imageBase64),
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
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Text(challenge.description),
                                const SizedBox(height: 16.0,),
                                Consumer<UserStore>(
                                  builder: (context, userStore, child) {
                                    return FutureBuilder(
                                      future: ChallengeService.instance.proofImage(userStore.authentificationHeader, challenge.id, challenge.playerId),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState == ConnectionState.done) {
                                          if (!snapshot.hasData) {
                                            return const Center(child: Text("Il n'y a pas de preuve..."),);
                                          }

                                          if (snapshot.hasError) {
                                            return Center(child: Text("Erreur lors de la récupération de la preuve : ${snapshot.error.toString()}"),);
                                          }

                                          return ClipRRect(
                                            borderRadius: BorderRadius.circular(32.0),
                                            child: Image.memory(
                                              base64Decode(snapshot.data as String),
                                              fit: BoxFit.contain
                                            ),
                                          );
                                        }

                                        return const Center(child: CircularProgressIndicator(),);
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        Button(
                          onPressed: () {

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
              child: WaitingChallengeTitle(challenge: challenge,),
            ),
          )
        ],
      ),
    );
  }
}