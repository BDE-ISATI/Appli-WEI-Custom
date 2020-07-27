import 'dart:convert';
import 'dart:io';

import 'package:appli_wei_custom/models/challenge.dart';
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
                        if (!_sendingValidation)
                          Button(
                            onPressed: (widget.challenge.isWaitingValidation || widget.challenge.numberLeft <= 0) ? null : () async {
                              await _sendValidationProof(context);
                            },
                            text: "Valider le défis",
                          )
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
      });
    }
  }

}