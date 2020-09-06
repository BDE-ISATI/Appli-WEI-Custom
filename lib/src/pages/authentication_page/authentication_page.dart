import 'package:appli_wei_custom/models/user.dart';
import 'package:appli_wei_custom/src/pages/authentication_page/dialogs/login_dialog.dart';
import 'package:appli_wei_custom/src/pages/authentication_page/dialogs/register_dialog.dart';
import 'package:appli_wei_custom/src/providers/user_store.dart';
import 'package:appli_wei_custom/src/shared/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthenticationPage extends StatefulWidget {
  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  String _statusMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_statusMessage.isNotEmpty) 
              Text(_statusMessage),
            Button(
              onPressed: () async {
                await _login();
              },
              text: "Connexion",
            ),
            Button(
              onPressed: () async {
                await _register();
              },
              text: "Inscription",
            ),
          ],
        ),
      ),
    );
  }

  Future _login() async {
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

  Future _register() async {
    final bool registered = await showModalBottomSheet<bool>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32.0),
      ),
      isScrollControlled: true,
      context: context, 
      builder: (context) => RegisterDialog()
    ); 

    if (registered != null && registered) {
      setState(() {
        _statusMessage = "Vous avez bien été enregistré. Attendez qu'une équipe vous soit attribuée.";
      });
    }
  }
}