import 'package:appli_wei_custom/models/team.dart';
import 'package:appli_wei_custom/models/user.dart';
import 'package:appli_wei_custom/services/team_service.dart';
import 'package:appli_wei_custom/src/providers/admin_teams_store.dart';
import 'package:appli_wei_custom/src/providers/user_store.dart';
import 'package:appli_wei_custom/src/shared/widgets/button.dart';
import 'package:appli_wei_custom/src/shared/widgets/form_text_input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminTeamForm extends StatefulWidget {
  const AdminTeamForm({Key key, @required this.team}) : super(key: key);

  final Team team;

  @override 
  _AdminTeamFormState createState() => _AdminTeamFormState();
}

class _AdminTeamFormState extends State<AdminTeamForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _scoreController = TextEditingController();

  bool _loading = false;
  String _statusMessage = "";

  bool _captainChanged = false;

  @override
  void initState() {
    super.initState();

    _nameController.text = widget.team.name;
    _scoreController.text = widget.team.score.toString();
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
                      _buildCaptainDropdown(),
                      FormTextInput(
                        controller: _nameController,
                        hintText: "Entrez le nom de l'équipe",
                        labelText: "Nom",
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Veuillez rentrer un nom";
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 8.0,),
                      FormTextInput(
                        controller: _scoreController,
                        inputType: TextInputType.number,   
                        hintText: "Entrez le score de l'équipe",
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
            child: _buildButton(),
          )
        )
      ],
    );
  }

  Widget _buildButton() {
    if (widget.team.id != null) {
      return Button(
        onPressed: _loading ? null : () async {
          await _updateTeam();
        },
        text: "Enregister les modifications",
      );
    }
    
    return Button(
      onPressed: _loading ? null : () async {
        await _createNewTeam();
      },
      text: "Ajouter",
    );
  }

  Widget _buildCaptainDropdown() {
    final String authorizationHeader = Provider.of<UserStore>(context, listen: false).authentificationHeader;

    return FutureBuilder(
      future: TeamService.instance.getAvailableCaptains(authorizationHeader),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (!snapshot.hasData || snapshot.hasError) {
            return const Center(child: Text("Impossible de récupérer les capitaines disponibles..."),);
          }

          final List<User> users = snapshot.data as List<User>;
          final List<DropdownMenuItem<String>> dropdownItems = [
            const DropdownMenuItem<String>(
              child: Text("Pas de capitaine"),
            ),
            if (widget.team.captainId != null && !_captainChanged)
              DropdownMenuItem<String>(
                value: widget.team.captainId,
                child: Text(widget.team.captainName)
              )
          ];
          
          for (final user in users) {
            dropdownItems.add(DropdownMenuItem<String>(
              value: user.id,
              child: Text("${user.firstName} ${user.lastName}"),
            ));
          }

          return DropdownButton<String>(
            isExpanded: true,
            hint: const Text("Veuillez choisir un capitaine"),
            onChanged: (newValue) {
              setState(() {
                if (widget.team.captainId != newValue) {
                  _captainChanged = true;
                }

                widget.team.captainId = newValue;
              });
            },
            value: widget.team.captainId,
            items: dropdownItems
          );
        }

        return const Center(child: LinearProgressIndicator());
      },
    );
  }
  
  Future _createNewTeam() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    setState(() {
      _loading = true;
    });
    
    widget.team.name = _nameController.text;
    widget.team.score = int.parse(_scoreController.text);
    
    final AdminTeamsStore adminTeamsStore = Provider.of<AdminTeamsStore>(context, listen: false);
    final String response = await adminTeamsStore.createTeam(widget.team);

    if (response.isEmpty) {
      setState(() {
        _statusMessage = "Equipe créée avec succès";
        _captainChanged = false;
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

  Future _updateTeam() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    setState(() {
      _loading = true;
    });
    
    widget.team.name = _nameController.text;
    widget.team.score = int.parse(_scoreController.text);
    
    final AdminTeamsStore adminTeamsStore = Provider.of<AdminTeamsStore>(context, listen: false);
    final String response = await adminTeamsStore.updateTeam(widget.team);

    if (response.isEmpty) {
      setState(() {
        _statusMessage = "Equipe mis à jour avec succès";
        _captainChanged = false;
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