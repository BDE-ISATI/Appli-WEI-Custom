import 'package:appli_wei_custom/src/pages/administration/admin_users_page/widgets/admin_users_list.dart';
import 'package:appli_wei_custom/src/providers/admin_users_store.dart';
import 'package:appli_wei_custom/src/providers/user_store.dart';
import 'package:appli_wei_custom/src/shared/widgets/top_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminUsersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserStore>(
      builder: (context, userStore, child) {
        return ChangeNotifierProvider(
          create: (context) => AdminUsersStore(authorizationHeader: userStore.authentificationHeader),
          builder: (context, child) {
            return Scaffold(
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TopNavigationBar(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8.0),
                    child: Text("Les utilisateurs", style: Theme.of(context).textTheme.headline1,),
                  ),
                  Expanded(
                    child: AdminUsersList(),
                  ),
                ],
              ),
            );
          },
        );  
      },
    );
  }
}