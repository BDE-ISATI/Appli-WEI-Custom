import 'package:flutter/material.dart';

class TopNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 8),
      child: Align(
        alignment: Alignment.topLeft,
        child: SizedBox(
          height: 52,
          width: 52,
          child: ClipOval(
            child: Material(
              color: Colors.white, // button color
              child: InkWell(
                splashColor: Colors.red,
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const SizedBox(width: 48, height: 48, child: Icon(Icons.arrow_back, color: Colors.black87,)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}