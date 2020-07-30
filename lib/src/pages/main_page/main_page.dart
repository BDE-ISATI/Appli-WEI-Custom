import 'package:appli_wei_custom/models/user.dart';
import 'package:appli_wei_custom/src/pages/administration/admin_home_page/admin_home_page.dart';
import 'package:appli_wei_custom/src/pages/challenges_player_page/challenges_player_page.dart';
import 'package:appli_wei_custom/src/pages/challenges_team_page/challenges_team_page.dart';
import 'package:appli_wei_custom/src/pages/home_page/home_page.dart';
import 'package:appli_wei_custom/src/pages/main_page/widgets/menu_drawer.dart';
import 'package:appli_wei_custom/src/pages/modify_profile_page/modify_profile_page.dart';
import 'package:appli_wei_custom/src/pages/users_ranking_page/users_ranking_page.dart';
import 'package:appli_wei_custom/src/providers/user_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  TabItem _currentTab;

  final Map<TabItem, Widget> _pages = {};

  @override
  void initState() {
    super.initState();

    _pages.addAll(<TabItem, Widget>{
      TabItem.home: HomePage(onSelectedTab: _selectePage,),
      TabItem.challengesPlayer: ChallengesPlayerPage(onSelectedTab: _selectePage,),
      TabItem.challengesTeam: ChallengesTeamPage(onSelectedTab: _selectePage,),
      TabItem.rankingPlayers: UsersRankingPage(onSelectedTab: _selectePage,),
      TabItem.profilSettings: ModifyProfilePage(),
      TabItem.administration: AdminHomePage(),
    });

    final UserStore userStore = Provider.of<UserStore>(context, listen: false);

    if (userStore.hasPermission(UserRoles.captain)) {
      _currentTab = TabItem.challengesPlayer;
    }
    else {
      _currentTab = TabItem.home;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: MenuDrawer(
        onSelectedTab: _selectePage,
        currentTab: _currentTab,
      ),
      body: _pages[_currentTab],
    );
  }

  void _selectePage(TabItem item) {
    setState(() {
      _currentTab = item;
    });
  } 
}