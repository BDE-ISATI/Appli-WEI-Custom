import 'package:appli_wei_custom/models/user.dart';
import 'package:appli_wei_custom/src/pages/user_profile_page/widgets/user_challenges_list.dart';
import 'package:appli_wei_custom/src/pages/user_profile_page/widgets/user_title.dart';
import 'package:appli_wei_custom/src/pages/user_profile_page/widgets/user_user_score.dart';
import 'package:appli_wei_custom/src/shared/widgets/top_navigation_bar.dart';
import 'package:flutter/material.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({Key key, @required this.user}) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.only(top: 102, left: 8, right: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  UserTitle(user: user,),
                  Expanded(
                    child: UserUserScore(user: user,),
                  ),
                  SizedBox(
                    height: 272,
                    child: UserChallengesList(user: user,),
                  ),
                ],
              ),
            ),
          ),
          TopNavigationBar()
        ],
      )
    );
  }
}