import 'dart:convert';
import 'dart:io';

import 'package:appli_wei_custom/models/challenge.dart';
import 'package:appli_wei_custom/models/user.dart';
import 'package:appli_wei_custom/services/challenge_service.dart';
import 'package:appli_wei_custom/src/pages/challenge_details_page/widgets/challenge_title.dart';
import 'package:appli_wei_custom/src/providers/user_store.dart';
import 'package:appli_wei_custom/src/shared/widgets/button.dart';
import 'package:appli_wei_custom/src/shared/widgets/top_navigation_bar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChallengeDetailsPage extends StatefulWidget {
  const ChallengeDetailsPage({Key key, @required this.challenge, this.heroTag}) : super(key: key);
  
  final Challenge challenge;
  final String heroTag;

  @override 
  _ChallengeDetailsPageState createState() => _ChallengeDetailsPageState();
}

class _ChallengeDetailsPageState extends State<ChallengeDetailsPage> {
  bool _sendingValidation = false;
  bool _isValidatingChallenge = false;
  String _errorMessage = "";

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
                    child: Image.memory(
                      base64Decode(widget.challenge.imageBase64),
                      fit: BoxFit.cover,
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
                        if (!_sendingValidation && !_isValidatingChallenge)
                          _buildButton(context)
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

  Widget _buildButton(BuildContext context) {
    final UserStore userStore = Provider.of<UserStore>(context);

    if (widget.challenge.isForTeam) {
      if (userStore.hasPermission(UserRoles.captain)) {
        return Button(
          onPressed: (widget.challenge.numberLeft <= 0) ? null : () async {
            await _validateChallenge();
          },
          text: "Valider le défis",
        );
      }
    }
    else {
      return Button(
        onPressed: (widget.challenge.isWaitingValidation || widget.challenge.numberLeft <= 0) ? null : () async {
          await _sendValidationProof(context);
        },
        text: "Valider le défis",
      );
    }

    return Container();
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
      await ChallengeService.instance.validateChallengeForTeam(userStore.authentificationHeader, widget.challenge.id, userStore.teamId);

      Navigator.of(context).pop(true);
    }
    catch (e) {
      setState(() {
        _isValidatingChallenge = false;
      });
    }
  }
}