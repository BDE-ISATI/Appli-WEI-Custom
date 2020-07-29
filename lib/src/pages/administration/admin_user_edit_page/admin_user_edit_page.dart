import 'package:appli_wei_custom/models/user.dart';
import 'package:appli_wei_custom/src/pages/administration/admin_user_edit_page/widgets/admin_modify_profile_picture.dart';
import 'package:appli_wei_custom/src/pages/administration/admin_user_edit_page/widgets/admin_user_form.dart';
import 'package:appli_wei_custom/src/shared/widgets/top_navigation_bar.dart';
import 'package:flutter/material.dart';

class AdminUserEditPage extends StatelessWidget {
  const AdminUserEditPage({Key key, @required this.user}) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TopNavigationBar(),
            Text("Modification du profil", style: Theme.of(context).textTheme.headline1,),
            const SizedBox(height: 16.0,),
            AdminModifyProfilePicture(user: user,),
            const SizedBox(height: 8.0,),
            Expanded(
              child: AdminUserForm(user: user,)
            )
          ],
        ),
      ),
    );
  }
}