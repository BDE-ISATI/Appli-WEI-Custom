import 'dart:convert';
import 'dart:io';

import 'package:appli_wei_custom/services/user_service.dart';
import 'package:appli_wei_custom/src/providers/user_store.dart';
import 'package:appli_wei_custom/src/shared/widgets/button.dart';
import 'package:appli_wei_custom/src/shared/widgets/user_profile_picture.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ModifyProfilePicture extends StatefulWidget {
  @override
  _ModifyProfilePictureState createState() => _ModifyProfilePictureState();
}

class _ModifyProfilePictureState extends State<ModifyProfilePicture> {
  bool _isUploadingPofilePicture = false;
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Consumer<UserStore>(
      builder: (context, userStore, child) {
        final isUploadingPofilePicture = _isUploadingPofilePicture;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isUploadingPofilePicture) 
              const CircularProgressIndicator()
            else 
              ClipRRect(
                  borderRadius: BorderRadius.circular(48),
                  child: const UserProfilePicture(size: 96.0,)
              ),
            
            if (_errorMessage.isNotEmpty) 
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Flexible(child: Text(_errorMessage)),
              )
            else 
              const SizedBox(width: 25,),
            
            Button(
              onPressed: isUploadingPofilePicture ? null : () async {
                await _updateProfilePicture();
              },
              text: "Modifier",
            )
          ],
        );
      },
    );
  }

  Future _updateProfilePicture() async {
    setState(() {
      _isUploadingPofilePicture = true;
    });

    final File image = await FilePicker.getFile(type: FileType.image);
    
    if (image == null) {
      setState(() {
        _isUploadingPofilePicture = false;
      });
      return;
    }


    final bytes = await image.readAsBytes();
    final String base64Image = base64Encode(bytes);
    final UserStore userStore = Provider.of<UserStore>(context, listen: false);

    try {
      await UserService.instance.updateProfilePicture(userStore.authentificationHeader, base64Image);

      userStore.updateProfilePicture(base64Image);
      
      setState(() {
        _isUploadingPofilePicture = false;
      });
    } catch (e) {
      setState(() {
        _isUploadingPofilePicture = false;
        _errorMessage = e.toString();
      });
    }
  }
}