import 'package:appli_wei_custom/models/user.dart';
import 'package:appli_wei_custom/services/authentication_serive.dart';
import 'package:appli_wei_custom/src/providers/user_store.dart';
import 'package:appli_wei_custom/src/shared/widgets/button.dart';
import 'package:appli_wei_custom/src/shared/widgets/form_text_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ModifyPassword extends StatefulWidget {
  @override 
  _ModifyPasswordState createState() => _ModifyPasswordState();
}

class _ModifyPasswordState extends State<ModifyPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _newPasswordConfirmationController = TextEditingController();


  bool _loading = false;
  String _statusMessage = "";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(0.0),
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
                  controller: _oldPasswordController,
                  hintText: "Entrez votre ancien mot de passe",
                  labelText: "Mot de Passe",
                  obscureText: true,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return "Veuillez rentrer un mot de passe";
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 8.0,),
                FormTextInput(
                  controller: _newPasswordController,
                  hintText: "Entrez votre nouveau mot de passe",
                  labelText: "Nouveau Mot de Passe",
                  obscureText: true,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return "Veuillez rentrer un nouveau mot de passe";
                    }

                    return null;
                  },
                ),
                // ignore: equal_elements_in_set
                const SizedBox(height: 8.0,),
                FormTextInput(
                  controller: _newPasswordConfirmationController,
                  hintText: "Confirmation votre nouveau mot de passe",
                  labelText: "Confirmation Mot de Passe",
                  obscureText: true,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return "Veuillez rentrer la confirmation du mot de passe";
                    }

                    if (_newPasswordController.text != value) {
                      return "Le nouveau de passe ne correspond pas à la confirmation";
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 32,),
                Button(
                  onPressed: () async { await _changePassword(); },
                  text: "Changer le mot de passe",
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

  Future _changePassword() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    setState(() {
      _statusMessage = "Changement en cours...";
      _loading = true;
    });

    final String oldPassword = _oldPasswordController.text;
    final String newPassword = _newPasswordController.text;

    final UserStore userStore = Provider.of<UserStore>(context, listen: false);
    try {
      final String newPasswordHash = await AuthenticationService.instance.updatePassword(userStore.authentificationHeader, oldPassword, newPassword);

      userStore.updatePassword(newPasswordHash);
      
    } 
    catch (e) {
      setState(() {
        _statusMessage = "Erreur lors de la modification : ${e.message}";
        _loading = false;
      });
    }

    _oldPasswordController.clear();
  }
} 