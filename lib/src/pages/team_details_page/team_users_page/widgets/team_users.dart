import 'package:appli_wei_custom/models/team.dart';
import 'package:appli_wei_custom/models/user.dart';
import 'package:appli_wei_custom/services/user_service.dart';
import 'package:appli_wei_custom/src/pages/team_details_page/team_users_page/widgets/team_user_card.dart';
import 'package:appli_wei_custom/src/providers/user_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TeamUsers extends StatefulWidget {
  const TeamUsers({Key key, @required this.team}) : super(key: key);
  
  final Team team;

  @override
  _TeamUsersState createState() => _TeamUsersState();
}

class _TeamUsersState extends State<TeamUsers> {
  Future<List<User>> _users;
  
  @override
  void initState() {
    super.initState();

    _users = _getUsers();
  }
  
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _getData,
      child: FutureBuilder(
        future: _users,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (!snapshot.hasData) {
              return const Center(child: Text("Impossible d'obtenir le classement"),);
            }

            if (snapshot.hasError) {
              return Center(child: Text("Erreur : ${snapshot.error.toString()}",));
            }

            final List<User> users = snapshot.data as List<User>;

            if (users.isEmpty) {
              return Stack(
                children: [
                  ListView(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Image(
                        image: AssetImage("assets/images/logo.png"),
                        height: 96.0,
                        width: 96.0,
                      ),
                      SizedBox(height: 8.0,),
                      Text("Cette équipe n'a pas encore de membres.")
                    ],
                  ),
                ],
              );
            }

            return _buildList(users);
          }

          return const Center(child: CircularProgressIndicator(),);
        },
      ),
    );
  }

  Widget _buildList(List<User> users) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        return TeamUserCard(user: users[index], team: widget.team);
      },
    );
  }

  Future _getData() async {
    setState(() {
      _users = _getUsers();
    });
  }

  Future<List<User>> _getUsers() async {
    final List<User> users = [];
    final UserStore userStore = Provider.of<UserStore>(context, listen: false);

    for (final user in widget.team.members) {
      users.add(await UserService.instance.getUser(userStore.authentificationHeader, user));
    }

    return users;
  }
}