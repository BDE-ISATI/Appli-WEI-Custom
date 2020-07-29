import 'package:appli_wei_custom/models/administration/admin_challenge.dart';
import 'package:appli_wei_custom/src/pages/administration/admin_challenge_edit_page/admin_challenge_edit_page.dart';
import 'package:appli_wei_custom/src/providers/admin_challenges_store.dart';
import 'package:appli_wei_custom/src/shared/widgets/challenge_images/admin_challenge_image.dart';
import 'package:appli_wei_custom/src/shared/widgets/wei_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminChallengeCard extends StatelessWidget {
  const AdminChallengeCard({Key key, @required this.challenge}) : super(key: key);

  final AdminChallenge challenge;
  
  @override
  Widget build(BuildContext context) {
    return WeiCard(
      padding: const EdgeInsets.all(0),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 5,
            child: SizedBox(
              width: double.infinity,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(32.0), topRight: Radius.circular(32.0)),
                child: Hero(
                  tag: challenge.id,
                  child: AdminChallengeImage(
                    challenge: challenge,
                    boxFit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 4, top: 8),
              child: Text(challenge.name, style: Theme.of(context).textTheme.headline2,),
            )
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 4, bottom: 8),
              child: Text(challenge.isForTeam ? "Pour équipe" : "Individuel", style: Theme.of(context).textTheme.headline3,),
            )
          ),
          Wrap(
            children: [
              SizedBox(
                height: 48,
                width: 48,
                child: ClipOval(
                  child: Material(
                    color: Theme.of(context).accentColor, // button color
                    child: InkWell(
                      splashColor: Colors.red,
                      onTap: () async {
                        final AdminChallengesStore challengesStore = Provider.of<AdminChallengesStore>(context, listen: false);

                        challengesStore.deleteChallenge(challenge);
                      },
                      child: const SizedBox(width: 32, height: 32, child: Icon(Icons.delete, color: Colors.white,)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8.0,),
              SizedBox(
                height: 48,
                width: 48,
                child: ClipOval(
                  child: Material(
                    color: Theme.of(context).accentColor, // button color
                    child: InkWell(
                      splashColor: Colors.red,
                      onTap: () async {
                        final AdminChallengesStore adminChallengesStore = Provider.of<AdminChallengesStore>(context, listen: false);

                        await Navigator.push<void>(
                          context,
                          MaterialPageRoute(builder: (context) => ChangeNotifierProvider.value(
                            value: adminChallengesStore,
                            child: AdminChallengeEditPage(challenge: challenge, heroTag: challenge.id,),
                          ))
                        );
                      },
                      child: const SizedBox(width: 32, height: 32, child: Icon(Icons.edit, color: Colors.white,)),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8,)
        ],
      ),
    );  
  }
}