import 'package:appli_wei_custom/src/pages/modify_profile_page/widgets/modify_profile_picture.dart';
import 'package:flutter/material.dart';

class ModifyProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          ModifyProfilePicture()
        ],
      ),
    );
  }
}