import 'package:appli_wei_custom/models/administration/admin_challenge.dart';
import 'package:appli_wei_custom/src/providers/admin_challenges_store.dart';
import 'package:appli_wei_custom/src/shared/widgets/button.dart';
import 'package:appli_wei_custom/src/shared/widgets/form_text_input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminChallengeForm extends StatefulWidget {
  const AdminChallengeForm({Key key, @required this.challenge}) : super(key: key);

  final AdminChallenge challenge;

  @override 
  _AdminChallengeFormState createState() => _AdminChallengeFormState();
}

class _AdminChallengeFormState extends State<AdminChallengeForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();
  final TextEditingController _numberOfRepetitionController = TextEditingController();


  bool _loading = false;
  String _statusMessage = "";

  @override
  void initState() {
    super.initState();

    _nameController.text = widget.challenge.name;
    _descriptionController.text = widget.challenge.description;
    _valueController.text = widget.challenge.value.toString();
    _numberOfRepetitionController.text = widget.challenge.numberOfRepetitions.toString();
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
                      FormTextInput(
                        controller: _nameController,
                        hintText: "Entrez le nom du défis",
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
                        controller: _descriptionController,
                        inputType: TextInputType.multiline,
                        hintText: "Entrez la description du défis",
                        labelText: "Description",
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Veuillez rentrer une description";
                          }

                          return null;
                        },
                      ),
                      // ignore: equal_elements_in_set
                      const SizedBox(height: 8.0,),
                      FormTextInput(
                        controller: _valueController,
                        inputType: TextInputType.number,   
                        hintText: "Entrez la valeur du défis",
                        labelText: "Valeur",
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Veuillez rentrer une valeur";
                          }

                          if (int.parse(value) < 1) {
                            return "Vous devez avoir une valeur supérieur à 0";
                          }

                          return null;
                        },
                      ),
                      // ignore: equal_elements_in_set
                      const SizedBox(height: 8.0,),
                      FormTextInput(
                        controller: _numberOfRepetitionController,
                        inputType: TextInputType.number,   
                        hintText: "Entrez le nombre de répétitions du défis",
                        labelText: "Nombre de répétitions",
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Veuillez rentrer un nombre de répétitions";
                          }

                          if (int.parse(value) < 1) {
                            return "Vous devez avoir une valeur supérieur à 0";
                          }
                          
                          return null;
                        },
                      ),
                      // ignore: equal_elements_in_set
                      const SizedBox(height: 8.0,),
                      CheckboxListTile(
                        title: const Text("Est visible"),
                        value: widget.challenge.isVisible,
                        onChanged: (newValue) { 
                          setState(() {
                            widget.challenge.isVisible = newValue; 
                          }); 
                        },
                        controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                      ),
                      // ignore: equal_elements_in_set
                      const SizedBox(height: 8.0,),
                      CheckboxListTile(
                        title: const Text("Est pour équipe"),
                        value: widget.challenge.isForTeam,
                        onChanged: (newValue) { 
                          setState(() {
                            widget.challenge.isForTeam = newValue; 
                          }); 
                        },
                        controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
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
    if (widget.challenge.id != null) {
      return Button(
        onPressed: _loading ? null : () async {
          await _updateChallenge();
        },
        text: "Enregister les modifications",
      );
    }
    
    return Button(
      onPressed: _loading ? null : () async {
        await _createNewChallenge();
      },
      text: "Ajouter",
    );
  }
  
  Future _createNewChallenge() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    setState(() {
      _loading = true;
    });
    
    widget.challenge.name = _nameController.text;
    widget.challenge.description = _descriptionController.text;
    widget.challenge.value = int.parse(_valueController.text);
    widget.challenge.numberOfRepetitions = int.parse(_numberOfRepetitionController.text);

    final AdminChallengesStore adminChallengesStore = Provider.of<AdminChallengesStore>(context, listen: false);
    final String response = await adminChallengesStore.createChallenge(widget.challenge);

    if (response.isEmpty) {
      setState(() {
        _statusMessage = "Défis créé avec succès";
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

  Future _updateChallenge() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    setState(() {
      _loading = true;
    });
    
    widget.challenge.name = _nameController.text;
    widget.challenge.description = _descriptionController.text;
    widget.challenge.value = int.parse(_valueController.text);
    widget.challenge.numberOfRepetitions = int.parse(_numberOfRepetitionController.text);

    final AdminChallengesStore adminChallengesStore = Provider.of<AdminChallengesStore>(context, listen: false);
    final String response = await adminChallengesStore.updateChallenge(widget.challenge);

    if (response.isEmpty) {
      setState(() {
        _statusMessage = "Défis mis à jour avec succès";
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