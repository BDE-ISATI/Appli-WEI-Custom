import 'dart:convert';

import 'package:appli_wei_custom/models/challenge.dart';
import 'package:appli_wei_custom/services/challenge_service.dart';
import 'package:appli_wei_custom/src/providers/user_store.dart';
import 'package:appli_wei_custom/src/shared/widgets/wei_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChallengesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserStore>(
      builder: (context, userStore, child) {
        return FutureBuilder(
          future: ChallengeService.instance.doneChallengesForUser(userStore.authentificationHeader, userStore.id),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator(),);
            }

            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()),);
            }

            final List<Challenge> challenges = snapshot.data as List<Challenge>;

            return buildList(context, challenges);

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
        return WeiCard(
          padding: const EdgeInsets.all(0),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(32.0), topRight: Radius.circular(32.0)),
                child: Image.memory(
                  base64Decode(challenges[index].imageBase64),
                  height: 132,
                ),
              ),
              const SizedBox(height: 8.0,),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(challenges[index].name, style: Theme.of(context).textTheme.headline2,),
                )
              ),
              const SizedBox(height: 8.0,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipOval(
                  child: Material(
                    color: Theme.of(context).accentColor, // button color
                    child: InkWell(
                      splashColor: Colors.red,
                      onTap: () {},
                      child: const SizedBox(width: 48, height: 48, child: Icon(Icons.visibility, color: Colors.white,)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}