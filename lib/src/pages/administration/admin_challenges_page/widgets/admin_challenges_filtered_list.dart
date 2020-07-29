import 'package:appli_wei_custom/models/administration/admin_challenge.dart';
import 'package:appli_wei_custom/src/pages/administration/admin_challenges_page/widgets/admin_challenge_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class AdminChallengesFilteredList extends StatefulWidget {
  const AdminChallengesFilteredList({Key key, @required this.challenges}) : super(key: key);

  final List<AdminChallenge> challenges;

  @override 
  _AdminChallengesFilteredListState createState() => _AdminChallengesFilteredListState();
}

class _AdminChallengesFilteredListState extends State<AdminChallengesFilteredList> {
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
    final List<AdminChallenge> _showedChallenged = [];

    for (final challenge in widget.challenges) {
      if (_filter == null ||
          _filter == "" ||
          challenge.name.toLowerCase().contains(_filter.toLowerCase())) {

        _showedChallenged.add(challenge);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: TextField(
            decoration: const InputDecoration(
              labelText: "Chercher un défis",
            ),
            controller: _controller,
          ),
        ),
        const SizedBox(height: 8.0,),
        Expanded(
          child: StaggeredGridView.countBuilder(
            crossAxisCount: 4,
            itemCount: _showedChallenged.length,
            itemBuilder: (context, index) {
              return AdminChallengeCard(challenge: _showedChallenged[index],);
            },
            staggeredTileBuilder: (index) {
              return StaggeredTile.extent(2, index.isEven ? 272 : 300);
            },
          ),
        )
      ],
    );
  }
}