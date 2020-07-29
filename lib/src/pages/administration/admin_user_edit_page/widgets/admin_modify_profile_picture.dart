import 'dart:convert';
import 'dart:io';

import 'package:appli_wei_custom/models/user.dart';
import 'package:appli_wei_custom/src/shared/widgets/button.dart';
import 'package:appli_wei_custom/src/shared/widgets/user_profile_picture.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class AdminModifyProfilePicture extends StatefulWidget {
  const AdminModifyProfilePicture({Key key, @required this.user}) : super(key: key);
  
  final User user;

  @override
  _AdminModifyProfilePictureState createState() => _AdminModifyProfilePictureState();
}

class _AdminModifyProfilePictureState extends State<AdminModifyProfilePicture> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(48),
          child: UserProfilePicture(user: widget.user, size: 96.0,)
        ),
        const SizedBox(width: 25,),
        Button(
          onPressed: () async {
            await _updateProfilePicture();
          },
          text: "Modifier",
        )
      ],
    );
  }

  Future _updateProfilePicture() async {
    final File image = await FilePicker.getFile(type: FileType.image);
    
    if (image == null) {
      return;
    }

    final bytes = await image.readAsBytes();
    final String base64Image = base64Encode(bytes);
    
    setState(() {
      widget.user.profilePictureId = "modified";
      widget.user.profilePicture = base64Image;
    });
  }
}