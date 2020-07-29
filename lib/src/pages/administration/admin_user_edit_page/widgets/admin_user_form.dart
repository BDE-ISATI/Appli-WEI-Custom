import 'package:appli_wei_custom/models/team.dart';
import 'package:appli_wei_custom/models/user.dart';
import 'package:appli_wei_custom/services/team_service.dart';
import 'package:appli_wei_custom/src/providers/admin_users_store.dart';
import 'package:appli_wei_custom/src/providers/user_store.dart';
import 'package:appli_wei_custom/src/shared/widgets/button.dart';
import 'package:appli_wei_custom/src/shared/widgets/form_text_input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminUserForm extends StatefulWidget {
  const AdminUserForm({Key key, @required this.user}) : super(key: key);

  final User user;

  @override 
  _AdminUserFormState createState() => _AdminUserFormState();
}

class _AdminUserFormState extends State<AdminUserForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _scoreController = TextEditingController();

  bool _userIsCaptain = false;

  bool _loading = false;
  String _statusMessage = "";

  @override
  void initState() {
    super.initState();

    _firstNameController.text = widget.user.firstName;
    _lastNameController.text = widget.user.lastName;
    _scoreController.text = widget.user.score.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 52.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_statusMessage.isNotEmpty)
                      SizedBox(
                        width: double.infinity,
                        child: Text(_statusMessage),
                      ),
                    if (!_loading) ...{
                      _buildTeamDropDown(),
                      FormTextInput(
                        controller: _firstNameController,
                        hintText: "Entrez le prénom de l'utilisateur",
                        labelText: "Prénom",
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Veuillez rentrer un prénom";
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 8.0,),
                      FormTextInput(
                        controller: _lastNameController,
                        hintText: "Entrez le nom de l'utilisateur",
                        labelText: "Nom",
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Veuillez rentrer un nom";
                          }

                          return null;
                        },
                      ),
                      // ignore: equal_elements_in_set
                      const SizedBox(height: 8.0,),
                      FormTextInput(
                        controller: _scoreController,
                        inputType: TextInputType.number,   
                        hintText: "Entrez le score du joueur",
                        labelText: "Score",
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Veuillez rentrer un score";
                          }

                          if (int.parse(value) < 0) {
                            return "Vous devez avoir une valeur positive";
                          }

                          return null;
                        },
                      ),
                      
                    }
                    else ...{
                      const SizedBox(height: 16,),
                      const Center(child: CircularProgressIndicator())
                    }
                  ],
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: double.infinity,
            child: Button(
              onPressed: _loading ? null : () async {
                await _updateUser();
              },
              text: "Enregister les modifications",
            ),
          )
        )
      ],
    );
  }

  Widget _buildTeamDropDown() {
    final String authorizationHeader = Provider.of<UserStore>(context, listen: false).authentificationHeader;

    return FutureBuilder(
      future: TeamService.instance.getTeams(authorizationHeader),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (!snapshot.hasData || snapshot.hasError) {
            return const Center(child: Text("Impossible de récupérer les équipes..."),);
          }

          final List<Team> teams = snapshot.data as List<Team>;
          final List<DropdownMenuItem<String>> dropdownItems = [
            const DropdownMenuItem<String>(
              child: Text("Sans équipe"),
            )
          ];
          
          for (final team in teams) {
            if (team.captainId == widget.user.id) {
              _userIsCaptain = true;
            }

            dropdownItems.add(DropdownMenuItem<String>(
              value: team.id,
              child: Text(team.name),
            ));
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButton<String>(
                isExpanded: true,
                hint: const Text("Veuillez choisir une équipe"),
                onChanged: (newValue) {
                  setState(() {
                    widget.user.teamId = newValue;
                  });
                },
                value: widget.user.teamId,
                items: dropdownItems
              ),
              const SizedBox(height: 8.0,),
              _buildRoleDropdown()
            ],
          );
        }

        return const Center(child: LinearProgressIndicator());
      },
    );
  }
  
  Widget _buildRoleDropdown() {
    return DropdownButton<String>(
      isExpanded: true,
      hint: const Text("Veuillez choisir un rôle (Note : les capitaines sont attribué directement dans les équipes)"),
      onChanged: (newValue) {
        setState(() {
          widget.user.role = newValue;
        });
      },
      value: widget.user.role,
      items: [
        if (!_userIsCaptain) ...{
          DropdownMenuItem<String>(
            value: UserRoles.defaultRole,
            child: const Text("Joueur"),
          ),
          DropdownMenuItem<String>(
            value: UserRoles.administrator,
            child: const Text("Administrateur"),
          )
        }
        else ...{
          DropdownMenuItem<String>(
            value: UserRoles.captain,
            child: const Text("Capitaine"),
          ),
          DropdownMenuItem<String>(
            value: UserRoles.administrator,
            child: const Text("Administrateur"),
          )
        }
      ]
    );
  }

  Future _updateUser() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    setState(() {
      _loading = true;
    });
    
    widget.user.firstName = _firstNameController.text;
    widget.user.lastName = _lastNameController.text;
    widget.user.score = int.parse(_scoreController.text);

    final AdminUsersStore adminUsersStore = Provider.of<AdminUsersStore>(context, listen: false);
    final String response = await adminUsersStore.updateUser(widget.user);

    if (response.isEmpty) {
      setState(() {
        _statusMessage = "Utilisateur mis à jour avec succès";
        _loading = false;
      });
    }
    else {
      setState(() {
        _statusMessage = "Une erreur est survenue : $response";
        _loading = false;
      });
    }
  }
} 