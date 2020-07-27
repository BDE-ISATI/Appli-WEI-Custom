import 'package:appli_wei_custom/models/user.dart';
import 'package:appli_wei_custom/src/pages/authentication_page/dialogs/login_dialog.dart';
import 'package:appli_wei_custom/src/providers/user_store.dart';
import 'package:appli_wei_custom/src/shared/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthenticationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Button(
              onPressed: () async {
                await _login(context);
              },
              text: "Connexion",
            ),
            Button(
              onPressed: () {},
              text: "Inscription",
            ),
          ],
        ),
      ),
    );
  }

  Future _login(BuildContext context) async {
    final User loggedUser = await showModalBottomSheet<User>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32.0),
      ),
      isScrollControlled: true,
      context: context, 
      builder: (context) => LoginDialog()
    ); 

    if (loggedUser != null) {
      Provider.of<UserStore>(context, listen: false).loginUser(loggedUser);
      // Navigator.of(context).pop();
    }

  }
}