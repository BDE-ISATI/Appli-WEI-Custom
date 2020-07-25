import 'package:appli_wei_custom/models/user.dart';
import 'package:appli_wei_custom/services/authentication_serive.dart';
import 'package:appli_wei_custom/src/shared/widgets/button.dart';
import 'package:appli_wei_custom/src/shared/widgets/form_text_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginDialog extends StatefulWidget {
  @override 
  _LoginDialogState createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _loading = false;
  String _statusMessage = "N'oubliez pas de remplir tous les champs pour vous connecter";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          top: 32.0,
          bottom: MediaQuery.of(context).viewInsets.bottom + 25,
          left: 16.0,
          right: 16.0
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32.0),
            topRight: Radius.circular(32.0)
          )
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: double.infinity,
                child: Text(_statusMessage),
              ),
              if (!_loading) ...{
                FormTextInput(
                  controller: _usernameController,
                  inputType: TextInputType.emailAddress,
                  hintText: "Entrez votre email",
                  labelText: "Email",
                  validator: (String value) {
                    if (value.isEmpty) {
                      return "Veuillez rentrer une adresse mail";
                    }

                    return null;
                  },
                ),
                FormTextInput(
                  controller: _passwordController,
                  hintText: "Entrez votre mot de passe",
                  labelText: "Mot de Passe",
                  obscureText: true,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return "Veuillez rentrer un mot de passe";
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 32,),
                Button(
                  onPressed: () async { await _login(); },
                  text: "Connexion",
                )
              }
              else ...{
                const SizedBox(height: 16,),
                const Center(child: CircularProgressIndicator())
              }
            ],
          ),
        ),
      ),
    );
  }

  Future _login() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    setState(() {
      _statusMessage = "Connexion en cours...";
      _loading = true;
    });

    final String email = _usernameController.text;
    final String password = _passwordController.text;

    try {
      final User loggedUser = await AuthenticationService.instance.loggin(email, password);

      Navigator.of(context).pop(loggedUser);
    } 
    catch (e) {
      setState(() {
        _statusMessage = "Erreur lors de la connexion : ${e.message}";
        _loading = false;
      });
    }

    _passwordController.clear();
  }
} 