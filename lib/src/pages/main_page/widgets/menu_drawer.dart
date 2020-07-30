import 'package:appli_wei_custom/models/user.dart';
import 'package:appli_wei_custom/services/authentication_serive.dart';
import 'package:appli_wei_custom/src/providers/user_store.dart';
import 'package:appli_wei_custom/src/shared/widgets/button.dart';
import 'package:appli_wei_custom/src/shared/widgets/user_profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum TabItem {
  home,
  challengesPlayer,
  challengesTeam,
  rankingPlayers,
  rankingTeams,
  profilSettings,
  administration,
}

Map<TabItem, int> tabIndex = {
  TabItem.home: 0,
  TabItem.challengesPlayer: 1,
  TabItem.challengesTeam: 2,
  TabItem.rankingPlayers: 3,
  TabItem.rankingTeams: 4,
  TabItem.profilSettings: 5,
  TabItem.administration: 6,
};

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({Key key, @required this.onSelectedTab, @required this.currentTab}) : super(key: key);

  final ValueChanged<TabItem> onSelectedTab;
  final TabItem currentTab;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Consumer<UserStore>(
        builder: (context, userStore, child) {
          return Column(
            children: [
              _buildDrawerHeader(context, userStore.fullName, userStore.teamName),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: _buildMenuItems(context),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: _buildBottomButtons(context),
              )
            ],
          );
        },
      )
    );
  }

  Column _buildBottomButtons(BuildContext context) {
    final UserStore userStore = Provider.of<UserStore>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Visibility(
          visible: userStore.hasPermission(UserRoles.administrator),
          child: Button(
            onPressed: () {
              onSelectedTab(TabItem.administration);
              Navigator.of(context).pop();
            },
            text: "Administration",
          ),
        ),
        Button(
          onPressed: () {
            onSelectedTab(TabItem.profilSettings);
            Navigator.of(context).pop();
          },
          text: "Modifier mon profil",
        ),
        Button(
          onPressed: () async {
            await AuthenticationService.instance.logoutUser();
            Provider.of<UserStore>(context, listen: false).logoutUser();
          },
          text: "Déconnexion",
        )
      ],
    );
  }

  ListView _buildMenuItems(BuildContext context) {
    final UserStore userStore = Provider.of<UserStore>(context);

    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        Visibility(
          visible: !userStore.hasPermission(UserRoles.captain) && !userStore.hasPermission(UserRoles.administrator),
          child: ListTile(
            contentPadding: const EdgeInsets.all(0),
            dense: true,
            title: Text('ACCUEIL', style: Theme.of(context).textTheme.headline2.merge(TextStyle(color: _colorForItem(context, TabItem.home))),),
            onTap: () {
              onSelectedTab(TabItem.home);
              Navigator.of(context).pop();
            },
          ),
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
            onSelectedTab(TabItem.challengesTeam);
            Navigator.of(context).pop();
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
          title: Text('CLASSEMENT JOUEURS', style: Theme.of(context).textTheme.headline2.merge(TextStyle(color: _colorForItem(context, TabItem.rankingPlayers))),),
          onTap: () {
            onSelectedTab(TabItem.rankingPlayers);
            Navigator.of(context).pop();
          },
        ),
        ListTile(
          contentPadding: const EdgeInsets.all(0),
          dense: true,
          title: Text('CLASSEMENT EQUIPES', style: Theme.of(context).textTheme.headline2.merge(TextStyle(color: _colorForItem(context, TabItem.rankingTeams))),),
          onTap: () {
            onSelectedTab(TabItem.rankingTeams);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  DrawerHeader _buildDrawerHeader(BuildContext context, String userName, String userTeam) {
    return DrawerHeader(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Row(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: const UserProfilePicture()
          ),
          const SizedBox(width: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userName, style: Theme.of(context).textTheme.headline3,),
              const SizedBox(height: 4,),
              Text("Equipe $userTeam", style: Theme.of(context).textTheme.headline4)
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