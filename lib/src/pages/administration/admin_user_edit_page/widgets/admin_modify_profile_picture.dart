import 'dart:convert';
import 'dart:io';
import 'package:universal_html/prefer_universal/html.dart' as html;

import 'package:appli_wei_custom/models/user.dart';
import 'package:appli_wei_custom/src/shared/widgets/button.dart';
import 'package:appli_wei_custom/src/shared/widgets/user_profile_picture.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
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
    MemoryImage memoryImage;

    if (kIsWeb) {
      final html.FileUploadInputElement input = html.FileUploadInputElement();
      input.accept = 'image/*';
      input.click();
      
      await input.onChange.first;
      
      if (input.files.isEmpty) {
         return null;
      }

      final reader = html.FileReader();
      reader.readAsDataUrl(input.files[0]);
      
      await reader.onLoad.first;
      
      final String encoded = reader.result as String;
      final String base64Image = encoded.replaceFirst(RegExp('data:image/[^;]+;base64,'), '');

      memoryImage = MemoryImage(base64Decode(base64Image));
    }
    else {
      final File image = await FilePicker.getFile(type: FileType.image);
      
      if (image == null) {
        return;
      }
      
      final bytes = await image.readAsBytes();
      memoryImage = MemoryImage(bytes);
    }  
    
    setState(() {
      widget.user.profilePictureId = "modified";
      widget.user.profilePicture = memoryImage;
    });
  }
}