import 'dart:convert';

import 'package:appli_wei_custom/models/team.dart';
import 'package:appli_wei_custom/services/team_service.dart';
import 'package:appli_wei_custom/src/providers/user_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TeamImage extends StatelessWidget {
  const TeamImage({Key key, @required this.team, this.height, this.width, this.boxFit}) : super(key: key);

  final Team team;

  final double height;
  final double width;
  final BoxFit boxFit;

  @override
  Widget build(BuildContext context) {
    return Consumer<UserStore>(
      builder: (context, userStore, child) {
        if (team.image == null) {
          return FutureBuilder(
            future: TeamService.instance.getTeamImage(userStore.authentificationHeader, team.id, team.imageId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (!snapshot.hasData) {
                  return Image(
                      image: const AssetImage("assets/logo.jpg"), 
                      height: height,
                      width: width,
                      fit: boxFit
                  );
                }

                team.image = MemoryImage(base64Decode(snapshot.data as String));

                return Image(
                  image: team.image,
                  height: height,
                  width: width,
                  fit: boxFit,
                );
              }

              return const Center(child: CircularProgressIndicator(),);
            },
          );
        }

        return Image(
          image: team.image,
          height: height,
          width: width,
          fit: boxFit,
        );
      },
    );
  }
}