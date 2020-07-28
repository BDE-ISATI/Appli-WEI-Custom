import 'package:appli_wei_custom/models/administration/admin_challenge.dart';
import 'package:appli_wei_custom/src/pages/administration/admin_challenge_edit_page/admin_challenge_edit_page.dart';
import 'package:appli_wei_custom/src/pages/administration/admin_challenges_page/widgets/admin_challenges_list.dart';
import 'package:appli_wei_custom/src/providers/admin_challenges_store.dart';
import 'package:appli_wei_custom/src/providers/user_store.dart';
import 'package:appli_wei_custom/src/shared/widgets/button.dart';
import 'package:appli_wei_custom/src/shared/widgets/top_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminChallengesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserStore>(
      builder: (context, userStore, child) {
        return ChangeNotifierProvider(
          create: (context) => AdminChallengesStore(authorizationHeader: userStore.authentificationHeader),
          builder: (context, child) {
            return Scaffold(
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TopNavigationBar(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8.0),
                    child: Text("Les défis", style: Theme.of(context).textTheme.headline1,),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: AdminChallengesList(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                    child: Button(
                      onPressed: () async {
                        final AdminChallengesStore adminChallengesStore = Provider.of<AdminChallengesStore>(context, listen: false);

                        await Navigator.of(context).push<void>(
                          MaterialPageRoute(builder: (context) => AdminChallengeEditPage(challenge: AdminChallenge(), adminChallengesStore: adminChallengesStore, heroTag: "",))
                        );
                      },
                      text: "Ajouter un challenge",
                    ),
                  )
                ],
              ),
            );
          },
        );  
      },
    );
  }
}