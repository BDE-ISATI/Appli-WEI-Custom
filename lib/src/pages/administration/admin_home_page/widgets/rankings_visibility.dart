import 'package:appli_wei_custom/models/administration/game_settings.dart';
import 'package:appli_wei_custom/services/game_settings_service.dart';
import 'package:appli_wei_custom/src/providers/user_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RankingsVisibility extends StatefulWidget {
  @override
  _RankingsVisibilityState createState() => _RankingsVisibilityState();
}

class _RankingsVisibilityState extends State<RankingsVisibility> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserStore>(
      builder: (context, userStore, child) {
        return FutureBuilder(
          future: GameSettingsService.instance.getSettings(userStore.authentificationHeader),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (!snapshot.hasData) {
                return const Text("Impossible de récupérer les paramètres de visibilité des classements.");
              }

              if (snapshot.hasError) {
                return Text("Une erreur est survenue : ${snapshot.error.toString()}");
              }

              return _buildCheckBoxes(userStore, snapshot.data as GameSettings);
            }
            
            return const Center(child: CircularProgressIndicator());
          },
        );
      },
    );
  }

  Widget _buildCheckBoxes(UserStore userStore, GameSettings settings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CheckboxListTile(
          title: const Text("Rendre visible le classement des joueurs"),
          value: settings.isUsersRankingVisible,
          onChanged: (newValue) async {
            await GameSettingsService.instance.toggleUsersRankingVisibility(userStore.authentificationHeader); 
            
            setState(() {}); 
          },
          controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
        ),
        const SizedBox(height: 8.0,),
        CheckboxListTile(
          title: const Text("Rendre visible le classement des équipes"),
          value: settings.isTeamsRankingVisible,
          onChanged: (newValue) async { 
            await GameSettingsService.instance.toggleTeamsRankingVisibility(userStore.authentificationHeader);

            setState(() {}); 
          },
          controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
        ),
      ],
    );
  }
}