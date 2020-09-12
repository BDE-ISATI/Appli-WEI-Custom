import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:appli_wei_custom/models/waiting_challenges.dart';
import 'package:appli_wei_custom/services/challenge_service.dart';
import 'package:appli_wei_custom/src/pages/waiting_challenge_details_page/widgets/waiting_challenge_title.dart';
import 'package:appli_wei_custom/src/providers/user_store.dart';
import 'package:appli_wei_custom/src/shared/widgets/button.dart';
import 'package:appli_wei_custom/src/shared/widgets/challenge_images/waiting_challenge_image.dart';
import 'package:appli_wei_custom/src/shared/widgets/top_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class WaitingChallengeDetailsPage extends StatefulWidget {
  const WaitingChallengeDetailsPage({Key key, @required this.challenge, this.heroTag}) : super(key: key);
  
  final WaitingChallenge challenge;
  final String heroTag;

  @override
  _WaitingChallengeDetailsPageState createState() => _WaitingChallengeDetailsPageState();
}

class _WaitingChallengeDetailsPageState extends State<WaitingChallengeDetailsPage> {
  bool _isValidatingChallenge = false;

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
                  flex: 2,
                  child: Hero(
                    tag: widget.heroTag,
                    child: SizedBox(
                      width: double.infinity,
                      child: WaitingChallengeImage(
                        challenge: widget.challenge,
                        boxFit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 114, left: 32, right: 32, bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Text(widget.challenge.description),
                                const SizedBox(height: 16.0,),
                                Consumer<UserStore>(
                                  builder: (context, userStore, child) {
                                    return FutureBuilder(
                                      future: ChallengeService.instance.getProofImage(userStore.authentificationHeader, widget.challenge.id, widget.challenge.playerId),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState == ConnectionState.done) {
                                          if (!snapshot.hasData) {
                                            return const Center(child: Text("Il n'y a pas de preuve..."),);
                                          }

                                          if (snapshot.hasError) {
                                            return Center(child: Text("Erreur lors de la récupération de la preuve : ${snapshot.error.toString()}"),);
                                          }

                                          final String data = snapshot.data as String;
                                          final bytes = base64Decode(data);
                                          final utf8bytes = utf8.encode("type=video");

                                          if (bytes[0] == utf8bytes[0] &&
                                              bytes[1] == utf8bytes[1] &&
                                              bytes[2] == utf8bytes[2] &&
                                              bytes[3] == utf8bytes[3] &&
                                              bytes[4] == utf8bytes[4] &&
                                              bytes[5] == utf8bytes[5] &&
                                              bytes[6] == utf8bytes[6] &&
                                              bytes[7] == utf8bytes[7] &&
                                              bytes[8] == utf8bytes[8] &&
                                              bytes[9] == utf8bytes[9]) {
                                            final videoBytes = bytes.sublist(10);
                                            
                                            return _buildVideoPlayer(videoBytes);
                                          }
                                          else {
                                            return ClipRRect(
                                              borderRadius: BorderRadius.circular(32.0),
                                              child: Image.memory(
                                                bytes,
                                                fit: BoxFit.contain
                                              ),
                                            );
                                          }
                                        }

                                        return const Center(child: CircularProgressIndicator(),);
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (_isValidatingChallenge)
                          const Center(child: CircularProgressIndicator(),)
                        else 
                          Button(
                            onPressed: () async {
                              await _validateChallenge();
                            },
                            text: "Valider le défis",
                          )
                      ],
                    ),
                  ),
                )
              ],
            ) 
          ),
          TopNavigationBar(),
          // The middle
          Padding(
            padding: const EdgeInsets.only(top: 96.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: WaitingChallengeTitle(challenge: widget.challenge,),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future _validateChallenge() async {
    setState(() {
      _isValidatingChallenge = true;
    });

    final UserStore userStore = Provider.of<UserStore>(context, listen: false);

    try {
      await ChallengeService.instance.validateChallengeForUser(userStore.authentificationHeader, widget.challenge.id, widget.challenge.playerId);

      Navigator.of(context).pop(true);
    }
    catch (e) {
      setState(() {
        _isValidatingChallenge = false;
      });
    }
  }

  Widget _buildVideoPlayer(Uint8List videoBytes) {
    return FutureBuilder(
      future: _buildVideoController(videoBytes),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (!snapshot.hasData) {
            return const Center(child: Text("Erreur lors de la lecture de la video..."),);
          }
          
          final VideoPlayerController videoController = snapshot.data as VideoPlayerController;

          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Button(
                    onPressed: () {
                      videoController.seekTo(const Duration());
                      videoController.play();
                    }, 
                    text: "Lancer la vidéo",
                  ),
                  Button(
                    onPressed: () {
                      videoController.pause();
                    }, 
                    text: "Pause",
                  ),
                ],
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width / videoController.value.aspectRatio,
                child: VideoPlayer(videoController)
              )
            ],
          );
        }

        return const Center(child: CircularProgressIndicator(),);
      }
    ,);
  }

  Future<VideoPlayerController> _buildVideoController(Uint8List videoBytes) async {
    final String path = (await getTemporaryDirectory()).path;
    final File video = File("$path/wei_proof_video");
    
    await video.writeAsBytes(videoBytes);

    final VideoPlayerController videoController = VideoPlayerController.file(video);
    await videoController.initialize();

    return videoController;
  } 
}