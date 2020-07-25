import 'package:appli_wei_custom/src/pages/challenges_player_page/challenges_player_page.dart';
import 'package:appli_wei_custom/src/pages/home_page/home_page.dart';
import 'package:appli_wei_custom/src/pages/main_page/widgets/menu_drawer.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  TabItem _currentTab = TabItem.home;

  final Map<TabItem, Widget> _pages = {};

  @override
  void initState() {
    super.initState();

    _pages.addAll(<TabItem, Widget>{
      TabItem.home: HomePage(onSelectedTab: _selectePage,),
      TabItem.challengesPlayer: ChallangesPlayerPage()
    });
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