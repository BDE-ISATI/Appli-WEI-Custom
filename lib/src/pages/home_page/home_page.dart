import 'package:appli_wei_custom/src/pages/home_page/widgets/user_score.dart';
import 'package:appli_wei_custom/src/pages/home_page/widgets/welcome.dart';
import 'package:appli_wei_custom/src/pages/main_page/widgets/menu_drawer.dart';
import 'package:appli_wei_custom/src/shared/widgets/button.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key, @required this.onSelectedTab}) : super(key: key);
  
  final ValueChanged<TabItem> onSelectedTab;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Welcome(),
        Expanded(
          child: UserScore(),
        ),
        const Expanded(
          child: Text("Bientôt les défis réalisés"),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Button(
            onPressed: () {
              onSelectedTab(TabItem.challengesPlayer);
            },
            text: "Tous les défis",
          ),
        )
      ],
    );
  }
}