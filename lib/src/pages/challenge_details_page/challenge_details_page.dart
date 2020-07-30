import 'dart:convert';
import 'dart:io';

import 'package:appli_wei_custom/models/challenge.dart';
import 'package:appli_wei_custom/models/team.dart';
import 'package:appli_wei_custom/models/user.dart';
import 'package:appli_wei_custom/services/challenge_service.dart';
import 'package:appli_wei_custom/services/team_service.dart';
import 'package:appli_wei_custom/src/pages/challenge_details_page/widgets/challenge_title.dart';
import 'package:appli_wei_custom/src/providers/user_store.dart';
import 'package:appli_wei_custom/src/shared/widgets/button.dart';
import 'package:appli_wei_custom/src/shared/widgets/challenge_images/challenge_image.dart';
import 'package:appli_wei_custom/src/shared/widgets/top_navigation_bar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChallengeDetailsPage extends StatefulWidget {
  const ChallengeDetailsPage({Key key, @required this.challenge, this.heroTag, this.showButtons = true}) : super(key: key);
  
  final Challenge challenge;
  final String heroTag;

  final bool showButtons;

  @override 
  _ChallengeDetailsPageState createState() => _ChallengeDetailsPageState();
}

class _ChallengeDetailsPageState extends State<ChallengeDetailsPage> {
  bool _sendingValidation = false;
  bool _isValidatingChallenge = false;
  String _errorMessage = "";

  String _teamToValidate = "";

  @override
  void initState() {
    super.initState();

    final UserStore userStore = Provider.of<UserStore>(context, listen: false);
    _teamToValidate = userStore.teamId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // First we add main widgets
          Positioned.fill(
            child: Column(
              children: [
                Expanded(
                  child: Hero(
                    tag: widget.heroTag,
                    child: SizedBox(
                      width: double.infinity,
                      child: ChallengeImage(
                        challenge: widget.challenge,
                        boxFit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 114, left: 32, right: 32, bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Text(widget.challenge.description),
                        ),
                        if (_errorMessage.isNotEmpty) 
                          Text(_errorMessage),
                        if (widget.showButtons)
                          if (!_sendingValidation && !_isValidatingChallenge) ...{
                            _buildTeamSelector(),
                            _buildButton(context)
                          }
                          else
                            const Center(child: CircularProgressIndicator(),)
                      ],
                    ),
                  ),
                )
              ],
            ) 
          ),
          TopNavigationBar(),
          // The middle
          Align(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: ChallengeTitle(challenge: widget.challenge,),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTeamSelector() {
    final UserStore userStore = Provider.of<UserStore>(context);

    if (!widget.challenge.isForTeam || !userStore.hasPermission(UserRoles.administrator)) {
      return Container();
    }

    return FutureBuilder(
      future: TeamService.instance.getTeams(userStore.authentificationHeader),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (!snapshot.hasData || snapshot.hasError) {
            return const Center(child: Text("Impossible de récupérer les équipes..."),);
          }

          final List<Team> teams = snapshot.data as List<Team>;
          final List<DropdownMenuItem<String>> dropdownItems = [];
          
          for (final team in teams) {
            dropdownItems.add(DropdownMenuItem<String>(
              value: team.id,
              child: Text(team.name),
            ));
          }

          return DropdownButton<String>(
            isExpanded: true,
            hint: const Text("Veuillez choisir une équipe"),
            onChanged: (newValue) {
              setState(() {
                _teamToValidate = newValue;
              });
            },
            value: _teamToValidate,
            items: dropdownItems
          );
        }

        return const Center(child: LinearProgressIndicator());
      },
    );
  }
  Widget _buildButton(BuildContext context) {
    final UserStore userStore = Provider.of<UserStore>(context);

    if (widget.challenge.isForTeam) {
      if (userStore.hasPermission(UserRoles.captain)) {
        return Button(
          onPressed: (widget.challenge.numberLeft <= 0 && !userStore.hasPermission(UserRoles.administrator)) ? null : () async {
            await _validateChallenge();
          },
          text: userStore.hasPermission(UserRoles.administrator) ? "Valider le défis pour cette équipe" : "Valider le défis",
        );
      }
    }

    return Button(
      onPressed: (widget.challenge.isWaitingValidation || widget.challenge.numberLeft <= 0) ? null : () async {
        await _sendValidationProof(context);
      },
      text: "Valider le défis",
    );
  }

  Future _sendValidationProof(BuildContext context) async {
    setState(() {
      _sendingValidation = true;
    });

    final File image = await FilePicker.getFile(type: FileType.image);
    
    if (image == null) {
      setState(() {
        _sendingValidation = false;
      });
      return;
    }


    final bytes = await image.readAsBytes();
    final String base64Image = base64Encode(bytes);
    final UserStore userStore = Provider.of<UserStore>(context, listen: false);

    try {
      await ChallengeService.instance.submitChallenge(userStore.authentificationHeader, widget.challenge.id, base64Image);

      setState(() {
        widget.challenge.isWaitingValidation = true;
        _sendingValidation = false;
      });
    } catch (e) {
      setState(() {
        _sendingValidation = false;
        _errorMessage = e.toString();
      });
    }
  }

  // NOTE : we can only validate team challenges from this point
  Future _validateChallenge() async {
    setState(() {
      _isValidatingChallenge = true;
    });

    final UserStore userStore = Provider.of<UserStore>(context, listen: false);

    try {
      await ChallengeService.instance.validateChallengeForTeam(userStore.authentificationHeader, widget.challenge.id, _teamToValidate);

      Navigator.of(context).pop(true);
    }
    catch (e) {
      setState(() {
        _isValidatingChallenge = false;
      });
    }
  }
}