import 'package:appli_wei_custom/models/user.dart';
import 'package:appli_wei_custom/services/authentication_serive.dart';
import 'package:appli_wei_custom/src/shared/widgets/button.dart';
import 'package:appli_wei_custom/src/shared/widgets/form_text_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterDialog extends StatefulWidget {
  @override 
  _RegisterDialogState createState() => _RegisterDialogState();
}

class _RegisterDialogState extends State<RegisterDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmationController = TextEditingController();

  bool _loading = false;
  String _statusMessage = "N'oubliez pas de remplir tous les champs pour vous inscrire";

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
                  controller: _emailController,
                  inputType: TextInputType.emailAddress,
                  hintText: "Entrez votre email",
                  labelText: "Email",
                  validator: (String value) {
                    if (value.isEmpty || !value.contains('etudiant.univ-rennes1.fr')) {
                      return "Veuillez rentrer une adresse mail étudiante";
                    }

                    return null;
                  },
                ),
                FormTextInput(
                  controller: _firstNameController,
                  hintText: "Entrez votre prénom",
                  labelText: "Prénom",
                  validator: (String value) {
                    if (value.isEmpty) {
                      return "Veuillez rentrer un prénom";
                    }

                    return null;
                  },
                ),
                FormTextInput(
                  controller: _lastNameController,
                  hintText: "Entrez votre nom",
                  labelText: "Nom",
                  validator: (String value) {
                    if (value.isEmpty) {
                      return "Veuillez rentrer un nom";
                    }

                    return null;
                  },
                ),
                FormTextInput(
                  controller: _usernameController,
                  hintText: "Entrez votre pseudo",
                  labelText: "Pseudo",
                  validator: (String value) {
                    if (value.isEmpty) {
                      return "Veuillez rentrer un pseudo";
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
                FormTextInput(
                  controller: _passwordConfirmationController,
                  hintText: "Confirmer votre mot de passe",
                  labelText: "Confirmation de mot de passe",
                  obscureText: true,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return "Veuillez rentrer une confirmation de mot de passe";
                    }

                    if (value != _passwordController.text) {
                      return "Le mot de passe et sa confirmation ne correspondent pas";
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 32,),
                Button(
                  onPressed: () async { await _register(); },
                  text: "Inscription",
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

  Future _register() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    setState(() {
      _statusMessage = "Inscription en cours...";
      _loading = true;
    });

    try {
      final String password = _passwordController.text;

      final User registeredUser = User(
        email: _emailController.text,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        username: _usernameController.text
      );
      
      await AuthenticationService.instance.register(registeredUser, password);

      Navigator.of(context).pop(true);
    } 
    catch (e) {
      setState(() {
        _statusMessage = "Erreur lors de l'inscription : ${e.message}";
        _loading = false;
      });
    }

    _passwordController.clear();
  }
} 