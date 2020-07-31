import 'package:flutter/cupertino.dart';

int responsiveCrossAxisCount(BuildContext context) {
  final double width = MediaQuery.of(context).size.width;

  if (width > 1200) {
    return 6;
  }
  if (width > 1000) {
    return 5;
  }
  else if (width > 800) {
    return 4;
  }
  else if (width > 600) {
    return 3;
  }

  return 2;
}