import 'package:flutter/material.dart';

/// This is a simple splash screen showing the 
/// icon on a background with the accent color
/// 
/// It's used when we check the user's connection state
class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).accentColor,
        child: const Center(
          child:Image (
            image: AssetImage('assets/images/logo_white.png'),
            height: 128,
          ),
        ),
      ),
    );
  }
}