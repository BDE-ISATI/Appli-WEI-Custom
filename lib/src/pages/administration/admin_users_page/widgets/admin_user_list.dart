import 'package:appli_wei_custom/models/user.dart';
import 'package:appli_wei_custom/src/pages/administration/admin_users_page/widgets/admin_user_card.dart';
import 'package:appli_wei_custom/src/providers/admin_users_store.dart';
import 'package:appli_wei_custom/src/providers/user_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminUserList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AdminUsersStore>(
      builder: (context, usersStore, child) {
        return RefreshIndicator(
          onRefresh: () => _getData(context),
          child: FutureBuilder(
            future: usersStore.getUsers(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (!snapshot.hasData) {
                  return const Center(child: Text("Impossible d'obtenir les utilisateurs"),);
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Erreur : ${snapshot.error.toString()}",));
                }

                final List<User> users = snapshot.data as List<User>;

                return _buildList(context, users);
              }

              return const Center(child: CircularProgressIndicator(),);
            },
          ),
        );
      },
    );
  }

  Widget _buildList(BuildContext context, List<User> users) {
    final List<AdminUserCard> userCards = []; 
    final UserStore userStore = Provider.of<UserStore>(context, listen: false);

    for (final user in users) {
      if (user.id == userStore.id) {
        continue;
      }

      userCards.add(AdminUserCard(user: user,));
    }

    return ListView(
      children: userCards,
    );
  }

  Future _getData(BuildContext context) async {
    final AdminUsersStore usersStore = Provider.of<AdminUsersStore>(context, listen: false);
    usersStore.refreshData();
  }
}