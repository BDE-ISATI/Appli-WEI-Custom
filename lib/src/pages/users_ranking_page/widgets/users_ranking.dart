import 'package:appli_wei_custom/models/user.dart';
import 'package:appli_wei_custom/services/user_service.dart';
import 'package:appli_wei_custom/src/pages/users_ranking_page/widgets/user_ranking_card.dart';
import 'package:appli_wei_custom/src/providers/user_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsersRanking extends StatefulWidget {
  @override
  _UsersRankingState createState() => _UsersRankingState();
}

class _UsersRankingState extends State<UsersRanking> {
  Future<List<User>> _ranking;
  
  @override
  void initState() {
    super.initState();

    final UserStore userStore = Provider.of<UserStore>(context, listen: false);
    _ranking = UserService.instance.getRanking(userStore.authentificationHeader);
  }
  
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _getData,
      child: FutureBuilder(
        future: _ranking,
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
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Image(
                    image: AssetImage("assets/image/logo.png"),
                    height: 96.0,
                    width: 96.0,
                  ),
                  SizedBox(height: 8.0,),
                  Text("Le classement des joueurs est caché pour le moment.")
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
        return UserRankingCard(user: users[index], position: index + 1);
      },
    );
  }

  Future _getData() async {
    setState(() {
      final UserStore userStore = Provider.of<UserStore>(context, listen: false);
      _ranking = UserService.instance.getRanking(userStore.authentificationHeader);
    });
  }
}