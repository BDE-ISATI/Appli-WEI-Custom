import 'package:appli_wei_custom/src/shared/widgets/button.dart';
import 'package:flutter/material.dart';

enum TabItem {
  home,
  challengesPlayer,
  challengesTeam,
  classmentPlayers,
  classmentTeams,
  profilSettings
}

Map<TabItem, int> tabIndex = {
  TabItem.home: 0,
  TabItem.challengesPlayer: 1,
  TabItem.challengesTeam: 2,
  TabItem.classmentPlayers: 3,
  TabItem.classmentTeams: 4,
  TabItem.profilSettings: 5
};

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({Key key, @required this.onSelectedTab, @required this.currentTab}) : super(key: key);

  final ValueChanged<TabItem> onSelectedTab;
  final TabItem currentTab;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          _buildDrawerHeader(context),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: _buildMenuItems(context),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: _buildBottomButtons(),
          )
        ],
      ),
    );
  }

  Column _buildBottomButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Button(
          onPressed: () {},
          text: "Modifier mon profil",
        ),
        Button(
          onPressed: () {},
          text: "Déconnexion",
        )
      ],
    );
  }

  ListView _buildMenuItems(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        ListTile(
          contentPadding: const EdgeInsets.all(0),
          dense: true,
          title: Text('ACCUEIL', style: Theme.of(context).textTheme.headline2.merge(TextStyle(color: _colorForItem(context, TabItem.home))),),
          onTap: () {
            onSelectedTab(TabItem.home);
            Navigator.of(context).pop();
          },
        ),
        ListTile(
          contentPadding: const EdgeInsets.all(0),
          dense: true,
          title: Text('Les défis', style: Theme.of(context).textTheme.headline3,),
        ),
        ListTile(
          contentPadding: const EdgeInsets.all(0),
          dense: true,
          title: Text('DEFIS INDIVIDUELS', style: Theme.of(context).textTheme.headline2.merge(TextStyle(color: _colorForItem(context, TabItem.challengesPlayer))),),
          onTap: () {
            onSelectedTab(TabItem.challengesPlayer);
            Navigator.of(context).pop();
          },
        ),
        ListTile(
          contentPadding: const EdgeInsets.all(0),
          dense: true,
          title: Text('DEFIS EQUIPES', style: Theme.of(context).textTheme.headline2.merge(TextStyle(color: _colorForItem(context, TabItem.challengesTeam))),),
          onTap: () {
            // Update the state of the app.
            // ...
          },
        ),
        const SizedBox(height: 25,),
        ListTile(
          contentPadding: const EdgeInsets.all(0),
          dense: true,
          title: Text('Les classements', style: Theme.of(context).textTheme.headline3,),
        ),
        ListTile(
          contentPadding: const EdgeInsets.all(0),
          dense: true,
          title: Text('CLASSEMENT JOUEURS', style: Theme.of(context).textTheme.headline2.merge(TextStyle(color: _colorForItem(context, TabItem.classmentPlayers))),),
          onTap: () {
            // Update the state of the app.
            // ...
          },
        ),
        ListTile(
          contentPadding: const EdgeInsets.all(0),
          dense: true,
          title: Text('CLASSEMENT EQUIPES', style: Theme.of(context).textTheme.headline2.merge(TextStyle(color: _colorForItem(context, TabItem.classmentTeams))),),
          onTap: () {
            // Update the state of the app.
            // ...
          },
        ),
      ],
    );
  }

  DrawerHeader _buildDrawerHeader(BuildContext context) {
    return DrawerHeader(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Row(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(64),
              child: const Image(
                image: AssetImage("assets/images/players.jpg"), 
                height: 92,
                width: 92,
                fit: BoxFit.fitHeight,
              ),
          ),
          const SizedBox(width: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Victor DENIS", style: Theme.of(context).textTheme.headline3,),
              const SizedBox(height: 4,),
              Text("Equipe Poke Argan", style: Theme.of(context).textTheme.headline4)
            ],
          )
        ],
      ),
    );
  }

  Color _colorForItem(BuildContext context, TabItem item) {
    if (tabIndex[currentTab] == tabIndex[item]) {
      return Theme.of(context).accentColor;
    }

    return Colors.black87;
  }

}