import 'package:appli_wei_custom/src/pages/modify_profile_page/widgets/modify_password.dart';
import 'package:appli_wei_custom/src/pages/modify_profile_page/widgets/modify_profile_picture.dart';
import 'package:flutter/material.dart';

class ModifyProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("Modification du profil", style: Theme.of(context).textTheme.headline1,),
          const SizedBox(height: 16.0,),
          ModifyProfilePicture(),
          ModifyPassword()
        ],
      ),
    );
  }
}