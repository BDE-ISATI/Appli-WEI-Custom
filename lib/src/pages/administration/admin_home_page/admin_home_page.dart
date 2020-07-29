import 'package:appli_wei_custom/src/pages/administration/admin_challenges_page/admin_challenges_page.dart';
import 'package:appli_wei_custom/src/pages/administration/admin_users_page/admin_users_page.dart';
import 'package:appli_wei_custom/src/shared/widgets/button.dart';
import 'package:flutter/material.dart';

class AdminHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Button(
            onPressed: () {
              Navigator.of(context).push<void>(
                MaterialPageRoute(builder: (context) => AdminChallengesPage(),)
              );
            },
            text: "Les Défis",
          ),
          const SizedBox(height: 8.0),
          Button(
            onPressed: () {
              Navigator.of(context).push<void>(
                MaterialPageRoute(builder: (context) => AdminUsersPage(),)
              );
            },
            text: "Les Utilisateurs",
          )
        ],
      ),
    );
  }
}