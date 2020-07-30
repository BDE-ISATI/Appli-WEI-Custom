import 'package:appli_wei_custom/models/challenge.dart';
import 'package:appli_wei_custom/src/pages/challenge_details_page/challenge_details_page.dart';
import 'package:appli_wei_custom/src/shared/widgets/challenge_images/challenge_image.dart';
import 'package:appli_wei_custom/src/shared/widgets/wei_card.dart';
import 'package:flutter/material.dart';

class ChallengeCard extends StatelessWidget {
  const ChallengeCard({Key key, @required this.challenge, this.onValidated, this.showButtons = true}) : super(key: key);

  final ValueChanged<bool> onValidated;

  final Challenge challenge;
  final bool showButtons;

  @override
  Widget build(BuildContext context) {
    return WeiCard(
      padding: const EdgeInsets.all(0),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 6,
            child: SizedBox(
              width: double.infinity,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(32.0), topRight: Radius.circular(32.0)),
                child: Hero(
                  tag: challenge.id,
                  child: ChallengeImage(
                    challenge: challenge,
                    height: 132,
                    boxFit: BoxFit.cover,
                  )
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(challenge.name, style: Theme.of(context).textTheme.headline2,),
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
                      MaterialPageRoute(builder: (context) => ChallengeDetailsPage(challenge: challenge, heroTag: challenge.id, showButtons: showButtons,))
                    );

                    if (validated != null && onValidated != null) {
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