import 'package:appli_wei_custom/models/user.dart';
import 'package:appli_wei_custom/src/pages/administration/admin_users_page/widgets/admin_users_filtered_list.dart';
import 'package:appli_wei_custom/src/providers/admin_users_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminUsersList extends StatelessWidget {
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

                return AdminUsersFilteredList(users: users,);
              }

              return const Center(child: CircularProgressIndicator(),);
            },
          ),
        );
      },
    );
  }

  Future _getData(BuildContext context) async {
    final AdminUsersStore usersStore = Provider.of<AdminUsersStore>(context, listen: false);
    usersStore.refreshData();
  }
}