import 'package:appli_wei_custom/models/team.dart';
import 'package:appli_wei_custom/src/pages/challenge_details_page/widgets/challenge_title.dart';
import 'package:appli_wei_custom/src/pages/team_details_page/widgets/team_challenges_list.dart';
import 'package:appli_wei_custom/src/pages/team_details_page/widgets/team_title.dart';
import 'package:appli_wei_custom/src/shared/widgets/challenge_images/challenge_image.dart';
import 'package:appli_wei_custom/src/shared/widgets/team_image.dart';
import 'package:appli_wei_custom/src/shared/widgets/top_navigation_bar.dart';
import 'package:flutter/material.dart';

class TeamDetailsPage extends StatelessWidget {
  const TeamDetailsPage({Key key, @required this.team, this.heroTag}) : super(key: key);
  
  final Team team;
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
                    child: SizedBox(
                      width: double.infinity,
                      child: TeamImage(
                        team: team,
                        boxFit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 96.0, bottom: 8.0, left: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text("Défis réalisés", style: Theme.of(context).textTheme.headline2,),
                        const SizedBox(height: 8.0),
                        Expanded(
                          child: TeamChallengesList(team: team,)
                        ),
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
              child: TeamTitle(team: team,),
            ),
          )
        ],
      ),
    );
  }
}