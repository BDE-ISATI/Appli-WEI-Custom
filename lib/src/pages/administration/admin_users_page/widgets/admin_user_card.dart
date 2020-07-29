import 'package:appli_wei_custom/models/user.dart';
import 'package:appli_wei_custom/src/pages/administration/admin_user_edit_page/admin_user_edit_page.dart';
import 'package:appli_wei_custom/src/providers/admin_users_store.dart';
import 'package:appli_wei_custom/src/shared/widgets/user_profile_picture.dart';
import 'package:appli_wei_custom/src/shared/widgets/wei_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminUserCard extends StatelessWidget {
  const AdminUserCard({Key key, @required this.user}) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return WeiCard(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      margin: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8.0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(32.0),
            child: UserProfilePicture(user: user,)
          ),
          const SizedBox(width: 8.0,),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("${user.firstName} ${user.lastName}", style: Theme.of(context).textTheme.headline2,),
                Text("Role : ${user.role}", style: Theme.of(context).textTheme.headline3,),
                Text("Equipe ${user.teamName}", style: Theme.of(context).textTheme.headline4)
              ],
            ),
          ),
          const SizedBox(width: 8.0),
          SizedBox(
            height: 48,
            width: 48,
            child: ClipOval(
              child: Material(
                color: Theme.of(context).accentColor, // button color
                child: InkWell(
                  splashColor: Colors.red,
                  onTap: () async {
                    final AdminUsersStore adminUsersStore = Provider.of<AdminUsersStore>(context, listen: false);

                    await Navigator.push<void>(
                      context,
                      MaterialPageRoute(builder: (context) => ChangeNotifierProvider.value(
                        value: adminUsersStore,
                        child: AdminUserEditPage(user: user,),
                      ))
                    );
                  },
                  child: const SizedBox(width: 32, height: 32, child: Icon(Icons.edit, color: Colors.white,)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}