import 'package:appli_wei_custom/models/team.dart';
import 'package:appli_wei_custom/src/pages/administration/admin_teams_page/widgets/admin_team_card.dart';
import 'package:flutter/material.dart';

class AdminTeamsFilteredList extends StatefulWidget {
  const AdminTeamsFilteredList({Key key, @required this.teams}) : super(key: key);

  final List<Team> teams;

  @override 
  _AdminTeamsFilteredListState createState() => _AdminTeamsFilteredListState();
}

class _AdminTeamsFilteredListState extends State<AdminTeamsFilteredList> {
  final TextEditingController _controller = TextEditingController();
  String _filter;

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      setState(() {
        _filter = _controller.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: TextField(
            decoration: const InputDecoration(
              labelText: "Chercher une équipe",
            ),
            controller: _controller,
          ),
        ),
        const SizedBox(height: 8.0,),
        Expanded(
          child: ListView.builder(
            itemCount: widget.teams.length,
            itemBuilder: (context, index) {
              return Visibility(
                visible: 
                  _filter == null ||
                  _filter == "" ||
                widget.teams[index].name.toLowerCase().contains(_filter.toLowerCase()),
                child: AdminTeamCard(team: widget.teams[index],),
              );
            },
          ),
        )
      ],
    );
  }
}