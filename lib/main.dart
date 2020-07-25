import 'package:appli_wei_custom/models/user.dart';
import 'package:appli_wei_custom/src/pages/main_page/main_page.dart';
import 'package:appli_wei_custom/src/providers/user_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,

        primaryColor: const Color(0xfff70c36), // These are the color of the ISATI
        primarySwatch: Colors.grey,
        accentColor: const Color(0xfff70c36),
        cardColor: Colors.white,

        appBarTheme: const AppBarTheme(
          color:  Colors.white,
          brightness: Brightness.light,
          iconTheme: IconThemeData(color: Color(0xfff70c36)),
          elevation: 0,
        ),

        // fontFamily: "Futura Light",
        textTheme: const TextTheme(
          headline1: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w800, fontFamily: "Futura Light", color: Colors.black87),
          headline2: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w300, color: Colors.black87),
          headline3: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w300, color: Colors.black87),
          headline4: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w300, color: Colors.black38),
        ),

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MultiProvider(
        providers: [
          // TODO: remove this user logged one
          ChangeNotifierProvider(create: (context) => UserStore(
            user: User.fromMap(<String, dynamic>{
              'id': '5f1aaad10cb5aa794889bdd7',
              'firstName': 'Baptiste',
              'lastName': 'NomBaptise',
              'username': 'userbapt',
              'score': 5,
              'email': 'baptiste@mailuniv.fr',
              'passwordHash': 'i4auBaSclYMte/0gZ3WRM/k83+H0rPr1Mzp++to0dq7xg/Gcom8xFc+BztIsiWXOjV3sjl+I53pm3pO/6ItGRw=='
            })
            ..teamName = "Poke Thibault"
          ),)
        ],
        child: MainPage(),
      ),
    );
  }
}